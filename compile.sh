#!/bin/bash

set -e

SRC_DIR="src"
OUT_DIR="output"
SCRIPTS_DIR="scripts"

# File specifico passato come argomento opzionale (es. ./compile.sh "src/Candidatura/Verbali Interni/2026-10-15.typ")
TARGET_FILE="$1"

echo "=========================================================="
echo "  Akme Group - Pipeline Documentazione SWE"
echo "=========================================================="

# ------------------------------------------------------------------
# FASE 1: Scansione glossario e marcatura termini (#super[G])
# ------------------------------------------------------------------
if [ -f "$SCRIPTS_DIR/glossary_annotator.py" ]; then
    echo "[1/3] Scansione termini di glossario e annotazione..."
    if [ -n "$TARGET_FILE" ]; then
        python3 "$SCRIPTS_DIR/glossary_annotator.py" "$TARGET_FILE"
    else
        python3 "$SCRIPTS_DIR/glossary_annotator.py"
    fi
else
    echo "[1/3] Avviso: $SCRIPTS_DIR/glossary_annotator.py non trovato, fase saltata."
fi

# ------------------------------------------------------------------
# FASE 2: Compilazione Typst -> PDF
# ------------------------------------------------------------------
echo "[2/3] Compilazione documenti Typst in PDF..."
typ_files=()

if [ -n "$TARGET_FILE" ]; then
    if [ ! -f "$TARGET_FILE" ]; then
        echo "Errore: il file '$TARGET_FILE' non esiste."
        exit 1
    fi
    typ_files+=("$TARGET_FILE")
else
    while IFS= read -r -d '' file; do
        typ_files+=("$file")
    done < <(find "$SRC_DIR" -type f -name "*.typ" -print0 | sort -z)
fi

if ! command -v typst &> /dev/null; then
    echo "Attenzione: 'typst' non risulta installato o non è presente nel PATH."
    echo "I file sono stati scansionati e annotati, ma la compilazione PDF richiede Typst."
    echo "Per installare: https://github.com/typst/typst o 'cargo install --locked typst-cli'"
else
    for typ_file in "${typ_files[@]}"; do
        rel_path="${typ_file#$SRC_DIR/}"
        filename="$(basename "$rel_path")"

        # Salta template, librerie e file di test
        if [[ "$filename" == template*.typ ]] || [[ "$filename" == lib*.typ ]] || [[ "$rel_path" == *testTemplates* ]]; then
            continue
        fi

        pdf_file="$OUT_DIR/${rel_path%.typ}.pdf"

        if [ ! -f "$pdf_file" ] || [ "$typ_file" -nt "$pdf_file" ]; then
            mkdir -p "$(dirname "$pdf_file")"
            echo "  -> Compilazione: $typ_file -> $pdf_file"
            typst compile --root . "$typ_file" "$pdf_file" --font-path "$SRC_DIR/shared/fonts"
        else
            echo "  -> PDF già aggiornato: $pdf_file"
        fi
    done
fi

# ------------------------------------------------------------------
# FASE 3: Aggiornamento automatico del sito web (index.html e glossario)
# ------------------------------------------------------------------
if [ -f "$SCRIPTS_DIR/update_website.py" ]; then
    echo "[3/3] Aggiornamento automatico del sito web (website/index.html)..."
    python3 "$SCRIPTS_DIR/update_website.py"
fi

echo "=========================================================="
echo "  Completato con successo!"
echo "=========================================================="
