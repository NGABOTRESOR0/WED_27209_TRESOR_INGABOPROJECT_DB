# WED_27209_TRESOR_INGABOPROJECT_DB
#### **Student Name:** NGABO TRESOR  
#### **Student ID:** 27209  
#### **Course:** Database Development with PL/SQL (INSY 8311)  
#### **Institution:** Adventist University of Central Africa (AUCA)   
#### **Lecturer:** Eric Maniraguha

## Project Overview
The purpose was to ethically monitor and analyze patient behavioral trends over time using Oracle and PL/SQL, enabling early detection of concerning patterns and triggering responsible interventions. The system is designed with a strong emphasis on data integrity, ethical safeguards, and auditability.

## The Problem Description
In behavioral healthcare settings, early detection of concerning patterns—such as mood deterioration, erratic behavior, or missed appointments—is critical for timely intervention. However, many systems lack the ethical safeguards, contextual awareness (e.g., holidays), and auditability required to ensure responsible, transparent, and culturally sensitive monitoring.

## Features Of INGABO PROJECT
### Tables
- patients: Stores patient demographics and identifiers.
- visits: Logs each clinical visit with timestamps and clinician notes.
- behavioral_trends: Tracks mood, behavior scores, and observations over time.
- alerts: Captures system-generated warnings based on behavioral thresholds.
- holidays: Lists non-working days to prevent false alerts.
- audit_log: Records all trigger-based actions for transparency and review.
# LOGICAL MODEL DESIGN 

Here’s a clear explanation of the **Entity-Relationship Diagram (ERD)** for your **Behavioral Health Tracking System**, Ngabo. This breakdown reflects your schema design, ethical logic, and auditability goals:

---

## 🧠 ERD Explanation – Behavioral Health Tracking Project

### 🧩 Core Entities and Relationships

| Entity               | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `patients`           | Stores demographic and identifying information for each patient             |
| `visits`             | Logs each clinical visit with date, time, and clinician notes               |
| `behavioral_trends`  | Tracks behavior scores and observations over time per patient               |
| `alerts`             | Stores system-generated alerts when behavior crosses ethical thresholds     |
| `holidays`           | Lists non-working days to suppress alerts on culturally sensitive dates     |
| `audit_log`          | Records all automated actions triggered by the system for transparency      |

---

### 🔗 Key Relationships

- **`patients` → `visits`**:  
  - **One-to-Many**: A patient can have multiple visits.  
  - Linked via `patient_id`.

- **`visits` → `behavioral_trends`**:  
  - **One-to-One or One-to-Many**: Each visit may generate one or more behavioral entries.  
  - Linked via `visit_id`.

- **`behavioral_trends` → `alerts`**:  
  - **One-to-Zero-or-One**: A behavioral entry may trigger an alert if thresholds are crossed.  
  - Linked via `patient_id` and `trend_date`.

- **`alerts` → `audit_log`**:  
  - **One-to-One**: Every alert triggers an audit log entry.  
  - Linked via `alert_id` or timestamp.

- **`holidays`**:  
  - Standalone table used by triggers to suppress alerts on specific dates.  
  - Referenced during alert evaluation logic.

---

### 🛡️ Ethical & Functional Logic (Enforced via Triggers)

- **Trigger on `behavioral_trends` insert**:
  - Checks if score exceeds threshold.
  - Verifies current date is not in `holidays`.
  - Ensures no duplicate alert exists for the same patient/date.
  - If all conditions are met:
    - Inserts into `alerts`.
    - Inserts into `audit_log`.

---

### 🧬 Summary of Entity Attributes

| Table              | Key Attributes                                                                 |
|--------------------|--------------------------------------------------------------------------------|
| `patients`         | `patient_id` (PK), name, DOB, gender, contact_info                             |
| `visits`           | `visit_id` (PK), `patient_id` (FK), visit_date, clinician_notes                |
| `behavioral_trends`| `trend_id` (PK), `visit_id` (FK), `patient_id` (FK), score, notes, trend_date  |
| `alerts`           | `alert_id` (PK), `patient_id` (FK), alert_reason, alert_date                   |
| `holidays`         | `holiday_date` (PK), description                                               |
| `audit_log`        | `log_id` (PK), action_type, table_affected, timestamp, user_id, reason         |

## ERD
<img width="357" height="363" alt="ERD" src="https://github.com/user-attachments/assets/e7947ed8-36d5-41cd-a625-b518619adc6d" />

<img width="367" height="340" alt="ERD3" src="https://github.com/user-attachments/assets/3b5c1e57-c301-402e-9e17-6c1f73002743" />
# BPMN
<img width="1799" height="4615" alt="mermaid-ai-diagram-2025-12-08-222823" src="https://github.com/user-attachments/assets/798e787a-e861-47b0-a033-9f3159a8493b" />



