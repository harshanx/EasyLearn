# Roadmap

This roadmap is based on the source audit dated 2026-10-27. Status reflects inspected implementation and checks, not earlier progress claims.

## P0 — Complete verification of current changes

- [ ] Install backend dependencies from `backend/requirements.txt`, including `httpx2`, then run the full backend suite.
- [ ] Run `flutter analyze` and Flutter tests in an environment where the Flutter SDK can finish startup.
- [ ] Exercise authenticated login, screening prediction, model-unavailable behavior, and recommendations against a local test database.

## P1 — Privacy and access policy

- [ ] Decide which users may access each student and screening record.
- [ ] Add teacher/class/school and student-account associations if required by the confirmed policy.
- [ ] Enforce ownership and role rules on list, detail, create, update, and delete operations.
- [ ] Add tests for unauthorized, cross-owner, and permitted access paths.

## P2 — Model validation and data governance

- [ ] Replace the machine-specific dataset path with configured, reproducible data handling.
- [ ] Record dataset source, consent/licensing status, preprocessing, and model version provenance.
- [ ] Review feature/label construction and evaluate on independent, representative data.
- [ ] Evaluate calibration, age coverage, subgroup performance, and limitations with qualified education/health reviewers.
- [ ] Present screening output as non-diagnostic decision support.

## P3 — Production operations

- [ ] Add login rate limiting, administrator bootstrap/recovery, structured logging, and operational health checks.
- [ ] Move mobile tokens to secure platform storage.
- [ ] Provision and exercise the selected production database and deployment environment.
- [ ] Configure HTTPS, production API URL, backup/restore, and monitoring.
- [ ] Build and verify supported Flutter release targets.

## P4 — Documentation and requirements reconciliation

- [ ] Review `SDD_EasyLearn.md` and `SRS_EasyLearn.md` with the project owner; do not treat conflicting design text as implemented behavior.
- [ ] Update the confirmed design and requirements documents after intent is resolved.
