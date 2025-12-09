CREATE OR REPLACE FUNCTION check_restriction RETURN VARCHAR2 IS
  v_today DATE := TRUNC(SYSDATE);
  v_day VARCHAR2(10);
  v_count NUMBER;
BEGIN
  v_day := TO_CHAR(v_today, 'DY', 'NLS_DATE_LANGUAGE=EN');

  -- Deny on weekends
  IF v_day IN ('SAT', 'SUN') THEN
    RETURN 'WEEKEND';
  END IF;

  -- Deny on holidays
  SELECT COUNT(*) INTO v_count FROM holidays WHERE holiday_date = v_today;
  IF v_count > 0 THEN
    RETURN 'HOLIDAY';
  END IF;

  RETURN 'ALLOWED';
END;
/

CREATE OR REPLACE FUNCTION check_restriction RETURN VARCHAR2 IS
  v_today DATE := TRUNC(SYSDATE);
  v_day VARCHAR2(10);
  v_count NUMBER;
BEGIN
  v_day := TO_CHAR(v_today, 'DY', 'NLS_DATE_LANGUAGE=EN');

  IF v_day IN ('SAT', 'SUN') THEN
    RETURN 'WEEKEND';
  END IF;

  SELECT COUNT(*) INTO v_count FROM holidays WHERE holiday_date = v_today;
  IF v_count > 0 THEN
    RETURN 'HOLIDAY';
  END IF;

  RETURN 'ALLOWED';
END;
/
CREATE OR REPLACE PROCEDURE insert_visit (
  p_patient_id     IN visits.patient_id%TYPE,
  p_visit_date     IN visits.visit_date%TYPE,
  p_symptoms       IN visits.symptoms%TYPE,
  p_mood           IN visits.mood%TYPE,
  p_behavior_notes IN visits.behavior_notes%TYPE
) AS
BEGIN
  INSERT INTO visits (patient_id, visit_date, symptoms, mood, behavior_notes)
  VALUES (p_patient_id, p_visit_date, p_symptoms, p_mood, p_behavior_notes);
END;
/
