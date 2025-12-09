CREATE OR REPLACE PACKAGE BODY behavioral_risk_pkg IS

  FUNCTION calculate_average_mood(p_patient_id NUMBER)
  RETURN NUMBER IS
    v_avg_mood NUMBER;
  BEGIN
    SELECT AVG(mood_level)
    INTO v_avg_mood
    FROM observations
    WHERE patient_id = p_patient_id
      AND obs_date > SYSDATE - 30;

    RETURN v_avg_mood;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  PROCEDURE analyze_behavioral_risks IS
    CURSOR obs_cursor IS
      SELECT patient_id, AVG(sleep_hours) AS avg_sleep
      FROM observations
      WHERE obs_date > SYSDATE - 30
      GROUP BY patient_id;

    v_exists NUMBER;
  BEGIN
    FOR rec IN obs_cursor LOOP
      IF rec.avg_sleep < 4 THEN
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

          DBMS_OUTPUT.PUT_LINE('Inserted sleep flag for patient ' || rec.patient_id);
        ELSE
          DBMS_OUTPUT.PUT_LINE('Sleep flag already exists for patient ' || rec.patient_id);
        END IF;
      END IF;
    END LOOP;
  END;

  PROCEDURE analyze_mood_risks IS
    CURSOR mood_cursor IS
      SELECT DISTINCT patient_id FROM observations;

    v_avg_mood NUMBER;
    v_exists   NUMBER;
  BEGIN
    FOR rec IN mood_cursor LOOP
      v_avg_mood := calculate_average_mood(rec.patient_id);

      IF v_avg_mood IS NOT NULL AND v_avg_mood < 2.5 THEN
        SELECT COUNT(*) INTO v_exists
        FROM risk_flags
        WHERE patient_id = rec.patient_id
          AND risk_type = 'Mood Instability'
          AND flag_date = TRUNC(SYSDATE);

        IF v_exists = 0 THEN
          INSERT INTO risk_flags (
            flag_id, patient_id, flag_date, risk_type, description
          ) VALUES (
            risk_flags_seq.NEXTVAL,
            rec.patient_id,
            SYSDATE,
            'Mood Instability',
            'Average mood over past 30 days is critically low.'
          );

          DBMS_OUTPUT.PUT_LINE('Inserted mood flag for patient ' || rec.patient_id);
        ELSE
          DBMS_OUTPUT.PUT_LINE('Mood flag already exists for patient ' || rec.patient_id);
        END IF;
      END IF;
    END LOOP;
  END;

END behavioral_risk_pkg;/


CREATE OR REPLACE PACKAGE behavioral_risk_pkg IS
  FUNCTION calculate_average_mood(p_patient_id NUMBER) RETURN NUMBER;
  PROCEDURE analyze_behavioral_risks;
  PROCEDURE analyze_mood_risks;
END behavioral_risk_pkg;/

