This data dictionary defines the structure, constraints, and purpose of each table in the Behavioral Health Tracker system designed to monitor patient visits, behavioral trends, alerts, and ethical compliance.

👤 Table: PATIENTS

Column

Type

Constraints

Purpose

patient_id

NUMBER

PK, GENERATED ALWAYS AS IDENTITY, NOT NULL

Unique patient identifier

full_name

VARCHAR2(100)

NOT NULL

Patient's full name

date_of_birth

DATE

NOT NULL

Date of birth

gender

VARCHAR2(10)

CHECK ('Male','Female','Other')

Gender

contact_info

VARCHAR2(100)



Phone or email

🗓️ Table: VISITS

Column

Type

Constraints

Purpose

visit_id

NUMBER

PK, GENERATED ALWAYS AS IDENTITY, NOT NULL

Unique visit identifier

patient_id

NUMBER

FK → PATIENTS(patient_id), NOT NULL

Associated patient

visit_date

DATE

NOT NULL

Date of the visit

mood_score

NUMBER(3)

CHECK (mood_score BETWEEN 0 AND 100)

Mood rating

notes

VARCHAR2(500)



Clinician notes

📈 Table: BEHAVIORAL_TRENDS

Column

Type

Constraints

Purpose

trend_id

NUMBER

PK, GENERATED ALWAYS AS IDENTITY, NOT NULL

Unique trend identifier

patient_id

NUMBER

FK → PATIENTS(patient_id), NOT NULL

Associated patient

trend_type

VARCHAR2(50)

NOT NULL

Type of trend (e.g., Mood, Risk)

trend_score

NUMBER(3)

CHECK (trend_score BETWEEN 0 AND 100)

Trend severity score

last_updated

DATE

DEFAULT SYSDATE

Timestamp of last update

🚨 Table: ALERTS

Column

Type

Constraints

Purpose

alert_id

NUMBER

PK, GENERATED ALWAYS AS IDENTITY, NOT NULL

Unique alert identifier

patient_id

NUMBER

FK → PATIENTS(patient_id), NOT NULL

Associated patient

risk_level

VARCHAR2(20)

CHECK ('Low','Moderate','High')

Severity of the alert

message

VARCHAR2(200)

NOT NULL

Alert message

created_at

TIMESTAMP

DEFAULT SYSTIMESTAMP

Alert creation time

📅 Table: HOLIDAYS

Column

Type

Constraints

Purpose

holiday_id

NUMBER

PK, GENERATED ALWAYS AS IDENTITY, NOT NULL

Unique holiday identifier

holiday_date

DATE

NOT NULL, UNIQUE

Date of the holiday

holiday_name

VARCHAR2(100)

NOT NULL

Name of the holiday

🧾 Table: AUDIT_LOG

Column

Type

Constraints

Purpose

log_id

NUMBER

PK, GENERATED ALWAYS AS IDENTITY, NOT NULL

Unique log identifier

username

VARCHAR2(100)

DEFAULT USER

User who performed the action

operation

VARCHAR2(10)

CHECK ('INSERT','UPDATE','DELETE')

Type of DML operation

table_name

VARCHAR2(50)

NOT NULL

Table affected

action_time

TIMESTAMP

DEFAULT SYSTIMESTAMP

Time of the action

status

VARCHAR2(10)

CHECK ('SUCCESS','FAILURE')

Outcome of the operation

reason

VARCHAR2(200)



Explanation or error message

🔗 Table Relationships Summary

PATIENTS → VISITS (One-to-Many)

PATIENTS → BEHAVIORAL_TRENDS (One-to-Many)

PATIENTS → ALERTS (One-to-Many)

VISITS → AUDIT_LOG (Logged indirectly via triggers)

BEHAVIORAL_TRENDS → ALERTS (Trigger-based logic)

This data dictionary supports ethical, auditable, and clinically meaningful tracking of behavioral health data in a secure Oracle-based syste
