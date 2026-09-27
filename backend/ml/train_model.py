import pandas as pd  # type: ignore # pyright: ignore
import numpy as np  # type: ignore # pyright: ignore
from sklearn.model_selection import train_test_split, StratifiedKFold, cross_val_score  # type: ignore # pyright: ignore
from sklearn.preprocessing import StandardScaler, LabelEncoder  # type: ignore # pyright: ignore
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score  # type: ignore # pyright: ignore
from xgboost import XGBClassifier  # type: ignore # pyright: ignore
import joblib  # type: ignore # pyright: ignore
import os
import json
from datetime import datetime


# ─────────────────────────────────────────────
# CONSTANTS
# ─────────────────────────────────────────────
DATASET_PATH = r"C:\Users\HARSHAN PV\Desktop\Project\datasets\wals_neurodivergent_learner_dataset-selected-columns.csv"

FEATURE_COLUMNS = [
    'reading_difficulty',
    'writing_difficulty',
    'memory_difficulty',
    'attention_difficulty',
    'math_difficulty',
    'social_difficulty',
    'age',
    'grade',
    # Encoded behavioural / preference signals
    'prior_elearning_exp_enc',
    'font_type_enc',
    'color_theme_enc',
    'layout_mode_enc',
]

# ─────────────────────────────────────────────
# MAPPINGS
# ─────────────────────────────────────────────

# Base difficulty scores per neurodivergence type (1-5 scale)
NEURODIVERGENCE_MAP = {
    'Dyslexia':        {'reading': 4, 'writing': 4, 'memory': 2, 'attention': 2, 'math': 3, 'social': 1},
    'ADHD':            {'reading': 2, 'writing': 2, 'memory': 3, 'attention': 5, 'math': 2, 'social': 2},
    'Autism':          {'reading': 2, 'writing': 2, 'memory': 2, 'attention': 4, 'math': 2, 'social': 5},
    'Dyscalculia':     {'reading': 2, 'writing': 2, 'memory': 2, 'attention': 2, 'math': 5, 'social': 1},
    'Multiple':        {'reading': 3, 'writing': 3, 'memory': 3, 'attention': 4, 'math': 3, 'social': 3},
    'None (Control)':  {'reading': 1, 'writing': 1, 'memory': 1, 'attention': 1, 'math': 1, 'social': 1},
}

# Additional modifier scores from primary_challenge
CHALLENGE_MAP = {
    'Reading Comprehension':    {'reading': 2, 'writing': 1, 'memory': 1, 'attention': 1, 'math': 1, 'social': 1},
    'Attention & Distraction':  {'reading': 1, 'writing': 1, 'memory': 2, 'attention': 2, 'math': 1, 'social': 1},
    'Sensory Sensitivity':      {'reading': 1, 'writing': 1, 'memory': 1, 'attention': 2, 'math': 1, 'social': 2},
    'Cognitive Overload':       {'reading': 1, 'writing': 1, 'memory': 2, 'attention': 2, 'math': 1, 'social': 1},
}

# Multi-class risk label: 0=None, 1=Mild, 2=Moderate, 3=Elevated
RISK_LABEL_MAP = {
    'None (Control)': 0,
    'Dyscalculia':    1,   # Single domain, relatively mild
    'Dyslexia':       2,   # Reading/writing focused, moderate
    'ADHD':           2,   # Attention focused, moderate
    'Autism':         2,   # Social/attention, moderate
    'Multiple':       3,   # Multiple conditions, elevated
}

# Age group → numeric age
AGE_MAP = {
    'School (13-17)':     15,
    'Higher Ed (18-24)':  21,
    'Adult Learner (25+)': 30,
}

# Education level → approximate grade year
EDUCATION_MAP = {
    'Secondary':      10,
    'Undergraduate':  12,
    'Postgraduate':   16,
}

# Prior e-learning experience → ordinal
ELEARNING_MAP = {
    'None':      0,
    'Some':      1,
    'Extensive': 2,
}

# Font type → ordinal (accessibility-aware fonts rank higher)
FONT_TYPE_MAP = {
    'Standard':          0,
    'Dyslexia-Friendly': 1,
    'High-Contrast':     2,
    'Large-Print':       3,
}

# Color theme → ordinal
COLOR_THEME_MAP = {
    'Default':                 0,
    'High-Contrast Dark':      1,
    'Low-Stimulation Pastel':  2,
    'Sepia':                   3,
}

