import unittest
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from fastapi.testclient import TestClient
from app.main import app
from app.auth import get_current_active_user
from app.models.user import User, UserRole
from app.models.student import Student
from app.database import SessionLocal, engine, Base

def mock_get_current_user():
    return User(id=1, email="test@example.com", username="testuser", full_name="Test User", role=UserRole.TEACHER)

class TestAPIEndpoints(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        app.dependency_overrides[get_current_active_user] = mock_get_current_user
        cls.client = TestClient(app)
        
        # Seed test student into DB if not exists
        db = SessionLocal()
        student = db.query(Student).filter(Student.student_id == "STU001").first()
        if not student:
            student = Student(student_id="STU001", full_name="Test Student", age=9, grade="4")
            db.add(student)
            db.commit()
        db.close()

    @classmethod
    def tearDownClass(cls):
        app.dependency_overrides.clear()

    def test_root(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertIn("version", response.json())

    def test_health(self):
        response = self.client.get("/health")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"status": "healthy"})

    def test_predict_endpoint(self):
        payload = {
            "student_id": "STU001",
            "features": {
                "reading_score": 4.0,
                "writing_score": 3.0,
                "math_score": 1.0,
                "attention_score": 2.0,
                "memory_score": 4.0,
                "social_score": 3.0,
                "sensory_score": 2.0,
                "age": 9.0,
                "grade": 4.0
            }
        }
        response = self.client.post("/api/v1/screenings/predict", json=payload)
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIn("risk_level", data)
        self.assertIn("shap_explanation", data)
        self.assertIn("class_probabilities", data)

    def test_interventions_list(self):
        response = self.client.get("/api/v1/interventions/")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIsInstance(data, list)
        self.assertGreater(len(data), 0)

if __name__ == '__main__':
    unittest.main()
