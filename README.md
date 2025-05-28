# dvc-mini-pipeline

![DVC](https://img.shields.io/badge/DVC-enabled-brightgreen.svg)

Mini pipeline démonstratif pour illustrer comment gérer un projet de machine learning versionné avec [DVC](https://dvc.org). Il permet de :

- Générer des données synthétiques propres et bruitées
- Entraîner un modèle avec scikit-learn
- Suivre la performance (accuracy) et détecter la dérive via `dvc metrics diff`

## ⚡️ Installation rapide

```bash
git clone https://github.com/martinezcoralie/dvc-mini-pipeline.git
cd dvc-mini-pipeline
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## 📂 Structure du projet

```bash
.
├── data/          # Données versionnées par DVC
├── models/        # Modèles entraînés
├── scripts/       # Scripts exécutables
├── src/           # Code métier
├── dvc.yaml       # Définition du pipeline DVC
├── metrics.json   # Fichier de métriques suivi par DVC
```

## 🧪 Exécution

```bash
make clean && make reset_dvc
make init_dvc
make reset_dataset && make run_pipeline   # exécute le pipeline avec données propres
make noisy && make run_pipeline           # relance sur données bruitées
make metrics                              # compare les métriques
```

## 📚 Documentation

Un pas-à-pas détaillé est disponible dans le fichier [docs/README.md](docs/README.md).
