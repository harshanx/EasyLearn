from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Float, Text
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base


class Screening(Base):
    __tablename__ = "screenings"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("students.id"), nullable=False)
    screening_date = Column(DateTime(timezone=True), server_default=func.now())
    risk_level = Column(String)  # "Elevated", "Lower", "Moderate"
    model_probability = Column(Float)
    features_data = Column(Text)  # JSON string of questionnaire responses
    shap_explanation = Column(Text)  # JSON string of SHAP values
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    student = relationship("Student", back_populates="screenings")
