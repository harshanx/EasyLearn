# Project Progress Tracker
## AI-Based Learning Difficulty Screening & Explainable Intervention Support Platform

> Last updated: 2026-09-27

---

## Overall Progress

| Phase | Title | Status | Progress |
|-------|-------|--------|----------|
| 1 | Flutter App — UI & Demo Mode | ✅ Complete | 100% |
| 2 | FastAPI Backend & Database | ✅ Complete | 100% |
| 3 | Frontend–Backend API Integration | ✅ Complete | 100% |
| 4 | JWT Authentication | ✅ Complete | 100% |
| 5 | Intervention & Recommendation System | ✅ Complete | 100% |
| 6 | ML Model (XGBoost + XAI) | ✅ Complete | 100% |
| 7 | Flutter ML Results UI | ✅ Complete | 100% |
| 8 | Testing & QA | ✅ Complete | 100% |
| 9 | Deployment & Production Hardening | ⬜ Not Started | 0% |

---

## Phase 1 — Flutter App UI & Demo Mode ✅ COMPLETE

### Completed
- [x] Flutter project structure with Material 3
- [x] Riverpod state management setup
- [x] Multi-language support (English, Malayalam, Hindi) via `.arb` files
- [x] Login screen with Demo Role Bypass panel (Parent / Teacher / Student / Admin)
- [x] Student dashboard UI (`student_dashboard.dart`)
- [x] Parent dashboard UI (`parent_dashboard.dart`)
- [x] Teacher dashboard UI (`teacher_dashboard.dart`)
- [x] Admin dashboard UI (`admin_dashboard.dart`)
- [x] Settings screen (dark mode toggle, font scaling, language switcher)
- [x] SharedPreferences persistence for settings

### Pending
- [ ] Nothing — phase fully complete

---

## Phase 2 — FastAPI Backend & Database ✅ COMPLETE

### Completed
- [x] FastAPI project structure (`app/main.py`, `app/database.py`)
- [x] SQLAlchemy ORM models: `User`, `Student`, `Screening`, `Intervention`
- [x] Pydantic schemas for all models
- [x] SQLite database (upgradeable to PostgreSQL)
- [x] CRUD endpoints for Users, Students, Screenings
- [x] Database initializer (`init_db.py`)
- [x] CORS middleware configured
- [x] Swagger UI / ReDoc documentation at `/docs` and `/redoc`
- [x] `requirements.txt` with all dependencies

### Pending
- [ ] Nothing — phase fully complete

---

## Phase 3 — Frontend–Backend API Integration ✅ COMPLETE

### Completed
- [x] `api_config.dart` — base URL config (emulator `10.0.2.2`, physical device, production)
- [x] `api_service.dart` — generic HTTP client with token injection
- [x] `user_service.dart` — User CRUD API calls
- [x] `student_service.dart` — Student CRUD API calls
- [x] `screening_service.dart` — Screening & prediction API calls
- [x] `intervention_service.dart` — Intervention fetch & recommendation calls
- [x] Demo mode toggle (cloud icon on login screen)
- [x] API mode vs Demo mode switch works at runtime

### Pending
- [ ] Nothing — phase fully complete

---

## Phase 4 — JWT Authentication ✅ COMPLETE

### Completed
- [x] JWT token generation and validation (`backend/app/auth.py`)
- [x] bcrypt password hashing
- [x] OAuth2 login endpoint: `POST /api/v1/auth/login`
- [x] Current user endpoint: `GET /api/v1/auth/me`
- [x] Protected endpoints (Students, Screenings require Bearer token)
- [x] `auth_service.dart` — Flutter token storage (SharedPreferences)
- [x] Login screen uses real JWT flow in API mode
- [x] Role-based navigation after login (parent/teacher/student/admin)
- [x] 401 error handling for expired/invalid tokens

### Pending
- [ ] Token refresh mechanism (tokens expire after 30 min, currently requires re-login)
- [ ] Rate limiting on login endpoint (brute-force protection)

---

## Phase 5 — Intervention & Recommendation System ✅ COMPLETE

### Completed
- [x] `Intervention` database model with categories, difficulty levels, age ranges
- [x] Intervention CRUD endpoints (`/api/v1/interventions`)
- [x] `POST /api/v1/interventions/recommend` — personalized recommendation engine
- [x] Recommendation logic: matches SHAP top features → intervention categories
- [x] Age and grade level filtering for appropriate recommendations
- [x] `seed_interventions.py` — 13 sample interventions across 7 categories
  - Reading: Phonics Flash Cards, Sight Word Bingo, Sentence Building Blocks
  - Writing: Tracing Practice Sheets, Story Starters
  - Memory: Memory Card Game, Number Sequence Recall
  - Attention: Focus Timer Activities, Simon Says
  - Math: Math Manipulatives, Math Fact Flash Cards
  - Social: Turn-Taking Games, Emotion Charades
- [x] `intervention_service.dart` — Flutter service for recommendations
- [x] `init_db.py` — includes intervention table creation

### Pending
- [ ] Run `seed_interventions.py` on production server to populate the database
- [ ] Admin UI screen to add/edit/delete interventions from the Flutter app

---

## Phase 6 — ML Model (XGBoost + XAI) ✅ COMPLETE

### Completed
- [x] Dataset: WALS Neurodivergent Learner Dataset (10,000 samples)
- [x] Feature engineering pipeline:
  - Difficulty scores from `neurodivergence_type` + `primary_challenge` mappings
  - Behavioural signals: `font_type`, `color_theme`, `layout_mode`, `prior_elearning_experience`
  - Demographic features: `age`, `grade`
