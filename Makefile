.PHONY: venv clean reset_dataset run_pipeline noisy metrics reset_dvc init_dvc

# Crée un venv local et installe les deps
venv:
	python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt

# Nettoyer tous les fichiers générés
clean:
	rm -rf data/raw/*.csv
	rm -rf models/*
	rm -f metrics.json
	rm -f data/raw/*.csv.dvc
	rm -f dvc.lock

# Générer le dataset propre
reset_dataset:
	PYTHONPATH=. .venv/bin/python scripts/gen_dataset_clean.py
	dvc add data/raw/dataset.csv
	git add data/raw/dataset.csv.dvc
	git commit -m "Reset: regenerated clean dataset" || true

# Reproduire le pipeline
run_pipeline:
	dvc repro
	git add metrics.json dvc.lock
	git commit -m "Reproduced pipeline" || true

# Générer le dataset bruité
noisy:
	PYTHONPATH=. .venv/bin/python scripts/gen_dataset_noisy.py
	dvc add data/raw/dataset.csv
	git add data/raw/dataset.csv.dvc
	git commit -m "Switched to noisy dataset" || true

# Montre le métriques de tous les commits
metrics:
	dvc metrics show --all-commits

# Supprimer DVC
reset_dvc:
	rm -rf .dvc dvc.lock .dvcignore data/raw/*.csv.dvc data.dvc
	rm -rf .dvc/cache
	git add -u
	git commit -m "Reset DVC configuration" || true

# Initialiser DVC
init_dvc: reset_dvc
	dvc init
	git add .dvc .gitignore
	git commit -m "Re-init DVC" || true