# Layout mode → ordinal
LAYOUT_MODE_MAP = {
    'Standard':   0,
    'Simplified': 1,
}


# ─────────────────────────────────────────────
# DATA LOADING & FEATURE ENGINEERING
# ─────────────────────────────────────────────

def load_and_engineer_features(dataset_path: str = DATASET_PATH) -> pd.DataFrame:
    """Load the WALS dataset and engineer all features."""
    print(f"Loading dataset from: {dataset_path}")
    df = pd.read_csv(dataset_path)
    print(f"Raw dataset shape: {df.shape}")

    # ── Difficulty scores from neurodivergence type ──
    diff_cols = ['reading_difficulty', 'writing_difficulty', 'memory_difficulty',
                 'attention_difficulty', 'math_difficulty', 'social_difficulty']
    for col in diff_cols:
        df[col] = 1  # baseline

    for idx, row in df.iterrows():
        neuro = row['neurodivergence_type']
        challenge = row['primary_challenge']

        if neuro in NEURODIVERGENCE_MAP:
            m = NEURODIVERGENCE_MAP[neuro]
            df.at[idx, 'reading_difficulty']    = min(5, 1 + m['reading'])
            df.at[idx, 'writing_difficulty']    = min(5, 1 + m['writing'])
            df.at[idx, 'memory_difficulty']     = min(5, 1 + m['memory'])
            df.at[idx, 'attention_difficulty']  = min(5, 1 + m['attention'])
            df.at[idx, 'math_difficulty']       = min(5, 1 + m['math'])
            df.at[idx, 'social_difficulty']     = min(5, 1 + m['social'])

        if challenge in CHALLENGE_MAP:
            m = CHALLENGE_MAP[challenge]
            df.at[idx, 'reading_difficulty']    = min(5, df.at[idx, 'reading_difficulty']   + m['reading'])
            df.at[idx, 'writing_difficulty']    = min(5, df.at[idx, 'writing_difficulty']   + m['writing'])
            df.at[idx, 'memory_difficulty']     = min(5, df.at[idx, 'memory_difficulty']    + m['memory'])
            df.at[idx, 'attention_difficulty']  = min(5, df.at[idx, 'attention_difficulty'] + m['attention'])
            df.at[idx, 'math_difficulty']       = min(5, df.at[idx, 'math_difficulty']      + m['math'])
            df.at[idx, 'social_difficulty']     = min(5, df.at[idx, 'social_difficulty']    + m['social'])

    # ── Demographic features ──
    df['age']   = df['age_group'].map(AGE_MAP).fillna(18)
    df['grade'] = df['education_level'].map(EDUCATION_MAP).fillna(10)

    # ── Behavioural / preference features (ordinal encoded) ──
    df['prior_elearning_exp_enc'] = df['prior_elearning_experience'].map(ELEARNING_MAP).fillna(0)
    df['font_type_enc']           = df['font_type'].map(FONT_TYPE_MAP).fillna(0)
    df['color_theme_enc']         = df['color_theme'].map(COLOR_THEME_MAP).fillna(0)
    df['layout_mode_enc']         = df['layout_mode'].map(LAYOUT_MODE_MAP).fillna(0)

    # ── Multi-class target label ──
    df['risk_level'] = df['neurodivergence_type'].map(RISK_LABEL_MAP).fillna(1)

    # Keep only needed columns
    keep = FEATURE_COLUMNS + ['risk_level']
    df = df[keep].copy()
    df = df.astype(float)   # ensure numeric

    print(f"Processed dataset shape: {df.shape}")
    print(f"\nRisk level distribution:")
    label_names = {0: 'None', 1: 'Mild', 2: 'Moderate', 3: 'Elevated'}
    for k, v in df['risk_level'].value_counts().sort_index().items():
        print(f"  {int(k)} ({label_names.get(int(k), '?')}): {v}")

    return df


# ─────────────────────────────────────────────
# MODEL TRAINING
# ─────────────────────────────────────────────

