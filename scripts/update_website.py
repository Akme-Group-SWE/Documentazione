#!/usr/bin/env python3
"""
update_website.py
Aggiorna automaticamente:
1. website/index.html: elenca i documenti PDF presenti in output/ (o compilati da src/)
   nelle rispettive sezioni (Candidatura, RTB, PB, Diapositive).
2. website/glossary.html: sincronizza le voci dal glossario (es. src/glossario.json)
   nelle corrispondenti sezioni alfabetiche (<section id="a">...<dl>).
"""

import sys
import re
import json
import urllib.parse
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SRC_DIR = REPO_ROOT / "src"
OUT_DIR = REPO_ROOT / "output"
WEBSITE_DIR = REPO_ROOT / "website"
INDEX_HTML = WEBSITE_DIR / "index.html"
GLOSSARY_HTML = WEBSITE_DIR / "glossary.html"
GLOSSARY_JSON = SRC_DIR / "glossario.json"


def extract_title_from_typ(typ_path):
    """Estrae il titolo del documento da un file .typ se disponibile."""
    if not typ_path.exists():
        return None
    try:
        content = typ_path.read_text(encoding="utf-8")
        # Cerca titolo: "..." o title: "..."
        m = re.search(r'(?:titolo|title)\s*:\s*"([^"]+)"', content)
        if m:
            return m.group(1).strip()
    except Exception:
        pass
    return None


def get_document_title(pdf_rel_path, typ_rel_path):
    """Determina il titolo più leggibile per il link del documento."""
    typ_full_path = SRC_DIR / typ_rel_path
    title = extract_title_from_typ(typ_full_path)
    if title:
        return title

    # Fallback su nome file
    stem = Path(pdf_rel_path).stem
    # Se il nome è una data YYYY-MM-DD
    date_match = re.match(r"^(\d{4})-(\d{2})-(\d{2})$", stem)
    if date_match:
        y, m, d = date_match.groups()
        parent_name = Path(pdf_rel_path).parent.name
        if "intern" in parent_name.lower():
            return f"Verbale Interno {d}/{m}/{y}"
        elif "estern" in parent_name.lower():
            return f"Verbale Esterno {d}/{m}/{y}"
        return f"Verbale {d}/{m}/{y}"

    return stem.replace("_", " ").title()


def map_path_to_section_and_category(rel_path):
    """
    Dato un percorso relativo (es. Candidatura/Verbali Interni/2026-10-15.pdf),
    restituisce la tupla (section_id, category_header).
    """
    parts = Path(rel_path).parts
    if not parts:
        return None, None

    section_folder = parts[0].lower()

    if "candidatura" in section_folder:
        sec_id = "candidatura"
        if len(parts) > 2 and "intern" in parts[1].lower():
            cat = "Verbali Interni"
        elif len(parts) > 2 and "estern" in parts[1].lower():
            cat = "Verbali Esterni"
        else:
            cat = "Documenti"
        return sec_id, cat

    elif "rtb" in section_folder:
        sec_id = "rtb"
        sub = parts[1].lower() if len(parts) > 2 else ""
        if "intern" in sub and "verb" in sub:
            cat = "Verbali Interni"
        elif "estern" in sub and "verb" in sub:
            cat = "Verbali Esterni"
        elif "intern" in sub:
            cat = "Documenti Interni"
        elif "estern" in sub:
            cat = "Documenti Esterni"
        else:
            cat = "Documenti Interni"
        return sec_id, cat

    elif "pb" in section_folder:
        sec_id = "pb"
        sub = parts[1].lower() if len(parts) > 2 else ""
        if "intern" in sub and "verb" in sub:
            cat = "Verbali Interni"
        elif "estern" in sub and "verb" in sub:
            cat = "Verbali Esterni"
        elif "intern" in sub:
            cat = "Documenti Interni"
        elif "estern" in sub:
            cat = "Documenti Esterni"
        else:
            cat = "Documenti Interni"
        return sec_id, cat

    elif "diario" in section_folder or "diapositiv" in section_folder:
        sec_id = "diapositive"
        cat = "Presentazioni"
        return sec_id, cat

    return None, None


