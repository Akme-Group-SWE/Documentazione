#!/usr/bin/env python3
"""
glossary_annotator.py
Scansiona i file .typ e annota i termini presenti nel glossario con '#super[G]'.
I termini vengono estratti da website/glossary.html (tag <dt>) e/o da src/glossario.json.
"""

import sys
import re
import json
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
WEBSITE_GLOSSARY_HTML = REPO_ROOT / "website" / "glossary.html"
JSON_GLOSSARY_CANDIDATES = [
    REPO_ROOT / "src" / "glossario.json",
    REPO_ROOT / "website" / "glossario.json",
    REPO_ROOT / "glossario.json",
]


def load_glossary_terms():
    """Recupera l'elenco dei termini del glossario da HTML e JSON."""
    terms = set()

    # 1. Da HTML (<dt>Termine</dt>)
    if WEBSITE_GLOSSARY_HTML.exists():
        try:
            content = WEBSITE_GLOSSARY_HTML.read_text(encoding="utf-8")
            dt_terms = re.findall(r"<dt[^>]*>(.*?)</dt>", content, flags=re.IGNORECASE | re.DOTALL)
            for t in dt_terms:
                clean = re.sub(r"<[^>]+>", "", t).strip()
                if clean:
                    terms.add(clean)
        except Exception as e:
            print(f"Avviso lettura glossary.html: {e}", file=sys.stderr)

    # 2. Da JSON
    for json_path in JSON_GLOSSARY_CANDIDATES:
        if json_path.exists():
            try:
                data = json.loads(json_path.read_text(encoding="utf-8"))
                if isinstance(data, dict):
                    for k in data.keys():
                        if k.strip():
                            terms.add(k.strip())
                elif isinstance(data, list):
                    for item in data:
                        if isinstance(item, str) and item.strip():
                            terms.add(item.strip())
                        elif isinstance(item, dict) and "termine" in item:
                            terms.add(item["termine"].strip())
            except Exception as e:
                print(f"Avviso lettura {json_path}: {e}", file=sys.stderr)

    return sorted(list(terms), key=len, reverse=True)


def is_preamble_end(line):
    """Verifica se la riga segna l'inizio del corpo del documento."""
    stripped = line.strip()
    return stripped.startswith("=") and not stripped.startswith("==")


def annotate_content(content, terms, first_only=True):
    """
    Annota i termini nel contenuto typst con #super[G].
    Modifica solo il corpo del testo, preservando preamble, metadati e costrutti di codice.
    """
    if not terms:
        return content, []

    # Separa preambolo (es. #show: report.with(...)) e corpo effettivo
    lines = content.splitlines(keepends=True)
    body_start_idx = 0
    for idx, line in enumerate(lines):
        if is_preamble_end(line):
            body_start_idx = idx
            break

    preamble = "".join(lines[:body_start_idx])
    body = "".join(lines[body_start_idx:])

    # Rileva termini già annotati nel documento (#super[G], #sub[G], #gloss)
    already_annotated = set()
    for term in terms:
        check_pattern = rf"\b{re.escape(term)}\b(?:\*|_)?#(?:super|sub)\[G\]|#gloss\([\"']?{re.escape(term)}[\"']?\)"
        if re.search(check_pattern, content, flags=re.IGNORECASE):
            already_annotated.add(term.lower())

    protected = []

    def protect(m):
        protected.append(m.group(0))
        return f"__PROT_{len(protected)-1}__"

    # Proteggi elementi da NON toccare:
    # 1. Termini già annotati con apice/pedice G
    body = re.sub(r"\b[A-Za-z0-9_\s\-]+\b#(?:super|sub)\[G\]", protect, body)
    body = re.sub(r"#gloss\([^)]+\)", protect, body)

    # 2. Blocchi di codice e stringhe raw
    body = re.sub(r"```[\s\S]*?```", protect, body)
    body = re.sub(r"`[^`\n]+`", protect, body)

    # 3. URL, email e percorsi
    body = re.sub(r"https?://\S+|[\w\.\-]+@[\w\.\-]+\.\w+|/[a-zA-Z0-9_\-/\.]+", protect, body)

    # 4. Label e reference typst (<tab-x>, @tab-x)
    body = re.sub(r"<[a-zA-Z0-9_\-]+>", protect, body)
    body = re.sub(r"@[a-zA-Z0-9_\-]+", protect, body)

    # 5. Chiamate a funzioni Typst su singola riga (es. #align, #image, #v)
    body = re.sub(r"#(?:align|image|v|h|pad|grid|table|figure)\b[^\n\[\]]*", protect, body)

    applied_terms = []

    for term in terms:
        if first_only and term.lower() in already_annotated:
            continue

        pattern = rf"(?<![a-zA-Z0-9_])(?P<t>{re.escape(term)})(?![a-zA-Z0-9_])"

        replaced = False

        def repl(m):
            nonlocal replaced
            if first_only and replaced:
                return m.group(0)

            replaced = True
            matched = m.group("t")
            token = f"{matched}#super[G]"
            protected.append(token)
            return f"__PROT_{len(protected)-1}__"

        count = 1 if first_only else 0
        body = re.sub(pattern, repl, body, count=count, flags=re.IGNORECASE)

        if replaced:
            applied_terms.append(term)
            already_annotated.add(term.lower())

    # Ripristina token protetti in ordine inverso
    for i in range(len(protected) - 1, -1, -1):
        body = body.replace(f"__PROT_{i}__", protected[i])

    return preamble + body, applied_terms


def process_file(file_path, terms, first_only=True):
    path = Path(file_path)
    if not path.is_file() or not path.suffix == ".typ":
        return

    # Escludi template, librerie e test
    filename = path.name
    if filename.startswith("template") or filename.startswith("lib") or "testTemplates" in path.parts:
        return

    content = path.read_text(encoding="utf-8")
    annotated_content, applied = annotate_content(content, terms, first_only=first_only)

    if applied:
        path.write_text(annotated_content, encoding="utf-8")
        print(f"[{path.name}] Termini glossario annotati ({len(applied)}): {', '.join(applied)}")
    else:
        print(f"[{path.name}] Nessun nuovo termine di glossario da annotare.")


def main():
    terms = load_glossary_terms()
    print(f"Termini di glossario caricati: {len(terms)}")
    if terms:
        print(f"Esempi: {', '.join(terms[:8])}...")

    target = sys.argv[1] if len(sys.argv) > 1 else None

    if target:
        target_path = Path(target)
        if target_path.is_file():
            process_file(target_path, terms)
        elif target_path.is_dir():
            for typ_file in sorted(target_path.rglob("*.typ")):
                process_file(typ_file, terms)
        else:
            print(f"Percorso non trovato: {target}", file=sys.stderr)
            sys.exit(1)
    else:
        src_dir = REPO_ROOT / "src"
        for typ_file in sorted(src_dir.rglob("*.typ")):
            process_file(typ_file, terms)


if __name__ == "__main__":
    main()
