from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List
from app.models.intervention import InterventionCategory, InterventionDifficulty


class InterventionBase(BaseModel):
    title: str
    description: str
    category: InterventionCategory
    difficulty_level: InterventionDifficulty = InterventionDifficulty.BEGINNER
    age_range_min: int = 5
    age_range_max: int = 18
    grade_levels: Optional[str] = None
    duration_minutes: int = 15
    instructions: Optional[str] = None
    materials_needed: Optional[str] = None
    learning_objectives: Optional[str] = None


class InterventionCreate(InterventionBase):
    pass


class InterventionUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    category: Optional[InterventionCategory] = None
    difficulty_level: Optional[InterventionDifficulty] = None
    age_range_min: Optional[int] = None
    age_range_max: Optional[int] = None
    grade_levels: Optional[str] = None
    duration_minutes: Optional[int] = None
    instructions: Optional[str] = None
    materials_needed: Optional[str] = None
    learning_objectives: Optional[str] = None


class InterventionResponse(InterventionBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class RecommendationRequest(BaseModel):
    student_age: int
    student_grade: str
    top_features: List[str]  # Top contributing features from SHAP
    risk_level: str
