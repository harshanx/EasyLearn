import unittest
import os
import sys

# Ensure backend directory is in sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from ml.predictor import get_predictor, ScreeningPredictor

class TestScreeningPredictor(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.predictor = get_predictor()

    def test_predictor_loaded(self):
        self.assertIsNotNone(self.predictor.model)
        self.assertIsNotNone(self.predictor.scaler)
        self.assertGreater(len(self.predictor.feature_columns), 0)

    def test_predict_returns_valid_output(self):
        sample_features = {
            'reading_score': 2.0,
            'writing_score': 3.0,
            'math_score': 1.0,
            'attention_score': 2.0,
            'memory_score': 3.0,
            'social_score': 2.0,
            'sensory_score': 1.0,
            'age': 8.0,
            'grade': 3.0,
        }
        risk_level, probability, shap_dict = self.predictor.predict(sample_features)
        self.assertIn(risk_level, ['None', 'Mild', 'Moderate', 'Elevated'])
        self.assertGreaterEqual(probability, 0.0)
        self.assertLessEqual(probability, 1.0)
        self.assertEqual(len(shap_dict), len(self.predictor.feature_columns))

    def test_class_probabilities(self):
        sample_features = {'reading_score': 4.0, 'math_score': 4.0}
        probs = self.predictor.get_class_probabilities(sample_features)
        self.assertEqual(len(probs), 4)
        self.assertAlmostEqual(sum(probs.values()), 1.0, places=4)

    def test_top_features(self):
        sample_features = {'reading_score': 4.0, 'writing_score': 1.0}
        _, _, shap_dict = self.predictor.predict(sample_features)
        top_feats = self.predictor.get_top_features(shap_dict, top_n=3)
        self.assertEqual(len(top_feats), 3)

if __name__ == '__main__':
    unittest.main()
