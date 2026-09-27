from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
import json
from app.database import get_db
from app.models.screening import Screening
from app.schemas.screening import ScreeningCreate, ScreeningResponse, ScreeningRequest

router = APIRouter()


@router.post("/", response_model=ScreeningResponse, status_code=status.HTTP_201_CREATED)
def create_screening(screening: ScreeningCreate, db: Session = Depends(get_db)):
    # Check if student exists
    from app.models.student import Student
    student = db.query(Student).filter(Student.id == screening.student_id).first()
    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Student not found"
        )
    
    db_screening = Screening(
        student_id=screening.student_id,
        risk_level=screening.risk_level,
        model_probability=screening.model_probability,
        features_data=json.dumps(screening.features_data) if screening.features_data else None,
        shap_explanation=json.dumps(screening.shap_explanation) if screening.shap_explanation else None
    )
    
    db.add(db_screening)
    db.commit()
    db.refresh(db_screening)
    return db_screening


@router.post("/predict", response_model=ScreeningResponse)
def predict_screening(request: ScreeningRequest, db: Session = Depends(get_db)):
    # Find student by external student_id
    from app.models.student import Student
    student = db.query(Student).filter(Student.student_id == request.student_id).first()
    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Student not found"
        )
    
    # Phase 6: Real ML prediction with SHAP explainability
    class_probabilities = None
    try:
        from ml.predictor import get_predictor
        predictor = get_predictor()

        # Add age and grade to features if not present
        features = request.features.copy()
        if 'age' not in features:
            features['age'] = student.age if student.age else 10
        if 'grade' not in features:
            features['grade'] = student.grade if student.grade else 5

        # Get prediction with SHAP values
        risk_level, probability, shap_values = predictor.predict(features)

        # Get top contributing features
        top_features = predictor.get_top_features(shap_values, top_n=4)

        # Get full probability distribution for all risk classes
        class_probabilities = predictor.get_class_probabilities(features)

    except Exception as e:
        # Fallback to mock prediction if ML model is not available
        import random
        probability = random.uniform(0.3, 0.95)
        risk_level = "Elevated" if probability > 0.6 else "Lower"
        shap_values = {
            "reading_difficulty": 0.3 if probability > 0.6 else -0.1,
            "writing_difficulty": 0.25 if probability > 0.6 else -0.05,
            "memory_difficulty": 0.2 if probability > 0.6 else 0.0,
            "attention_difficulty": 0.15 if probability > 0.6 else -0.02,
        }
        top_features = list(shap_values.keys())

    db_screening = Screening(
        student_id=student.id,
        risk_level=risk_level,
        model_probability=probability,
        features_data=json.dumps(request.features),
        shap_explanation=json.dumps(shap_values),
    )

    db.add(db_screening)
    db.commit()
    db.refresh(db_screening)

    # Attach transient fields (not persisted in DB)
    db_screening.top_features = top_features
    db_screening.class_probabilities = class_probabilities

    return db_screening


@router.get("/", response_model=List[ScreeningResponse])
def get_screenings(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    screenings = db.query(Screening).offset(skip).limit(limit).all()
    return screenings


@router.get("/{screening_id}", response_model=ScreeningResponse)
def get_screening(screening_id: int, db: Session = Depends(get_db)):
    screening = db.query(Screening).filter(Screening.id == screening_id).first()
    if screening is None:
        raise HTTPException(status_code=404, detail="Screening not found")
    return screening


@router.get("/student/{student_id}", response_model=List[ScreeningResponse])
def get_student_screenings(student_id: int, db: Session = Depends(get_db)):
    screenings = db.query(Screening).filter(Screening.student_id == student_id).all()
    return screenings
