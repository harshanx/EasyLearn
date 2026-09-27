from app.database import engine
from app.models import user, student, screening, intervention

print("Creating database tables...")
user.Base.metadata.create_all(bind=engine)
student.Base.metadata.create_all(bind=engine)
screening.Base.metadata.create_all(bind=engine)
intervention.Base.metadata.create_all(bind=engine)
print("Database initialized successfully!")

