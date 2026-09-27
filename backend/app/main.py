from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import users, students, screenings, auth, interventions

app = FastAPI(
    title="Learning Difficulty Screening API",
    description="Backend API for AI-Based Learning Difficulty Screening Platform",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(students.router, prefix="/api/v1/students", tags=["students"])
app.include_router(screenings.router, prefix="/api/v1/screenings", tags=["screenings"])
app.include_router(interventions.router, prefix="/api/v1/interventions", tags=["interventions"])


@app.get("/")
async def root():
    return {"message": "Learning Difficulty Screening API", "version": "1.0.0"}


@app.get("/health")
async def health_check():
    return {"status": "healthy"}
