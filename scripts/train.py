#scripts/train.py

import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
import joblib
import json
import os

# Chargement du dataset
df = pd.read_csv("data/raw/dataset.csv")
X = df.drop(columns=["target"])
y = df["target"]

# Entraînement du modèle
model = LogisticRegression()
model.fit(X, y)

# Sauvegarde du modèle
os.makedirs("models", exist_ok=True)
joblib.dump(model, "models/model.pkl")

# Évaluation et sauvegarde des métriques
accuracy = accuracy_score(y, model.predict(X))
with open("metrics.json", "w") as f:
    json.dump({"accuracy": accuracy}, f)