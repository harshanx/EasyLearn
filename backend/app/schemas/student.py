from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class StudentBase(BaseModel):
    student_id: str
    full_name: str
    age: Optional[int] = None
    grade: Optional[str] = None


class StudentCreate(StudentBase):
    parent_id: int


class StudentUpdate(BaseModel):
    full_name: Optional[str] = None
    age: Optional[int] = None
    grade: Optional[str] = None


class StudentResponse(StudentBase):
    id: int
    parent_id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
