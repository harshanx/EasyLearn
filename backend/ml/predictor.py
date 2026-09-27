import joblib
import numpy as np
import pandas as pd
import shap
from typing import Dict, List, Tuple, Optional
import os

# Risk label mapping (matches train_model.py)
RISK_LABELS = {0: 'None', 1: 'Mild', 2: 'Moderate', 3: 'Elevated'}

# Defaults for new behavioural features when not supplied by the API caller
FEATURE_DEFAULTS = {
    'prior_elearning_exp_enc': 1,   # "Some" experience
    'font_type_enc':           0,   # Standard
    'color_theme_enc':         0,   # Default
    'layout_mode_enc':         0,   # Standard
}


class ScreeningPredictor:
    def __init__(
        self,
        model_path:    str = None,
        scaler_path:   str = None,
        features_path: str = None,
    ):
        """Initialize the predictor with a trained XGBoost model and scaler."""
        if model_path    is None: model_path    = 'ml/models/screening_model.joblib'
        if scaler_path   is None: scaler_path   = 'ml/models/scaler.joblib'
        if features_path is None: features_path = 'ml/models/feature_columns.joblib'

        self.model          = joblib.load(model_path)
        self.scaler         = joblib.load(scaler_path)
        self.feature_columns: List[str] = joblib.load(features_path)

        # Load metadata for class info if present
        metadata_path = 'ml/models/model_metadata.joblib'
        if os.path.exists(metadata_path):
            meta = joblib.load(metadata_path)
            self.risk_labels: Dict[int, str] = meta.get('risk_labels', RISK_LABELS)
            self.num_classes: int            = meta.get('num_classes', 4)
        else:
            self.risk_labels = RISK_LABELS
            self.num_classes = 4

        # SHAP TreeExplainer (works with XGBoost and Random Forest)
        self.explainer = shap.TreeExplainer(self.model)

    # ──────────────────────────────────────────────────
    def predict(
        self,
        features: Dict[str, float],
    ) -> Tuple[str, float, Dict[str, float]]:
        """
        Make a prediction and return (risk_level, probability, shap_values_dict).

        Args:
            features: Dict of feature names → values. Missing behavioural
                      features are filled with sensible defaults.

        Returns:
            risk_level   – human-readable label (e.g. "Moderate")
            probability  – probability of the predicted class (0–1)
            shap_dict    – per-feature SHAP contribution values
        """
        input_df = self._prepare_input(features)
        input_scaled = self.scaler.transform(input_df)

        # Probabilities for all classes  shape: (1, num_classes)
        proba = self.model.predict_proba(input_scaled)[0]
        predicted_class = int(np.argmax(proba))
        probability     = float(proba[predicted_class])

        # Clamp to valid label keys
        risk_level = self.risk_labels.get(predicted_class, 'Unknown')

        # SHAP values — for multi-class XGBoost, shap_values() returns a list
        # of arrays (one per class) or a 3-D array. We take the slice for the
        # predicted class so the API surface stays identical.
        raw_shap = self.explainer.shap_values(input_scaled)

        if isinstance(raw_shap, list):
            # List of (1, n_features) arrays — one per class
            shap_arr = raw_shap[predicted_class][0]
        elif isinstance(raw_shap, np.ndarray) and raw_shap.ndim == 3:
            # Shape: (1, n_features, n_classes)
            shap_arr = raw_shap[0, :, predicted_class]
        else:
            # Fallback: binary or unexpected shape
            shap_arr = np.array(raw_shap).flatten()[:len(self.feature_columns)]

        shap_dict = dict(zip(self.feature_columns, shap_arr.tolist()))
        return risk_level, probability, shap_dict

    # ──────────────────────────────────────────────────
    def _prepare_input(self, features: Dict[str, float]) -> pd.DataFrame:
        """Build a DataFrame with all required features in the correct order."""
        row = {}
        for feat in self.feature_columns:
            if feat in features:
                row[feat] = features[feat]
            elif feat in FEATURE_DEFAULTS:
                row[feat] = FEATURE_DEFAULTS[feat]
            else:
                row[feat] = 0  # safe fallback
        return pd.DataFrame([row])[self.feature_columns]

    # ──────────────────────────────────────────────────
    def get_top_features(
        self,
        shap_values: Dict[str, float],
        top_n: int = 4,
    ) -> List[str]:
        """Return the names of the top-N features by absolute SHAP magnitude."""
        sorted_feats = sorted(shap_values.items(), key=lambda x: abs(x[1]), reverse=True)
        return [feat for feat, _ in sorted_feats[:top_n]]

    # ──────────────────────────────────────────────────
    def get_class_probabilities(self, features: Dict[str, float]) -> Dict[str, float]:
        """Return probabilities for all risk levels (useful for dashboard charts)."""
        input_df     = self._prepare_input(features)
        input_scaled = self.scaler.transform(input_df)
        proba        = self.model.predict_proba(input_scaled)[0]
        return {self.risk_labels.get(i, str(i)): float(p) for i, p in enumerate(proba)}


# ─────────────────────────────────────────────
# Global singleton (lazy-loaded)
# ─────────────────────────────────────────────
_predictor: Optional[ScreeningPredictor] = None


def get_predictor() -> ScreeningPredictor:
    """Get or create the global predictor instance (thread-safe enough for single-process uvicorn)."""
    global _predictor
    if _predictor is None:
        _predictor = ScreeningPredictor()
    return _predictor
