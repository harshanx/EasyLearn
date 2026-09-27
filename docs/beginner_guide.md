# Beginner Developer's Architectural Guide

This guide answers key architectural questions to help you understand how the learning difficulty screening system works.

---

## 1. Core Technical Terms

### What is Flutter?
**Flutter** is an open-source UI software development kit created by Google. It allows you to build cross-platform applications (Android, iOS, Web, Desktop) from a single codebase. Rather than converting your code into native widgets, Flutter draws the entire user interface using a high-performance rendering engine (Impeller/Skia).

### What is Dart?
**Dart** is the programming language used to write Flutter applications. It is client-optimized, supports object-oriented programming, and provides:
* **Ahead-Of-Time (AOT) compilation** for fast native machine code execution in production.
* **Just-In-Time (JIT) compilation** during development, which powers Flutter's famous "Hot Reload" feature.

### What is FastAPI?
**FastAPI** is a modern, high-performance web framework for building APIs with Python. It is built on top of standard Python type hints, making it extremely fast to develop, self-documenting (via Swagger UI), and fast to execute.

### What is a REST API?
A **REST API** (Representational State Transfer) is a set of rules that allows two software systems to communicate over the web using HTTP protocols. The Flutter app (Client) sends requests (GET, POST, etc.) to the FastAPI server (Backend) using URLs, and the server returns structured data (usually in JSON format).

### What is PostgreSQL?
**PostgreSQL** is an advanced, enterprise-grade relational database management system. It stores the system's persistent information (user accounts, student profiles, past screening results) in structured tables linked by foreign key relationships.

---

## 2. Machine Learning & Explainable AI (XAI)

### What is Machine Learning?
Instead of writing complex manual coding rules (e.g., `if reading < 2 and memory < 3`), **Machine Learning** is a branch of artificial intelligence where algorithms analyze historical datasets to learn statistical relationships. The computer program trains a mathematical model to identify patterns automatically.

### What is Classification?
**Classification** is a type of supervised learning where the model's job is to predict a category or label. In our project, it's a binary/multiclass classification: predicting whether a child displays patterns suggesting an elevated screening risk for learning difficulties (e.g., "Elevated" vs. "Lower").

### What is SHAP?
**SHAP** (SHapley Additive exPlanations) is a framework used to explain the output of machine learning models. Standard machine learning models (like Random Forests or Gradient Boosting) are "black boxes"—they give a prediction, but we don't know *why*. 
SHAP calculates the contribution of each individual feature (e.g., how much the student's spelling difficulty score increased or decreased the predicted risk percentage).

---

## 3. Communication & Data Flow

### How does Flutter communicate with Python?
1. The **Flutter app** makes an HTTPS request to a backend endpoint:
   `POST https://backend-server/api/v1/predictions`
2. The request body contains a JSON object representing the student's questionnaire responses:
   ```json
   {
     "student_id": "STU001",
     "features": {
       "reading_difficulty": 4,
       "writing_difficulty": 2
     }
   }
   ```
3. The **FastAPI backend** parses the request, feeds the features into the Python ML model, and returns the response:
   ```json
   {
     "risk_level": "Elevated",
     "model_probability": 0.82
   }
   ```
4. The **Flutter app** receives the JSON response and updates the UI instantly using Riverpod state management.

### How is the prediction and explanation generated?
```
[Questionnaire Responses] 
        │
        ▼ (API Request)
[FastAPI Backend] ──> [ML Model (XGBoost/RF)] ──> [Probability Score (82%)]
        │
        ▼ (Pass to SHAP)
[SHAP Explainer] ──> [Shapley Values (Reading contribution: +0.45)]
        │
        ▼ (Combine & Format)
[JSON API Response] ──> [Flutter UI Card & Explanations]
```

### How does the recommendation engine work?
The system utilizes a transparent, rule-based matching algorithm in the backend database:
1. The backend inspects the top contributing features calculated by **SHAP**.
2. If the feature `reading_difficulty` shows a high positive contribution, the engine queries the `Interventions` database for activities categorized under `Reading`.
3. It filters these activities based on the student's `Age` and `Grade`.
4. It returns the top 3 recommended exercises, along with a human-readable justification (e.g., *"Recommended because reading-related indicators were contributors in this screening result."*).
