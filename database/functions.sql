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
