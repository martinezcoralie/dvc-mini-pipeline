.PHONY: venv clean clean_dataset run_pipeline noisy_dataset metrics reset_dvc init_dvc tag_clean tag_noisy

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
clean_dataset:
	PYTHONPATH=. .venv/bin/python scripts/gen_dataset_clean.py
	dvc add data/raw/dataset.csv
	git add data/raw/dataset.csv.dvc
	git commit -m "Collect clean dataset" || true

# Reproduire le pipeline
run_pipeline:
	dvc repro
	git add metrics.json dvc.lock
	git commit -m "Reproduced pipeline" || true

# Générer le dataset bruité
noisy_dataset:
	PYTHONPATH=. .venv/bin/python scripts/gen_dataset_noisy.py
	dvc add data/raw/dataset.csv
	git add data/raw/dataset.csv.dvc
	git commit -m "Collect noisy dataset" || true

# Montre le métriques de tous les commits
metrics:
	dvc metrics show --all-tags

# Tag après un run clean
tag_clean:
	git tag -a "clean-$(shell date +%Y%m%d-%H%M)" -m "Run pipeline with clean dataset"
	git push origin --tags

# Tag après un run noisy
tag_noisy:
	git tag -a "noisy-$(shell date +%Y%m%d-%H%M)" -m "Run pipeline with noisy dataset"
	git push origin --tags

# Supprimer DVC
reset_dvc:
	rm -rf .dvc dvc.lock .dvcignore data/raw/*.csv.dvc data.dvc
	rm -rf .dvc/cache
	git add -u
	git commit -m "Remove DVC configuration" || true

# Initialiser DVC
init_dvc:
	dvc init
	git add .dvc .gitignore
	git commit -m "Init DVC" || true