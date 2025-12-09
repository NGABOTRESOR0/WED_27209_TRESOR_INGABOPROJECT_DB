CREATE OR REPLACE TRIGGER trg_restrict_insert_behavioral
BEFORE INSERT ON behavioral_trends
FOR EACH ROW
DECLARE
  v_day_num NUMBER;
  v_holiday_count NUMBER;

  PROCEDURE log_blocked IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO audit_log (
      username, operation, table_name, action_time, status, reason
    ) VALUES (
      USER, 'INSERT', 'BEHAVIORAL_TRENDS', SYSDATE, 'BLOCKED', 'Attempted behavioral trend insert on restricted day'
    );
    COMMIT;
  END;
BEGIN
  v_day_num := TO_NUMBER(TO_CHAR(SYSDATE, 'D'));
  SELECT COUNT(*) INTO v_holiday_count
  FROM holidays
  WHERE holiday_date = TRUNC(SYSDATE);

  IF v_day_num IN (1, 7) OR v_holiday_count > 0 THEN
    log_blocked;
    RAISE_APPLICATION_ERROR(-20005, 'Behavioral trend entry is not allowed on weekends or holidays.');
  END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_restrict_insert_visits
BEFORE INSERT ON visits
FOR EACH ROW
DECLARE
  v_day_num NUMBER;
  v_holiday_count NUMBER;

  PROCEDURE log_blocked IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO audit_log (
      username, operation, table_name, action_time, status, reason
    ) VALUES (
      USER, 'INSERT', 'VISITS', SYSDATE, 'BLOCKED', 'Attempted visit insert on restricted day'
    );
    COMMIT;
  END;
BEGIN
  v_day_num := TO_NUMBER(TO_CHAR(SYSDATE, 'D'));
  SELECT COUNT(*) INTO v_holiday_count
  FROM holidays
  WHERE holiday_date = TRUNC(SYSDATE);

  IF v_day_num IN (1, 7) OR v_holiday_count > 0 THEN
    log_blocked;
    RAISE_APPLICATION_ERROR(-20004, 'Visit entry is not allowed on weekends or holidays.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_auto_alert_from_trends
AFTER INSERT ON behavioral_trends
FOR EACH ROW
WHEN (NEW.trend_score > 85)
BEGIN
  INSERT INTO alerts (
    patient_id, risk_level, message, created_at
  ) VALUES (
    :NEW.patient_id, 'High', 'Automated alert: High trend score detected', SYSTIMESTAMP
  );

  INSERT INTO audit_log (
    username, operation, table_name, action_time, status, reason
  ) VALUES (
    USER, 'INSERT', 'ALERTS', SYSTIMESTAMP, 'SUCCESS', 'Auto-alert triggered by trend score'
  );
END;


CREATE OR REPLACE TRIGGER trg_block_weekends_holidays
BEFORE INSERT ON visits
FOR EACH ROW
DECLARE
  v_day VARCHAR2(10);
  v_count NUMBER;
BEGIN
  v_day := TO_CHAR(:NEW.visit_date, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');
  IF v_day IN ('SAT', 'SUN') THEN
    RAISE_APPLICATION_ERROR(-20001, 'Visits cannot be scheduled on weekends.');
  END IF;

  SELECT COUNT(*) INTO v_count
  FROM holidays
  WHERE holiday_date = TRUNC(:NEW.visit_date);

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Visits cannot be scheduled on holidays.');
  END IF;
END;