def update_index_html():
    """Scansiona i PDF e aggiorna website/index.html."""
    if not INDEX_HTML.exists():
        print(f"File non trovato: {INDEX_HTML}", file=sys.stderr)
        return

    # Raccogli tutti i file PDF disponibili (sia in output/ che .typ corrispondenti in src/)
    # Struttura: { (section_id, category): [ (title, relative_href) ] }
    docs_by_category = {}

    found_files = []
    if OUT_DIR.exists():
        for pdf_file in OUT_DIR.rglob("*.pdf"):
            rel = pdf_file.relative_to(OUT_DIR)
            found_files.append((rel, pdf_file))

    # Se in output non c'è ancora il PDF compilato ma c'è il sorgente .typ in src, includilo
    if SRC_DIR.exists():
        for typ_file in SRC_DIR.rglob("*.typ"):
            if typ_file.name.startswith("template") or typ_file.name.startswith("lib"):
                continue
            if "testTemplates" in typ_file.parts:
                continue
            rel_typ = typ_file.relative_to(SRC_DIR)
            rel_pdf = rel_typ.with_suffix(".pdf")
            if not any(f[0] == rel_pdf for f in found_files):
                found_files.append((rel_pdf, OUT_DIR / rel_pdf))

    for rel_pdf, _ in found_files:
        rel_path_str = str(rel_pdf)
        sec_id, cat = map_path_to_section_and_category(rel_path_str)
        if not sec_id or not cat:
            continue

        rel_typ = rel_pdf.with_suffix(".typ")
        title = get_document_title(rel_pdf, rel_typ)

        # URL encoding per gli spazi nel percorso
        encoded_rel = "/".join(urllib.parse.quote(part) for part in rel_pdf.parts)
        href = f"../output/{encoded_rel}"

        docs_by_category.setdefault((sec_id, cat), []).append((title, href, rel_path_str))

    # Ordina i documenti per nome/data
    for k in docs_by_category:
        docs_by_category[k].sort(key=lambda x: x[2])

    content = INDEX_HTML.read_text(encoding="utf-8")

    # Aggiorna ciascuna sezione di index.html
    for (sec_id, cat), doc_list in docs_by_category.items():
        # Trova la sezione <section id="sec_id">
        sec_regex = rf'(<section id="{sec_id}"[^>]*>[\s\S]*?</section>)'
        sec_match = re.search(sec_regex, content)
        if not sec_match:
            continue

        section_body = sec_match.group(1)

        # Genera i tag <h4> dei documenti
        items_html = []
        for title, href, _ in doc_list:
            items_html.append(f'<h4><a href="{href}" target="_blank">{title}</a></h4>')
        items_joined = "\n      " + "\n      ".join(items_html)

        # Sostituisci il blocco sotto l'<h3> corrispondente
        cat_regex = rf'(<h3>{re.escape(cat)}</h3>\s*)([\s\S]*?)(?=\s*(?:<h3>|</section>))'
        if re.search(cat_regex, section_body):
            new_section_body = re.sub(cat_regex, rf'\g<1>{items_joined}', section_body, count=1)
            content = content.replace(section_body, new_section_body)

    INDEX_HTML.write_text(content, encoding="utf-8")
    print(f"website/index.html aggiornato con successo.")


def update_glossary_html():
    """Sincronizza le voci da src/glossario.json in website/glossary.html."""
    if not GLOSSARY_HTML.exists() or not GLOSSARY_JSON.exists():
        return

    try:
        data = json.loads(GLOSSARY_JSON.read_text(encoding="utf-8"))
    except Exception as e:
        print(f"Avviso parsing {GLOSSARY_JSON}: {e}", file=sys.stderr)
        return

    # Raggruppa per lettera iniziale
    by_letter = {}
    for term, definition in data.items():
        first_letter = term.strip()[0].lower() if term.strip() else ""
        if first_letter.isalpha():
            by_letter.setdefault(first_letter, []).append((term.strip(), definition.strip()))

    content = GLOSSARY_HTML.read_text(encoding="utf-8")

    for letter, items in by_letter.items():
        items.sort(key=lambda x: x[0].lower())
        dl_items = []
        for term, definition in items:
            dl_items.append(f"      <dt>{term}</dt>\n      <dd>{definition}</dd>")
        dl_inner = "\n" + "\n".join(dl_items) + "\n    "

        # Sostituisci il contenuto di <section id="letter">...<dl>...</dl>
        pattern = rf'(<section id="{letter}">\s*<h2>{letter.upper()}</h2>\s*<dl>)([\s\S]*?)(</dl>\s*</section>)'
        if re.search(pattern, content, flags=re.IGNORECASE):
            content = re.sub(pattern, rf'\g<1>{dl_inner}\g<3>', content, flags=re.IGNORECASE)

    GLOSSARY_HTML.write_text(content, encoding="utf-8")
    print(f"website/glossary.html sincronizzato con src/glossario.json.")


def main():
    update_index_html()
    update_glossary_html()


if __name__ == "__main__":
    main()