def train_model():
    """Train an XGBoost model with cross-validation and save with versioning."""

    print("\n" + "="*60)
    print("  ML Model Training - XGBoost Classifier")
    print("="*60 + "\n")

    # 1. Load data
    df = load_and_engineer_features()

    X = df[FEATURE_COLUMNS]
    y = df['risk_level'].astype(int)

    num_classes = int(y.nunique())
    print(f"\nNumber of classes: {num_classes}")

    # 2. Train / test split (stratified)
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )

    # 3. Feature scaling
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled  = scaler.transform(X_test)

    # 4. XGBoost model
    print("\nTraining XGBoost classifier...")
    model = XGBClassifier(
        n_estimators=300,
        max_depth=6,
        learning_rate=0.05,
        subsample=0.8,
        colsample_bytree=0.8,
        eval_metric='mlogloss',
        objective='multi:softprob',
        num_class=num_classes,
        random_state=42,
        n_jobs=-1,
    )
    model.fit(
        X_train_scaled, y_train,
        eval_set=[(X_test_scaled, y_test)],
        verbose=False,
    )

    # 5. Cross-validation (5-fold)
    print("\nRunning 5-fold cross-validation...")
    cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
    cv_scores = cross_val_score(
        XGBClassifier(
            n_estimators=300, max_depth=6, learning_rate=0.05,
            subsample=0.8, colsample_bytree=0.8,
            eval_metric='mlogloss',
            objective='multi:softprob', num_class=num_classes,
            random_state=42, n_jobs=-1,
        ),
        scaler.transform(X), y, cv=cv, scoring='accuracy', n_jobs=-1,
    )
    print(f"CV Accuracy: {cv_scores.mean():.4f} +/- {cv_scores.std():.4f}")

    # 6. Final evaluation
    train_accuracy = accuracy_score(y_train, model.predict(X_train_scaled))
    test_accuracy  = accuracy_score(y_test,  model.predict(X_test_scaled))
    print(f"\nTraining accuracy : {train_accuracy:.4f}")
    print(f"Test accuracy     : {test_accuracy:.4f}")

    print("\nClassification Report (Test Set):")
    label_names = ['None', 'Mild', 'Moderate', 'Elevated']
    print(classification_report(y_test, model.predict(X_test_scaled),
                                 target_names=label_names[:num_classes]))

    # 7. Feature importance
    importance = dict(zip(FEATURE_COLUMNS, model.feature_importances_))
    print("\nFeature Importance (XGBoost gain):")
    for feat, imp in sorted(importance.items(), key=lambda x: x[1], reverse=True):
        bar = '#' * int(imp * 40)
        print(f"  {feat:<30} {imp:.4f}  {bar}")

    # 8. Save model with versioning
    os.makedirs('ml/models', exist_ok=True)
    version = datetime.now().strftime("%Y%m%d_%H%M%S")

    model_path    = f'ml/models/screening_model_v{version}.joblib'
    scaler_path   = f'ml/models/scaler_v{version}.joblib'
    features_path = f'ml/models/feature_columns_v{version}.joblib'

    joblib.dump(model,          model_path)
    joblib.dump(scaler,         scaler_path)
    joblib.dump(FEATURE_COLUMNS, features_path)

    # Latest symlinks (overwrite)
    joblib.dump(model,          'ml/models/screening_model.joblib')
    joblib.dump(scaler,         'ml/models/scaler.joblib')
    joblib.dump(FEATURE_COLUMNS, 'ml/models/feature_columns.joblib')

    # Metadata
    metadata = {
        'version':           version,
        'algorithm':         'XGBoostClassifier',
        'model_path':        model_path,
        'scaler_path':       scaler_path,
        'features_path':     features_path,
        'train_accuracy':    float(train_accuracy),
        'test_accuracy':     float(test_accuracy),
        'cv_accuracy_mean':  float(cv_scores.mean()),
        'cv_accuracy_std':   float(cv_scores.std()),
        'feature_columns':   FEATURE_COLUMNS,
        'feature_importance': {k: float(v) for k, v in importance.items()},
        'num_classes':       num_classes,
        'risk_labels':       {0: 'None', 1: 'Mild', 2: 'Moderate', 3: 'Elevated'},
        'training_samples':  len(df),
        'training_date':     datetime.now().isoformat(),
        'dataset_source':    'WALS Neurodivergent Learner Dataset',
    }
    joblib.dump(metadata, 'ml/models/model_metadata.joblib')

    print("\n" + "="*60)
    print("  Model saved successfully!")
    print(f"  Version     : {version}")
    print(f"  Algorithm   : XGBoost (multi-class, {num_classes} classes)")
    print(f"  Test Acc    : {test_accuracy:.4f}")
    print(f"  CV Acc      : {cv_scores.mean():.4f} +/- {cv_scores.std():.4f}")
    print(f"  Saved to    : {model_path}")
    print("="*60)


if __name__ == "__main__":
    train_model()
