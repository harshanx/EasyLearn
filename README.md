# AI-Based Learning Difficulty Screening & Explainable Intervention Support Platform

> **Current implementation note (verified 2026-10-27):** Several phase-by-phase sections below are historical setup notes and may be stale. The current backend runs model-backed screening with SHAP from bundled joblib artifacts; if inference fails, the API returns HTTP 503 and does not save a fabricated result. SQLite is the default database; set `DATABASE_URL` to use PostgreSQL. Production startup requires `APP_ENV=production`, `SECRET_KEY`, and explicit `CORS_ORIGINS` values. See `PROJECT_AUDIT.md`, `ROADMAP.md`, and `TESTING.md` for verified status and remaining limitations.

An academic final-year project designed to identify student learning difficulties through machine learning analysis and support parents and educators with individualized learning activity suggestions and Explainable AI (XAI) justifications.

---

## 1. Project Architecture

The platform uses a modular, multi-tier layout:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           Flutter Android App                           │
│     (Material 3, Riverpod State, SharedPreferences, Multi-Language)      │
└───────────────────────────────────────────────────┬─────────────────────┘
                                                    │
                                                    │ REST API (HTTPS)
                                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                            FastAPI Backend                              │
│       (Pydantic, SQLAlchemy models, SQLite/PostgreSQL Database)         │
└───────────────────┬───────────────────────────────────────┬─────────────┘
                    │                                       │
                    ▼                                       ▼
┌───────────────────────────────────────┐   ┌─────────────────────────────┐
│              ML Engine                │   │         XAI Engine          │
│ (scikit-learn Classifier, XGBoost)    │   │ (SHAP Feature Attribution)  │
└───────────────────────────────────────┘   └─────────────────────────────┘
```

---

## 2. Directory Layout

The workspace is organized into discrete components:

* `flutter_app/`: Source code of the Flutter-based Android application.
* `backend/`: FastAPI Python server code (Phase 2+).
* `docs/`: Technical manuals, design plans, and model cards.

---

## 3. Tech Stack Details

* **Frontend:** Flutter, Dart, Material 3, Riverpod (State), SharedPreferences (Persistence).
* **Languages:** English, Malayalam (`മലയാളം`), Hindi (`हिन्दी`).
* **Backend:** Python, FastAPI, SQLAlchemy (Phase 2+).
* **ML/XAI:** pandas, scikit-learn, SHAP, Matplotlib (Phase 6+).

---

## 4. Phase 1 Setup & Running Guide

### Prerequisites
* Flutter SDK (v3.38.9 or compatible)
* Android Studio / JDK
* Chrome browser (for web debugging fallback)

### Step-by-Step Launch

1. **Navigate to the Flutter directory:**
   ```bash
   cd flutter_app
   ```

2. **Generate Localization classes:**
   Before running the app, trigger the Flutter localization code-generator to compile the `.arb` translation dictionaries:
   ```bash
   flutter gen-l10n
   ```

3. **Fetch packages:**
   Ensure all pub dependencies are downloaded and linked:
   ```bash
   flutter pub get
   ```

4. **Run the application:**
   You can target an Android emulator/device or run in Chrome:
   ```bash
   # Run on any connected device
   flutter run
   
   # Or run in Chrome browser
   flutter run -d chrome
   ```

### Demo Mode Usage
During Phase 1, the app runs in **Demo Mode**. 
On the **Login Screen**, you will see a **DEMO ROLE BYPASS** panel. Click any of the role cards (Parent, Teacher, Student, Admin) to instantly bypass password authentication and view the respective dashboard layout configured with mock data.
To change languages, toggle dark mode, or scale fonts, click the gear icon in the top-right of any dashboard to open the settings.

---

## 5. Phase 2 Backend Setup & Running Guide

### Prerequisites
* Python 3.9 or higher
* pip (Python package manager)

### Step-by-Step Launch

1. **Navigate to the backend directory:**
   ```bash
   cd backend
   ```

2. **Create a virtual environment (recommended):**
   ```bash
   python -m venv venv
   
   # On Windows
   venv\Scripts\activate
   
   # On macOS/Linux
   source venv/bin/activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Initialize the database:**
   ```bash
   python -c "from app.database import engine; from app.models import user, student, screening; user.Base.metadata.create_all(bind=engine); student.Base.metadata.create_all(bind=engine); screening.Base.metadata.create_all(bind=engine); print('Database initialized successfully')"
   ```

