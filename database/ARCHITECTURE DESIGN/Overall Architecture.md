## Overall Architecture – Behavioral Health Tracker

The Behavioral Health Tracker is a modular, ethically-driven Oracle PL/SQL system designed to monitor patient well-being, enforce responsible data practices, and support clinical decision-making. Its architecture integrates core relational tables, business logic via triggers and procedures, and audit mechanisms to ensure transparency and compliance.

---

## 🧱 1. **Layered Architecture Overview**

| Layer                  | Components                                                                 |
|------------------------|----------------------------------------------------------------------------|
| **Data Layer**         | Core tables: `PATIENTS`, `VISITS`, `BEHAVIORAL_TRENDS`, `ALERTS`, `HOLIDAYS`, `AUDIT_LOG` |
| **Business Logic Layer** | Triggers, procedures, and packages enforcing ethical rules and automation |
| **Audit & Compliance Layer** | `AUDIT_LOG`, error handling, and logging triggers for traceability         |
| **Presentation Layer** | Dashboards, reports, and summaries (optional BI layer)                     |

---

## 🧩 2. **Core Modules and Responsibilities**

### 👤 PATIENTS
- Stores demographic and contact information
- Uses identity-based primary key
- Serves as the anchor for all other modules

### 🗓️ VISITS
- Logs patient visits with mood scores and notes
- Enforced by triggers to block scheduling on weekends/holidays

### 📈 BEHAVIORAL_TRENDS
- Tracks longitudinal behavioral metrics (e.g., mood, risk)
- Triggers auto-generate alerts for high-risk scores

### 🚨 ALERTS
- Stores system-generated or manual alerts
- Categorized by risk level (Low, Moderate, High)
- Linked to audit logs for accountability

### 📅 HOLIDAYS
- Defines non-working days
- Used by triggers to block unethical visit scheduling

### 🧾 AUDIT_LOG
- Captures all DML operations (INSERT, UPDATE, DELETE)
- Includes user, timestamp, status, and reason
- Ensures transparency and traceability

---

## ⚙️ 3. **Triggers and Automation**

- `TRG_BLOCK_WEEKENDS_HOLIDAYS`: Prevents unethical visit scheduling
- `TRG_LOG_VISITS_INSERT`: Logs every visit insertion
- `TRG_AUTO_ALERT_FROM_TRENDS`: Generates alerts for high-risk behavioral scores
- All triggers write to `AUDIT_LOG` for traceability

---

## 🔐 4. **Ethical Safeguards**

- No manual ID insertion (uses identity columns)
- No visit scheduling on weekends or holidays
- No silent data changes (all actions logged)
- No deletion of audit logs (immutability)
- Alerts are auto-generated to flag risk without clinician delay

---

## 🔗 5. **Entity Relationships**

- One `PATIENT` → many `VISITS`, `BEHAVIORAL_TRENDS`, and `ALERTS`
- `BEHAVIORAL_TRENDS` → triggers `ALERTS`
- All modules → log to `AUDIT_LOG`
- `HOLIDAYS` → referenced by visit triggers



