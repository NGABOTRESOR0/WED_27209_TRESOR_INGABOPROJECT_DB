CREATE OR REPLACE PROCEDURE analyze_behavioral_risks IS
  CURSOR obs_cursor IS
    SELECT patient_id, AVG(sleep_hours) AS avg_sleep
    FROM observations
    WHERE obs_date > SYSDATE - 30
    GROUP BY patient_id;

  v_exists NUMBER;
BEGIN
  FOR rec IN obs_cursor LOOP
    IF rec.avg_sleep < 4 THEN
      -- Check if a flag already exists for today
      SELECT COUNT(*) INTO v_exists
      FROM risk_flags
      WHERE patient_id = rec.patient_id
        AND risk_type = 'Sleep Deprivation'
        AND flag_date = TRUNC(SYSDATE);

      IF v_exists = 0 THEN
        INSERT INTO risk_flags (
          flag_id, patient_id, flag_date, risk_type, description
        ) VALUES (
          risk_flags_seq.NEXTVAL,
          rec.patient_id,
          SYSDATE,
          'Sleep Deprivation',
          'Average sleep over past 30 days is critically low.'
        );

        DBMS_OUTPUT.PUT_LINE('Inserted flag for patient ' || rec.patient_id);
      ELSE
        DBMS_OUTPUT.PUT_LINE('Flag already exists for patient ' || rec.patient_id);
      END IF;
    END IF;
  END LOOP;
END;





CREATE OR REPLACE PROCEDURE analyze_behavioral_risks IS
BEGIN
  FOR rec IN (
    SELECT patient_id,
           AVG(sleep_hours) AS avg_sleep
    FROM observations
    WHERE obs_date > SYSDATE - 30
    GROUP BY patient_id
  ) LOOP
    IF rec.avg_sleep < 4 THEN
      INSERT INTO risk_flags (
        flag_id,
        patient_id,
        flag_date,
        risk_type,
        description
      ) VALUES (
        risk_flags_seq.NEXTVAL,
        rec.patient_id,
        SYSDATE,
        'Sleep Deprivation',
        'Average sleep over past 30 days is critically low.'
      );
    END IF;
  END LOOP;
END;