5. **Run the FastAPI server:**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

6. **Access the API documentation:**
   Open your browser and navigate to:
   - Swagger UI: `http://localhost:8000/docs`
   - ReDoc: `http://localhost:8000/redoc`

### API Endpoints Overview

**Users (`/api/v1/users`)**
- `POST /` - Create a new user
- `GET /` - List all users
- `GET /{user_id}` - Get user by ID
- `PUT /{user_id}` - Update user
- `DELETE /{user_id}` - Delete user

**Students (`/api/v1/students`)**
- `POST /` - Create a new student profile
- `GET /` - List all students
- `GET /{student_id}` - Get student by ID
- `GET /by-student-id/{student_external_id}` - Get student by external ID
- `PUT /{student_id}` - Update student
- `DELETE /{student_id}` - Delete student

**Screenings (`/api/v1/screenings`)**
- `POST /` - Create a screening record
- `POST /predict` - Submit questionnaire for model prediction and SHAP explanation (requires authentication)
- `GET /` - List all screenings
- `GET /{screening_id}` - Get screening by ID
- `GET /student/{student_id}` - Get all screenings for a student

### Historical Phase 2 Notes
- SQLite remains the default; `DATABASE_URL` can configure PostgreSQL when the PostgreSQL driver is installed.
- Passwords are hashed using bcrypt.
- Current `/predict` inference uses the bundled model and returns HTTP 503 on inference failure.
- CORS defaults to `*` for local development. Production startup requires explicit `CORS_ORIGINS`.

---

## 6. Phase 3 API Integration Guide

### Overview
Phase 3 connects the Flutter frontend with the FastAPI backend, enabling real data communication instead of demo mode.

### Prerequisites
- Complete Phase 1 (Flutter app setup)
- Complete Phase 2 (Backend setup and running)
- Backend server running on `http://localhost:8000`

### Step-by-Step Integration

1. **Install Flutter dependencies:**
   ```bash
   cd flutter_app
   flutter pub get
   ```

2. **Configure API base URL:**
   Edit `flutter_app/lib/services/api_config.dart`:
   - For Android emulator: Keep `http://10.0.2.2:8000` (default)
   - For physical device: Change to your machine's IP address (e.g., `http://192.168.1.100:8000`)
   - For production: Use your actual backend URL

3. **Run the Flutter app:**
   ```bash
   flutter run
   ```

4. **Enable API Mode:**
   - On the login screen, tap the cloud icon in the top-right
   - The icon will change from `cloud_off` (Demo Mode) to `cloud` (API Mode)
   - A snackbar will confirm the mode change

5. **Test the integration:**
   - In API mode, the login button will attempt to connect to the backend
   - API mode uses the JWT login endpoint; credentials are sent as OAuth2 form fields.
   - Protected student, screening, and intervention endpoints require a Bearer token.

### API Services Created

**User Service** (`lib/services/user_service.dart`)
- `createUser()` - Register new users
- `getUsers()` - List all users
- `getUserById()` - Get user by ID
- `updateUser()` - Update user details
- `deleteUser()` - Delete user

**Student Service** (`lib/services/student_service.dart`)
- `createStudent()` - Create student profile
- `getStudents()` - List all students
- `getStudentById()` - Get student by internal ID
- `getStudentByExternalId()` - Get student by external student_id
- `updateStudent()` - Update student details
- `deleteStudent()` - Delete student

**Screening Service** (`lib/services/screening_service.dart`)
- `createScreening()` - Create screening record
- `predictScreening()` - Submit questionnaire for prediction
- `getScreenings()` - List all screenings
- `getScreeningById()` - Get screening by ID
- `getStudentScreenings()` - Get screenings for a student

### Phase 3 Notes
- API mode can be toggled on/off from the login screen
- Demo mode remains available for UI testing without backend
- The old placeholder login and mock-only prediction notes are obsolete; consult the current implementation note at the top of this file.

