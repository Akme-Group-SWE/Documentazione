#!/bin/bash

set -e

SRC_DIR="src"
OUT_DIR="output"

# Controllo se typst è installato
if ! command -v typst &> /dev/null; then
    echo "Errore: 'typst' non risulta installato o non è presente nel PATH."
    echo "Per installarlo, consulta: https://github.com/typst/typst o installa con 'cargo install --locked typst-cli'"
    exit 1
fi

typ_files=()
while IFS= read -r -d '' file; do
    typ_files+=("$file")
done < <(find "$SRC_DIR" -type f -name "*.typ" -print0 | sort -z)

for typ_file in "${typ_files[@]}"; do
    rel_path="${typ_file#$SRC_DIR/}"
    pdf_file="$OUT_DIR/${rel_path%.typ}.pdf"

    filename="$(basename "$rel_path")"
    if [[ "$filename" == template*.typ ]] || [[ "$filename" == lib*.typ ]]; then
        continue
    fi

    if [ ! -f "$pdf_file" ] || [ "$typ_file" -nt "$pdf_file" ]; then
        mkdir -p "$(dirname "$pdf_file")"
        echo "Compilazione: $typ_file -> $pdf_file"
        typst compile --root . "$typ_file" "$pdf_file" --font-path "$SRC_DIR/shared/fonts"
    else
        echo "File aggiornato: $typ_file"
    fi
done

