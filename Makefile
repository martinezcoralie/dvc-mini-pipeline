.PHONY: venv clean clean_dataset run_pipeline noisy_dataset metrics reset_dvc init_dvc tag_clean tag_noisy

# Crée un venv local et installe les deps
venv:
	python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt

# Nettoyer tous les fichiers générés
clean:
	rm -rf data/raw/*.csv
	rm -rf models/*
	rm -rf metrics/*
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
	mkdir -p metrics
	dvc repro
	git add metrics.json dvc.lock metrics/metrics.tsv
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

# Usage : make tag_clean SUFFIX=v1
tag_clean:
	git tag -a "clean-$(SUFFIX)" -m "Run pipeline with clean dataset (suffix: $(SUFFIX))"
	git push origin "clean-$(SUFFIX)"

# Usage : make tag_noisy SUFFIX=v2
tag_noisy:
	git tag -a "noisy-$(SUFFIX)" -m "Run pipeline with noisy dataset (suffix: $(SUFFIX))"
	git push origin "noisy-$(SUFFIX)"

# Affiche les plots du dernier run
plots_show:
	dvc plots show

# Compare deux tags (à passer en arguments)
# Exemple : make plots_diff FROM=clean-v1 TO=noisy-v1
plots_diff:
	dvc plots diff $(FROM) $(TO)

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


# Usage : make full_run_compare SUFFIX=v1
full_run_compare:
	make clean_dataset && make run_pipeline
	make tag_clean SUFFIX=$(SUFFIX)
	make noisy_dataset && make run_pipeline
	make tag_noisy SUFFIX=$(SUFFIX)
	make plots_diff FROM=clean-$(SUFFIX) TO=noisy-$(SUFFIX)