---

## 7. Phase 4 JWT Authentication Implementation

### Overview
Phase 4 implements secure JWT (JSON Web Token) authentication to protect API endpoints and enable real user login functionality.

### Backend Changes

**New Authentication System:**
- JWT token generation and validation
- Password hashing with bcrypt
- OAuth2-compliant login endpoint
- Protected endpoints requiring authentication
- Token-based authorization middleware

**New Endpoints:**
- `POST /api/v1/auth/login` - Authenticate user and receive JWT token
- `GET /api/v1/auth/me` - Get current authenticated user info

**Protected Endpoints:**
All student and screening endpoints now require authentication:
- `POST /api/v1/students` - Create student (requires auth)
- `GET /api/v1/students` - List students (requires auth)
- `PUT /api/v1/students/{id}` - Update student (requires auth)
- `DELETE /api/v1/students/{id}` - Delete student (requires auth)
- Similar protections for screening endpoints

### Frontend Changes

**Authentication Service:**
- Token storage using SharedPreferences
- User session management
- Login/logout functionality
- Authentication state checking

**API Service Updates:**
- Automatic JWT token inclusion in request headers
- 401 error handling for unauthorized access
- Configurable authentication requirement per request

**Login Screen:**
- Real API login integration
- JWT token storage on successful login
- Role-based navigation after authentication
- Loading states and error handling

### Step-by-Step Setup

