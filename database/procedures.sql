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
