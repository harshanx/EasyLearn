# Software Requirements Specification (SRS)
## EasyLearn — AI-Based Learning Difficulty Screening & Explainable Intervention Support Platform

| Field | Detail |
|---|---|
| **Document Version** | 1.0 |
| **Status** | Final Draft |
| **Date** | October 2026 |
| **Prepared By** | Harshan PV |
| **Project Type** | Academic Final-Year Project |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Overall Description](#2-overall-description)
3. [Stakeholders & User Roles](#3-stakeholders--user-roles)
4. [Functional Requirements](#4-functional-requirements)
5. [Non-Functional Requirements](#5-non-functional-requirements)
6. [System Constraints](#6-system-constraints)
7. [External Interface Requirements](#7-external-interface-requirements)
8. [Data Requirements](#8-data-requirements)

---

## 1. Introduction

### 1.1 Purpose
This Software Requirements Specification (SRS) describes the complete functional and non-functional requirements for **EasyLearn**, an AI-powered mobile platform designed to assist educators and parents in the early identification of learning difficulties in school-age children and to recommend individualized, evidence-based intervention activities with transparent AI explanations.

### 1.2 Scope
The EasyLearn system consists of three integrated components:
- A **Flutter Android mobile application** — the primary user interface.
- A **Python FastAPI backend** — business logic, REST API, and ML inference engine.
- **Firebase services** — Authentication (Email/Password + Google Sign-In), Firestore (user role data), and Firebase Storage (report uploads).

The system supports four user roles: **Parent**, **Teacher**, **Student**, and **Admin**.

### 1.3 Definitions, Acronyms & Abbreviations

| Term | Definition |
|---|---|
| SRS | Software Requirements Specification |
| ML | Machine Learning |
| XAI | Explainable Artificial Intelligence |
| SHAP | SHapley Additive exPlanations — a method to explain model predictions |
| API | Application Programming Interface |
| JWT | JSON Web Token |
| FR | Functional Requirement |
| NFR | Non-Functional Requirement |
| WALS | Worldwide Adaptive Learning Study (dataset source) |
| HIG | Human Interface Guidelines |
| Riverpod | A reactive state management library for Flutter |

### 1.4 Overview
Section 2 provides an overall product perspective. Section 3 defines user roles. Section 4 lists detailed functional requirements. Section 5 covers non-functional requirements. Sections 6–8 describe constraints, interfaces, and data requirements.

---

## 2. Overall Description

### 2.1 Product Perspective
EasyLearn is a standalone mobile platform. It communicates with a cloud-hosted FastAPI backend via a secure REST API. Firebase handles identity management (authentication) and user role persistence (Firestore). The ML model runs server-side inside the FastAPI backend and produces SHAP-based explanations alongside predictions.

```
┌──────────────────────────────────────────────────────────────────┐
│                     Flutter Android App                          │
│     (Material 3 · Riverpod State · Firebase Auth · Multi-Lang)  │
└───────────────────────────┬──────────────────────────────────────┘
                            │ HTTPS REST  (Bearer: Firebase ID Token)
                            ▼
┌──────────────────────────────────────────────────────────────────┐
│                      FastAPI Backend                             │
│    (Firebase Admin SDK token verification · SQLAlchemy · SQLite) │
└────────────────┬────────────────────────────────┬────────────────┘
                 │                                │
                 ▼                                ▼
    ┌────────────────────────┐      ┌─────────────────────────────┐
    │      ML Engine         │      │        XAI Engine           │
    │  XGBoost / Rand. Forest│      │   SHAP TreeExplainer        │
    └────────────────────────┘      └─────────────────────────────┘
                            │
                            ▼
                   Firebase Services
          (Auth · Firestore · Firebase Storage)
```

### 2.2 Product Functions (Summary)
- User registration and role-based access via Firebase Auth.
- Student profile management by parents and teachers.
- Multi-domain screening questionnaire submission.
- Real-time ML risk prediction (None / Mild / Moderate / Elevated).
- Explainable AI output — SHAP diverging bar chart and clinical narrative.
- Personalized intervention recommendations.
- Multi-language UI (English, Malayalam, Hindi).
- Accessibility controls (font scaling, high contrast, reduced motion).
- Admin-level user and intervention library management.

### 2.3 User Classes and Characteristics
See Section 3.

### 2.4 Operating Environment
- **Mobile:** Android 8.0 (API 26) or higher.
- **Backend:** Python 3.9+, uvicorn ASGI server.
- **Database:** SQLite (development) / upgradeable to PostgreSQL (production).
- **Cloud:** Firebase (Google Cloud infrastructure).

### 2.5 Assumptions and Dependencies
- The user has an active internet connection for API calls and Firebase Auth.
- A `google-services.json` file is present in `flutter_app/android/app/` for Firebase connectivity.
- The FastAPI backend is running and reachable at a configured URL.
- The ML model files (`screening_model.joblib`, `scaler.joblib`, `feature_columns.joblib`) are pre-trained and present in `backend/ml/models/`.

---

## 3. Stakeholders & User Roles

| Role | Description | Primary Capabilities |
|---|---|---|
| **Parent** | Guardian of a student. Primary initiator of screenings. | Register, add student profiles, run screenings, view results & recommendations, view screening history |
| **Teacher** | School educator. Monitors student progress. | View student profiles (linked by admin), initiate screenings, view results, access intervention library |
| **Student** | The child being screened. Limited access. | View own results and recommended activities |
| **Admin** | Platform administrator. | Full CRUD on all users, students, screenings; manage intervention library; role assignment |

---

## 4. Functional Requirements

### 4.1 Authentication & Authorization

| ID | Requirement |
|---|---|
| FR-AUTH-01 | The system SHALL allow users to register with email and password via Firebase Authentication. |
| FR-AUTH-02 | The system SHALL allow users to sign in using Google Sign-In via Firebase Authentication. |
| FR-AUTH-03 | On first login, the system SHALL prompt the user to select a role (Parent, Teacher, Student). |
| FR-AUTH-04 | The selected role SHALL be persisted as a document in Firestore under `/users/{firebaseUID}`. |
| FR-AUTH-05 | The system SHALL maintain an authenticated session using Firebase ID tokens, refreshed automatically. |
| FR-AUTH-06 | All FastAPI backend API calls SHALL include the Firebase ID token as a Bearer token in the `Authorization` header. |
| FR-AUTH-07 | The FastAPI backend SHALL verify Firebase ID tokens using the Firebase Admin SDK on every protected request. |
| FR-AUTH-08 | The system SHALL support a developer bypass (master email) that grants super-admin access for testing. |
| FR-AUTH-09 | The system SHALL support logout, clearing the Firebase session and navigating to the login screen. |
| FR-AUTH-10 | The admin role SHALL only be assignable via the Firebase Admin SDK or the admin dashboard. |

### 4.2 User Profile Management

| ID | Requirement |
|---|---|
| FR-USER-01 | The system SHALL allow creation, reading, updating, and deletion (CRUD) of user accounts. |
| FR-USER-02 | User data stored in SQLite SHALL include: `id`, `username`, `email`, `hashed_password` (legacy), `role`, `full_name`, `created_at`, `updated_at`. |
| FR-USER-03 | User roles SHALL be one of: `parent`, `teacher`, `student`, `admin`. |
| FR-USER-04 | Admins SHALL be able to list all users via `GET /api/v1/users`. |

### 4.3 Student Profile Management

| ID | Requirement |
|---|---|
| FR-STU-01 | Parents and teachers SHALL be able to create student profiles. |
| FR-STU-02 | A student profile SHALL store: `student_id` (external), `full_name`, `age`, `grade`, `parent_id`. |
| FR-STU-03 | The system SHALL support retrieval of a student by internal ID and external student ID. |
| FR-STU-04 | The system SHALL support updating and deleting student profiles (authenticated, authorized users only). |
| FR-STU-05 | Deleting a student SHALL cascade-delete all associated screenings. |

### 4.4 Screening Questionnaire

| ID | Requirement |
|---|---|
| FR-SCR-01 | The system SHALL present a 6-domain questionnaire: Reading, Writing, Memory, Attention, Math, and Social difficulty. |
| FR-SCR-02 | Each domain SHALL be rated on a 1–5 scale using a segmented rating bar. |
| FR-SCR-03 | The questionnaire SHALL optionally accept supplemental behavioral features: prior e-learning experience, font type preference, color theme preference, layout mode preference. |
| FR-SCR-04 | The system SHALL validate that all 6 core domain fields are completed before submission. |
| FR-SCR-05 | On submission, the questionnaire data SHALL be sent to `POST /api/v1/screenings/predict`. |

### 4.5 ML Risk Prediction

| ID | Requirement |
|---|---|
| FR-ML-01 | The backend SHALL run an XGBoost / Random Forest classifier to predict risk level from submitted features. |
| FR-ML-02 | The system SHALL output one of four risk levels: **None**, **Mild**, **Moderate**, **Elevated**. |
| FR-ML-03 | The system SHALL return the probability score of the predicted class (0.0–1.0). |
| FR-ML-04 | The system SHALL return probabilities for all four risk classes for dashboard visualization. |
| FR-ML-05 | If the ML model files are unavailable, the backend SHALL fall back to a mock prediction without crashing. |
| FR-ML-06 | The model SHALL be trained on the WALS Neurodivergent Learner Dataset (10,000 samples). |

### 4.6 Explainable AI (XAI)

| ID | Requirement |
|---|---|
| FR-XAI-01 | The backend SHALL compute SHAP values for each prediction using `shap.TreeExplainer`. |
| FR-XAI-02 | The system SHALL return a per-feature SHAP contribution dictionary alongside each prediction. |
| FR-XAI-03 | The Flutter app SHALL render a **diverging SHAP bar chart** displaying which features pushed the prediction toward or away from elevated risk. |
| FR-XAI-04 | The Flutter app SHALL display a **clinical narrative** translating the mathematical prediction into a human-readable explanation for parents and teachers. |
| FR-XAI-05 | The system SHALL identify the top-N features by absolute SHAP magnitude for use by the recommendation engine. |

### 4.7 Intervention Recommendation System

| ID | Requirement |
|---|---|
| FR-INT-01 | The system SHALL maintain a library of intervention activities, each with: category, difficulty level, age range, grade level, duration, materials, learning objectives, and instructions. |
| FR-INT-02 | Intervention categories SHALL include: Reading, Writing, Memory, Attention, Math, Social, and General. |
| FR-INT-03 | The system SHALL match SHAP top features to intervention categories to generate personalized recommendations. |
| FR-INT-04 | The recommendation endpoint SHALL filter interventions by student age and grade level. |
| FR-INT-05 | The system SHALL return the top 3 most relevant interventions per screening. |
| FR-INT-06 | Each recommendation SHALL include a human-readable reasoning string explaining why it was selected. |
| FR-INT-07 | Admins SHALL be able to perform full CRUD operations on the intervention library. |

### 4.8 Dashboard Views

| ID | Requirement |
|---|---|
| FR-DASH-01 | Each role (Parent, Teacher, Student, Admin) SHALL have a dedicated dashboard screen. |
| FR-DASH-02 | The **Parent Dashboard** SHALL display linked students, their latest risk levels, and quick-access to new screening. |
| FR-DASH-03 | The **Teacher Dashboard** SHALL display a list of students and their screening summaries. |
| FR-DASH-04 | The **Student Dashboard** SHALL display the student's own latest screening result and recommended activities. |
| FR-DASH-05 | The **Admin Dashboard** SHALL display user management, student management, and intervention library controls. |

### 4.9 Localization

| ID | Requirement |
|---|---|
| FR-L10N-01 | The app SHALL support three languages: English (`en`), Malayalam (`ml`), and Hindi (`hi`). |
| FR-L10N-02 | Language strings SHALL be managed via `.arb` files and generated using `flutter gen-l10n`. |
| FR-L10N-03 | The selected language SHALL be persisted locally using `SharedPreferences`. |

### 4.10 Accessibility & Settings

| ID | Requirement |
|---|---|
| FR-ACC-01 | The app SHALL provide a text size multiplier (scaling factor) adjustable by the user. |
| FR-ACC-02 | The app SHALL provide a high-contrast mode toggle. |
| FR-ACC-03 | The app SHALL provide a reduce-motion toggle to disable animations. |
| FR-ACC-04 | The app SHALL support light mode, dark mode, and system-default theme. |
| FR-ACC-05 | All accessibility settings SHALL be persisted locally via `SharedPreferences`. |

---

## 5. Non-Functional Requirements

### 5.1 Performance

| ID | Requirement |
|---|---|
| NFR-PERF-01 | The ML prediction endpoint SHALL respond within **3 seconds** under normal load. |
| NFR-PERF-02 | The Flutter app SHALL reach the login screen within **2 seconds** of cold launch on a mid-range Android device. |
| NFR-PERF-03 | API requests SHALL time out after **30 seconds** with appropriate error handling. |

### 5.2 Security

| ID | Requirement |
|---|---|
| NFR-SEC-01 | All API communication SHALL use HTTPS in production. |
| NFR-SEC-02 | Firebase ID tokens SHALL be verified server-side on every protected API call. |
| NFR-SEC-03 | Passwords (legacy backend users) SHALL be hashed using `bcrypt`. |
| NFR-SEC-04 | No sensitive credentials SHALL be committed to version control. |
| NFR-SEC-05 | Firebase Security Rules SHALL restrict Firestore reads/writes to authenticated users only. |

### 5.3 Usability

| ID | Requirement |
|---|---|
| NFR-USE-01 | The UI SHALL conform to the **Monochrome HIG Design System** — flat, premium, minimal aesthetic. |
| NFR-USE-02 | The app SHALL support screen readers via Flutter's Semantics API. |
| NFR-USE-03 | All interactive elements SHALL have unique, descriptive IDs for accessibility and testing. |
| NFR-USE-04 | The questionnaire SHALL be completable by a non-technical parent within **5 minutes**. |

### 5.4 Reliability

| ID | Requirement |
|---|---|
| NFR-REL-01 | The system SHALL provide a **demo mode** with mock data that functions without any backend connectivity. |
| NFR-REL-02 | The backend SHALL gracefully fall back to mock ML predictions if model files are missing. |
| NFR-REL-03 | The Flutter app SHALL display informative error messages on network failures. |

### 5.5 Maintainability

| ID | Requirement |
|---|---|
| NFR-MAINT-01 | The codebase SHALL have **0 Flutter analyzer errors**. |
| NFR-MAINT-02 | The backend test suite SHALL maintain **100% pass rate** (8/8 tests). |
| NFR-MAINT-03 | The ML model SHALL support retraining with new data without code changes. |
| NFR-MAINT-04 | The ML model SHALL use versioned filenames with timestamps. |

### 5.6 Scalability

| ID | Requirement |
|---|---|
| NFR-SCALE-01 | The backend database SHALL be upgradeable from SQLite to PostgreSQL without application-layer code changes. |
| NFR-SCALE-02 | The intervention library SHALL be extensible with new entries without code changes (database-driven). |

---

## 6. System Constraints

- **Platform:** Android only (iOS support not in scope for this version).
- **Flutter SDK:** v3.10.8 or compatible.
- **Python:** 3.9 or higher.
- **Connectivity:** Internet connection required for authentication, API calls, and cloud sync. Demo mode works offline.
- **Firebase Free Tier:** All Firebase services SHALL operate within the Spark (free) tier limits.
- **Dataset:** ML model trained on the WALS Neurodivergent Learner Dataset; synthetic augmentation is permitted.

---

## 7. External Interface Requirements

### 7.1 User Interface
- Flutter Material 3 widgets with Monochrome HIG design tokens.
- Typography: Google Fonts (Manrope / Hanken Grotesk).
- Navigation: `CupertinoPageRoute` transitions, Riverpod-driven state.

### 7.2 Hardware Interface
- Android device with minimum 2GB RAM.
- Camera access (future: document upload via Firebase Storage).
- Internet connectivity (Wi-Fi or mobile data).

### 7.3 Software Interface

| Interface | Description |
|---|---|
| **Firebase Authentication** | `firebase_auth` Flutter plugin — Email/Password, Google Sign-In |
| **Cloud Firestore** | `cloud_firestore` Flutter plugin — user role documents |
| **Firebase Storage** | `firebase_storage` Flutter plugin — report/document uploads |
| **FastAPI Backend** | REST API over HTTPS; endpoints under `/api/v1/` |
| **Firebase Admin SDK** | Python `firebase-admin` — backend token verification |
| **Google Sign-In** | `google_sign_in` Flutter plugin |

### 7.4 Communication Interface
- Protocol: HTTPS (REST/JSON).
- Auth Header: `Authorization: Bearer <Firebase ID Token>`.
- Content-Type: `application/json`.
- Timeout: 30 seconds.
- Base URL (emulator): `http://10.0.2.2:8000`; (device): configurable IP.

---

## 8. Data Requirements

### 8.1 Firestore Schema

```
/users/{firebaseUID}
  ├── email: String
  ├── displayName: String
  ├── role: "parent" | "teacher" | "student" | "admin"
  └── createdAt: Timestamp
```

### 8.2 SQLite / PostgreSQL Schema

**users** table

| Column | Type | Constraints |
|---|---|---|
| id | INTEGER | PK, auto-increment |
| username | VARCHAR | UNIQUE, NOT NULL |
| email | VARCHAR | UNIQUE, NOT NULL |
| hashed_password | VARCHAR | NOT NULL |
| role | ENUM | parent/teacher/student/admin |
| full_name | VARCHAR | nullable |
| created_at | DATETIME | server default |
| updated_at | DATETIME | on update |

**students** table

| Column | Type | Constraints |
|---|---|---|
| id | INTEGER | PK |
| student_id | VARCHAR | UNIQUE, NOT NULL |
| full_name | VARCHAR | NOT NULL |
| age | INTEGER | nullable |
| grade | VARCHAR | nullable |
| parent_id | INTEGER | FK → users.id |

**screenings** table

| Column | Type | Constraints |
|---|---|---|
| id | INTEGER | PK |
| student_id | INTEGER | FK → students.id |
| screening_date | DATETIME | server default |
| risk_level | VARCHAR | None/Mild/Moderate/Elevated |
| model_probability | FLOAT | 0.0–1.0 |
| features_data | TEXT | JSON |
| shap_explanation | TEXT | JSON |

**interventions** table

| Column | Type | Description |
|---|---|---|
| id | INTEGER | PK |
| title | VARCHAR | Activity name |
| description | TEXT | Summary |
| category | VARCHAR | Reading/Writing/Memory/Attention/Math/Social/General |
| difficulty | VARCHAR | Beginner/Intermediate/Advanced |
| age_min / age_max | INTEGER | Target age range |
| grade_level | VARCHAR | e.g., "1-3" |
| duration_minutes | INTEGER | Estimated time |
| materials | TEXT | Comma-separated list |
| instructions | TEXT | Step-by-step guide |
| learning_objectives | TEXT | Goals |

### 8.3 ML Feature Schema

| Feature | Scale | Description |
|---|---|---|
| reading_difficulty | 1–5 | Questionnaire domain score |
| writing_difficulty | 1–5 | Questionnaire domain score |
| memory_difficulty | 1–5 | Questionnaire domain score |
| attention_difficulty | 1–5 | Questionnaire domain score |
| math_difficulty | 1–5 | Questionnaire domain score |
| social_difficulty | 1–5 | Questionnaire domain score |
| age | numeric | Student age (mapped from age group) |
| grade | numeric | Education level (encoded) |
| prior_elearning_exp_enc | 0–2 | Prior e-learning experience (encoded) |
| font_type_enc | 0–N | Font preference (encoded) |
| color_theme_enc | 0–N | Color theme (encoded) |
| layout_mode_enc | 0–N | Layout preference (encoded) |

---

*End of SRS — EasyLearn v1.0*