1. **Restart the backend server** (to pick up new auth dependencies):
   ```bash
   cd backend
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

2. **Create a test user** (via API or directly in database):
   ```bash
   # Using curl
   curl -X POST "http://localhost:8000/api/v1/users" \
     -H "Content-Type: application/json" \
     -d '{"username":"testuser","email":"test@example.com","password":"password123","role":"parent"}'
   ```

3. **Test the login endpoint:**
   ```bash
   curl -X POST "http://localhost:8000/api/v1/auth/login" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "username=testuser&password=password123"
   ```

4. **Run the Flutter app:**
   ```bash
   cd flutter_app
   flutter pub get
   flutter run
   ```

5. **Test authentication flow:**
   - Enable API mode on login screen (cloud icon)
   - Enter test credentials
   - Login should succeed and navigate to appropriate dashboard
   - Token is stored locally for subsequent API calls

### Security Notes

**Important for Production:**
- Set a strong random `SECRET_KEY` environment variable; the app refuses to start in production without it.
- Set `APP_ENV=production` and an explicit comma-separated `CORS_ORIGINS` allowlist.
- Enable HTTPS for all API communications
- Implement token refresh mechanism
- Add rate limiting to prevent brute force attacks
- Consider implementing 2FA for sensitive operations

### Phase 4 Notes
- JWT tokens expire after 30 minutes (configurable)
- Token refresh mechanism can be added in later phases
- All protected endpoints return 401 if token is invalid/expired
- Demo mode bypasses authentication entirely
- Admin-only account and intervention-management operations are enforced by backend role checks. Student-level ownership and school/class authorization are not fully modeled yet.

---

## 8. Phase 5 Intervention & Recommendation System

### Overview
Phase 5 implements a comprehensive intervention management system with personalized recommendations based on screening results. The system matches learning activities to a student's specific needs using the SHAP feature contributions from the ML model.

### Backend Changes

**Intervention Database Model:**
- Categories: Reading, Writing, Memory, Attention, Math, Social, General
- Difficulty levels: Beginner, Intermediate, Advanced
- Age range and grade level targeting
- Duration, materials, and learning objectives
- Detailed instructions for each activity

**New API Endpoints:**
- `POST /api/v1/interventions` - Create new intervention (admin only)
- `GET /api/v1/interventions` - List all interventions (with optional category filter)
- `GET /api/v1/interventions/{id}` - Get specific intervention
- `PUT /api/v1/interventions/{id}` - Update intervention (admin only)
- `DELETE /api/v1/interventions/{id}` - Delete intervention (admin only)
- `POST /api/v1/interventions/recommend` - Get personalized recommendations

**Recommendation Engine:**
- Matches SHAP top features to intervention categories
- Filters by student age and grade level
- Provides reasoning for each recommendation
- Returns top 3 most relevant interventions

### Frontend Changes

**Intervention Service:**
- Fetch interventions by category
- Get personalized recommendations
- Retrieve specific intervention details

### Step-by-Step Setup

1. **Initialize the intervention database table:**
   ```bash
   cd backend
   python -c "from app.database import engine; from app.models.intervention import Intervention; Intervention.metadata.create_all(bind=engine); print('Intervention table created')"
   ```

2. **Seed the database with sample interventions:**
   ```bash
   python seed_interventions.py
   ```

3. **Restart the backend server:**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

4. **Test the recommendation endpoint:**
   ```bash
   curl -X POST "http://localhost:8000/api/v1/interventions/recommend" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -d '{
       "student_age": 8,
       "student_grade": "3",
       "top_features": ["reading_difficulty", "attention_difficulty"],
       "risk_level": "Elevated"
     }'
   ```

### Sample Interventions Included

The seed script includes 13 sample interventions across categories:
- **Reading:** Phonics Flash Cards, Sight Word Bingo, Sentence Building Blocks
- **Writing:** Tracing Practice Sheets, Story Starters
- **Memory:** Memory Card Game, Number Sequence Recall
- **Attention:** Focus Timer Activities, Simon Says
- **Math:** Math Manipulatives, Math Fact Flash Cards
- **Social:** Turn-Taking Games, Emotion Charades

### Phase 5 Notes
- Interventions are age and grade-appropriate
- Recommendations are based on SHAP feature contributions
- Each intervention includes materials needed and learning objectives
- The system can be extended with more interventions over time
- Admin users can manage the intervention library

---

## 9. Phase 6 ML Model Integration & Explainable AI

### Overview
Phase 6 integrates a real machine learning model for learning difficulty screening with SHAP (SHapley Additive exPlanations) for model explainability. This replaces the mock predictions with actual ML inference while providing transparent explanations for predictions.

### Backend Changes

**ML Components:**
- XGBoost classifier; trained artifacts are bundled under `backend/ml/models/`.
- Feature scaling with StandardScaler
- SHAP TreeExplainer for feature attribution
- Model versioning and persistence
- HTTP 503 response if model inference or explainability is unavailable; no mock risk score is returned.

**ML Dependencies Added:**
- scikit-learn (machine learning library)
- pandas (data manipulation)
- numpy (numerical computing)
- xgboost (gradient boosting - optional for future use)
- shap (explainable AI)
- joblib (model serialization)

**Training Script (`ml/train_model.py`):**
- Reads a WALS CSV using a machine-specific absolute path currently defined in the script; the dataset is not included in this repository.
- Engineers six difficulty scores, age, grade, and four encoded preference features.
- Maps neurodivergence category labels to four risk classes and trains an XGBoost classifier.
- Saves model, scaler, feature columns, and metadata with versioning.

**Prediction Module (`ml/predictor.py`):**
- Loads trained model and scaler
- Performs real-time predictions
- Generates SHAP values for explainability
- Identifies top contributing features
- Returns risk level, probability, and feature contributions

**Updated Screening Endpoint:**
- Uses real ML model for predictions
- Integrates SHAP explainability
- Provides top contributing features for recommendations
- Returns an unavailable response if real model inference fails.

### Step-by-Step Setup

1. **Install ML dependencies:**
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

2. **Train the ML model:**
   ```bash
   python ml/train_model.py
   ```
   
   This requires the dataset at the exact path configured by `DATASET_PATH` in `ml/train_model.py`. It will:
   - Engineer features from the source dataset
   - Train an XGBoost model
   - Save model with versioning (e.g., `screening_model_v20240830_002400.joblib`)
   - Save scaler and feature columns
   - Save model metadata

3. **Restart the backend server:**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

4. **Test the prediction endpoint:**
   ```bash
   curl -X POST "http://localhost:8000/api/v1/screenings/predict" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -d '{
       "student_id": "STU001",
       "features": {
         "reading_difficulty": 4,
         "writing_difficulty": 3,
         "memory_difficulty": 2,
         "attention_difficulty": 4,
         "math_difficulty": 3,
         "social_difficulty": 2
       }
     }'
   ```

### Model Details

**Training Data:**
- The training script expects a WALS-labeled CSV outside this repository. The file and its provenance are not included here, so dataset size and provenance claims have not been independently verified.
- Labels are derived directly from the `neurodivergence_type` category; reported accuracy should not be interpreted as clinical validation.

**Features Used:**
- reading_difficulty (1-5 scale)
- writing_difficulty (1-5 scale)
- memory_difficulty (1-5 scale)
- attention_difficulty (1-5 scale)
- math_difficulty (1-5 scale)
- social_difficulty (1-5 scale)
- age (mapped from age groups)
- grade (mapped from education level)
- prior e-learning experience, font type, color theme, and layout mode (ordinal encoded)

**Model Performance:**
- Metadata and historical progress notes report very high accuracy, but those figures were not reproduced during this audit.
- The feature engineering derives difficulty inputs from the same category used to create target labels; independent validation is needed before relying on these metrics.

**SHAP Explainability:**
- Provides feature-level contribution scores
- Explains why a prediction was made
- Identifies top factors influencing risk level
- Used by recommendation engine for matching interventions

### Phase 6 Notes
- Model trained on real WALS Neurodivergent Learner Dataset
- Model versioning allows rollback to previous versions
- SHAP values provide transparent explanations
- Fallback mechanism ensures system stability
- Model can be retrained with new data without code changes
- Feature importance analysis shows writing and math difficulties as strongest predictors

---

## 10. Phase 7 Flutter ML Results UI & Design System Integration

### Overview
Phase 7 drastically overhauls the Flutter app UI to match the premium, minimalist **Google Stitch Apple Monochrome HIG** design system. It brings beautiful, explainable AI visualizations natively to the mobile application.

### Key Enhancements

**Design System (`lib/core/theme/app_theme.dart`):**
- Adopted strict Monochrome HIG tokens: Pure White (`#FFFFFF`) backgrounds, Off-White Surface (`#F7F7F9`), and Pitch Black (`#0A0A0A`) accents.
- Sub-pixel precise 0.5px borders and zero-elevation flat geometry.
- Typography updated to modern standards (Manrope / Hanken Grotesk references).

