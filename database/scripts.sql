
CREATE TABLE patients (
  patient_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR2(100),
  age NUMBER,
  gender VARCHAR2(10),
  contact_info VARCHAR2(150)
);

CREATE TABLE visits (
  visit_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  patient_id NUMBER NOT NULL,
  visit_date DATE,
  symptoms VARCHAR2(500),
  mood VARCHAR2(50),
  behavior_notes VARCHAR2(1000),
  CONSTRAINT fk_visits_patient FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id)
);

CREATE TABLE behavioral_trends (
  trend_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  patient_id NUMBER NOT NULL,
  trend_type VARCHAR2(100),
  trend_score NUMBER,
  last_updated TIMESTAMP,
  CONSTRAINT fk_trends_patient FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id)
);

CREATE TABLE alerts (
  alert_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  patient_id NUMBER NOT NULL,
  risk_level VARCHAR2(20),
  message VARCHAR2(500),
  created_at TIMESTAMP,
  CONSTRAINT fk_alerts_patient FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id)
);

CREATE TABLE holidays (
  holiday_date DATE PRIMARY KEY,
  description VARCHAR2(100)
);


CREATE TABLE audit_log (
  log_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  username VARCHAR2(100),
  operation VARCHAR2(20),
  table_name VARCHAR2(50),
  action_time TIMESTAMP,
  status VARCHAR2(20),
  reason VARCHAR2(1000)
);
