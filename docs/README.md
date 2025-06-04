# dvc-mini-pipeline — Documentation Étape par Étape

Ce fichier complète le README principal avec une description détaillée des étapes pour construire et comprendre le pipeline.

## Étape 1 — Structure du projet

Organisation du code et des dossiers : `data/`, `models/`, `scripts/`, `src/`

## Étape 2 — Initialisation Git + DVC

```bash
git init
dvc init
```

Ajout du remote et premier commit, création du `.gitignore`, etc.

## Étape 3 — Génération du dataset

Utilisation de `scripts/gen_dataset_clean.py` et `scripts/gen_dataset_noisy.py` pour créer deux versions du dataset. Versionnage avec `dvc add`.

## Étape 4 — Entraînement et pipeline

Script `scripts/train.py` + définition du pipeline avec `dvc stage add`.

## Étape 5 — Reproducibilité et détection de dérive

`dvc repro`, suivi des métriques (`metrics.json`), et `dvc metrics diff` pour comparer.

---
Voir le README principal pour les commandes synthétiques et l’installation rapide.