**Screening Flow & Visualization:**
- **ScreeningQuestionnaireScreen**: Completely rebuilt with clean 5-segmented rating bars for the 6 domains (Reading, Writing, Memory, Attention, Math, Social).
- **ScreeningResultScreen**: Introduces a stunning "Hero Risk Card" layout, mapping ML risk tiers (Mild, Moderate, Elevated) to muted diagnostic colors.
- **Explainable AI UI**: Features an intuitive Diverging SHAP Bar Chart that visually explains which factors (e.g., "Memory Difficulty") most heavily influenced the AI's decision.
- **Clinical Narrative**: Translates mathematical probabilities into human-readable clinical notes for teachers and parents.

**Core Screens Refreshed:**
- `LoginScreen` and Dashboards (Parent, Teacher, Student) refitted into the premium monochrome visual style while retaining full Riverpod state support and JWT workflows.

---

## 11. Phase 8 Testing & QA

### Overview
Phase 8 tracks checks for the backend and Flutter client. The results below are historical; current verification is recorded in `TESTING.md`.

### Backend Testing (Python)
- Written comprehensive test suites (`tests/test_api.py`, `tests/test_predictor.py`).
- The four ML predictor tests passed during the 2026-10-27 audit follow-up.
- The API suite did not complete in the current environment; see `TESTING.md`.
- Fully resolved Pyrefly and Pylance virtual in-memory false-positive linter errors using `.vscode/settings.json`, `.pyrefly.json` configuration, and explicit inline ignores.

### Frontend Testing (Flutter/Dart)
- Flutter analysis is not currently verified; see `TESTING.md`.
- Fixed deprecation warnings relating to Material 3 tokens (e.g., migrating `onBackground` to `onSurface`, and `withOpacity` to `withValues`).
- Ensured strong typing and null safety across all models and services.
