#!/bin/bash

# Vérifie que le nombre d'arguments est correct
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <fichier> <valeur_4eme_colonne>"
    exit 1
fi

# Récupère les arguments
fichier="$1"
valeur_4eme_colonne="$2"

# Vérifie que le fichier existe
if [ ! -f "$fichier" ]; then
    echo "Le fichier $fichier n'existe pas."
    exit 1
fi

# Lit le fichier ligne par ligne et extrait les composantes des vecteurs
awk -F'[=(),]' -v col4="$valeur_4eme_colonne" '{
    for (i=3; i<=5; i++) {
        printf "%f ", $i
    }
    print col4
}' "$fichier"

