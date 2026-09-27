from sqlalchemy import Column, Integer, String, Text, DateTime, Enum
from sqlalchemy.sql import func
from app.database import Base
import enum


class InterventionCategory(str, enum.Enum):
    READING = "reading"
    WRITING = "writing"
    MEMORY = "memory"
    ATTENTION = "attention"
    MATH = "math"
    SOCIAL = "social"
    GENERAL = "general"


class InterventionDifficulty(str, enum.Enum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"


class Intervention(Base):
    __tablename__ = "interventions"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    category = Column(Enum(InterventionCategory), nullable=False)
    difficulty_level = Column(Enum(InterventionDifficulty), default=InterventionDifficulty.BEGINNER)
    age_range_min = Column(Integer, default=5)
    age_range_max = Column(Integer, default=18)
    grade_levels = Column(String)  # Comma-separated grade levels (e.g., "1,2,3")
    duration_minutes = Column(Integer, default=15)
    instructions = Column(Text)
    materials_needed = Column(Text)  # Comma-separated materials
    learning_objectives = Column(Text)  # Comma-separated objectives
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
