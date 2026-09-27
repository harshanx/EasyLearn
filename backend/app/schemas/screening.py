import json
from pydantic import BaseModel, field_validator
from datetime import datetime
from typing import Optional, Dict, List


class ScreeningBase(BaseModel):
    student_id: int
    risk_level: Optional[str] = None
    model_probability: Optional[float] = None
    features_data: Optional[Dict] = None
    shap_explanation: Optional[Dict] = None

    @field_validator('features_data', 'shap_explanation', mode='before')
    def parse_json_string(cls, v):
        if isinstance(v, str):
            try:
                return json.loads(v)
            except Exception:
                return {}
        return v



class ScreeningCreate(ScreeningBase):
    pass


class ScreeningResponse(ScreeningBase):
    id: int
    screening_date: datetime
    created_at: datetime
    # Extra fields populated in-memory after prediction (not persisted)
    top_features: Optional[List[str]] = None
    class_probabilities: Optional[Dict[str, float]] = None

    class Config:
        from_attributes = True


class ScreeningRequest(BaseModel):
    student_id: str
    features: Dict[str, float]
