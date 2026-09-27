from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app.models.intervention import Intervention
from app.models.user import User
from app.schemas.intervention import InterventionCreate, InterventionResponse, InterventionUpdate, RecommendationRequest
from app.auth import get_current_active_user

router = APIRouter()


@router.post("/", response_model=InterventionResponse, status_code=status.HTTP_201_CREATED)
def create_intervention(
    intervention: InterventionCreate, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    db_intervention = Intervention(**intervention.model_dump())
    db.add(db_intervention)
    db.commit()
    db.refresh(db_intervention)
    return db_intervention


@router.get("/", response_model=List[InterventionResponse])
def get_interventions(
    skip: int = 0, 
    limit: int = 100, 
    category: str = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    query = db.query(Intervention)
    if category:
        query = query.filter(Intervention.category == category)
    interventions = query.offset(skip).limit(limit).all()
    return interventions


@router.get("/{intervention_id}", response_model=InterventionResponse)
def get_intervention(
    intervention_id: int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    intervention = db.query(Intervention).filter(Intervention.id == intervention_id).first()
    if intervention is None:
        raise HTTPException(status_code=404, detail="Intervention not found")
    return intervention


@router.put("/{intervention_id}", response_model=InterventionResponse)
def update_intervention(
    intervention_id: int, 
    intervention_update: InterventionUpdate, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    db_intervention = db.query(Intervention).filter(Intervention.id == intervention_id).first()
    if db_intervention is None:
        raise HTTPException(status_code=404, detail="Intervention not found")
    
    update_data = intervention_update.model_dump(exclude_unset=True)
    
    for field, value in update_data.items():
        setattr(db_intervention, field, value)
    
    db.commit()
    db.refresh(db_intervention)
    return db_intervention


@router.delete("/{intervention_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_intervention(
    intervention_id: int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    db_intervention = db.query(Intervention).filter(Intervention.id == intervention_id).first()
    if db_intervention is None:
        raise HTTPException(status_code=404, detail="Intervention not found")
    
    db.delete(db_intervention)
    db.commit()
    return None


@router.post("/recommend")
def get_recommendations(
    request: RecommendationRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Get personalized intervention recommendations based on screening results.
    Matches interventions to the top contributing features from SHAP analysis.
    """
    recommendations = []
    
    # Map features to intervention categories
    feature_to_category = {
        "reading_difficulty": "reading",
        "writing_difficulty": "writing",
        "memory_difficulty": "memory",
        "attention_difficulty": "attention",
        "math_difficulty": "math",
        "social_difficulty": "social"
    }
    
    # Get interventions for each top feature
    for feature in request.top_features:
        category = feature_to_category.get(feature, "general")
        
        # Query interventions matching the category and age range
        interventions = db.query(Intervention).filter(
            Intervention.category == category,
            Intervention.age_range_min <= request.student_age,
            Intervention.age_range_max >= request.student_age
        ).all()
        
        # Check grade level match
        for intervention in interventions:
            if intervention.grade_levels:
                grades = [g.strip() for g in intervention.grade_levels.split(',')]
                if request.student_grade in grades:
                    recommendations.append({
                        "intervention": InterventionResponse.model_validate(intervention),
                        "reasoning": f"Recommended because {feature} was a top contributing factor in the screening result."
                    })
                else:
                    # Include if no grade-specific match exists
                    if not any(r["intervention"].category == category for r in recommendations):
                        recommendations.append({
                            "intervention": InterventionResponse.model_validate(intervention),
                            "reasoning": f"Recommended because {feature} was a top contributing factor in the screening result."
                        })
            else:
                recommendations.append({
                    "intervention": InterventionResponse.model_validate(intervention),
                    "reasoning": f"Recommended because {feature} was a top contributing factor in the screening result."
                })
    
    # Limit to top 3 recommendations
    return {"recommendations": recommendations[:3]}
