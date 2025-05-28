import pandas as pd
from sklearn.datasets import make_classification

def generate_dataset(output_path, noise=0.01, seed=42):
    X, y = make_classification(
        n_samples=200,
        n_features=5,
        n_informative=4,
        n_redundant=1,
        flip_y=noise,
        random_state=seed
    )
    df = pd.DataFrame(X, columns=[f"feature_{i}" for i in range(X.shape[1])])
    df["target"] = y
    df.to_csv(output_path, index=False)