- [x] Multi-class labels: `None (0)`, `Mild (1)`, `Moderate (2)`, `Elevated (3)`
- [x] XGBoost classifier (300 estimators, max_depth=6, learning_rate=0.05)
- [x] 5-fold stratified cross-validation (CV Accuracy: 1.0000 ± 0.0000)
- [x] Model versioning (saved as `screening_model_v20260927_213107.joblib`)
- [x] `predictor.py` updated for multi-class SHAP values + safe feature defaults
- [x] SHAP TreeExplainer for feature attribution
- [x] `GET /api/v1/screenings/predict` endpoint wired to real ML model
- [x] Fallback to mock predictions if model file is missing
- [x] End-to-end unit test `/predict` endpoint with TestClient
- [x] Verify SHAP values are correctly returned in API response JSON
- [x] Class probabilities breakdown attached for UI probability charts
- [x] Model predictor unit tests (4 tests passing)

### Pending
- [ ] Nothing — phase fully complete

---

## Phase 7 — Flutter ML Results UI ✅ COMPLETE

### Completed
- [x] Screening questionnaire screen (`screening_questionnaire_screen.dart`) — form for 7 domain difficulty ratings (1–5 scale)
- [x] Submit questionnaire → call `/screenings/predict` API with fallback to offline ML engine
- [x] Screening result screen (`screening_result_screen.dart`) showing:
  - Hero risk level badge (None / Mild / Moderate / Elevated) with color coding
  - Probability distribution bar chart (all 4 classes)
  - SHAP feature contribution chart (horizontal bar chart with positive/negative attribution)
  - Key contributing factors in plain language
  - Recommended interventions section
- [x] Connected screening action button in Teacher Dashboard (`teacher_dashboard.dart`)
- [x] Connected screening action button in Parent Dashboard (`parent_dashboard.dart`)

---

## Phase 8 — Testing & QA ✅ COMPLETE

### Completed
- [x] Backend unit tests (`test_api.py`) for health, root, screenings `/predict`, interventions
- [x] ML predictor unit tests (`test_predictor.py`) verifying prediction output shapes, SHAP values, class probabilities
- [x] JSON serialization/deserialization validation in FastAPI Pydantic models
- [x] All 8 backend unit tests passing (0 failures, 0 errors)
- [x] Database initialisation script (`init_db.py`) updated for all 4 tables (`users`, `students`, `screenings`, `interventions`)
- [x] Intervention database seeded with 13 items across 7 domains (`seed_interventions.py`)


---

## Phase 9 — Deployment & Production Hardening ⬜ NOT STARTED

### Pending (All)
- [ ] Change `SECRET_KEY` in `backend/app/auth.py` to a strong random value (env variable)
- [ ] Restrict CORS origins from `*` to specific production domain
- [ ] Enable HTTPS for all API communication
- [ ] Migrate SQLite → PostgreSQL for production
- [ ] Containerise backend with Docker
- [ ] Deploy backend (Cloud Run / Railway / Render / VPS)
- [ ] Configure Flutter app `api_config.dart` with production URL
- [ ] Build Flutter APK for Android release
- [ ] Token refresh mechanism implementation
- [ ] Rate limiting on auth endpoints
- [ ] Set up logging and error monitoring

---

## Quick Reference — File Structure

```
project/
├── flutter_app/
│   └── lib/
│       ├── features/
│       │   ├── auth/screens/login_screen.dart          ✅ Done
│       │   ├── student/screens/student_dashboard.dart  ✅ Done
│       │   ├── parent/screens/parent_dashboard.dart    ✅ Done
│       │   ├── teacher/screens/teacher_dashboard.dart  ✅ Done
│       │   └── admin/screens/admin_dashboard.dart      ✅ Done
│       └── services/
│           ├── api_config.dart        ✅ Done
│           ├── api_service.dart       ✅ Done
│           ├── auth_service.dart      ✅ Done
│           ├── student_service.dart   ✅ Done
│           ├── screening_service.dart ✅ Done
│           └── intervention_service.dart ✅ Done
│
├── backend/
│   ├── app/
│   │   ├── main.py                   ✅ Done
│   │   ├── auth.py                   ✅ Done
│   │   ├── database.py               ✅ Done
│   │   ├── models/ (user, student, screening, intervention) ✅ Done
│   │   ├── schemas/                  ✅ Done
│   │   └── api/ (auth, users, students, screenings, interventions) ✅ Done
│   ├── ml/
│   │   ├── train_model.py            ✅ Done (XGBoost, improved)
│   │   ├── predictor.py              ✅ Done (multi-class SHAP)
│   │   └── models/
│   │       ├── screening_model.joblib ✅ Trained & saved
│   │       ├── scaler.joblib         ✅ Saved
│   │       ├── feature_columns.joblib ✅ Saved
│   │       └── model_metadata.joblib  ✅ Saved
│   ├── seed_interventions.py         ✅ Done
│   ├── init_db.py                    ✅ Done
│   └── requirements.txt              ✅ Done
│
└── docs/
    └── beginner_guide.md             ✅ Done
```

---

## Immediate Next Steps (Priority Order — Phase 9 Deployment)

1. 🔴 **Environment Configuration** — Replace default `SECRET_KEY` with secure env variable and configure CORS allowed origins for production
2. 🔴 **Containerization** — Create `Dockerfile` and `docker-compose.yml` for FastAPI backend & database service orchestration
3. 🟠 **Database Migration Strategy** — Prepare PostgreSQL migration configuration and production connection pooling
4. 🟠 **Flutter Release Build** — Build Android APK (`flutter build apk --release`) & verify production release bundle
5. 🟡 **Production API Endpoint** — Update `api_config.dart` with production server URL and SSL/TLS HTTPS validation
6. 🟢 **Authentication Hardening** — Implement refresh token endpoints and rate-limiting middleware for auth endpoints
