#!/bin/bash

# Vérifie que le nombre d'arguments est correct
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <fichier> <suite_de_caractères> <N>"
    exit 1
fi

# Récupère les arguments
fichier="$1"
suite_de_caracteres="$2"
N="$3"

# Vérifie que le fichier existe
if [ ! -f "$fichier" ]; then
    echo "Le fichier $fichier n'existe pas."
    exit 1
fi

# Trouve la ligne contenant la suite de caractères et extrait les N lignes suivantes
grep -n -F "$suite_de_caracteres" "$fichier" | while read -r ligne; do
    num_ligne=$(echo "$ligne" | cut -d: -f1)
    tail -n +"$num_ligne" "$fichier" | head -n "$((N + 1))"
done
