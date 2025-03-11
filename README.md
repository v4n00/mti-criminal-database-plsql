<h1 align="center">PLSQL Statements for a Criminal Record Database</h1>
<h4 align="center"><i>Individual project for my Database Management Systems Class</i></h2>

# Description
This repo is an extension of my [previous project's database](https://github.com/v4n00/mti-criminal-database) where I implement PLSQL statements in order to make it easier to use and more accessible.

# Examples of statements used:

## Functions & Procedures
```SQL
-- Procedure: return total incarceration time of a criminal
CREATE OR REPLACE PROCEDURE p_get_total_incarceration_time(p_criminal_id IN NUMBER, p_total_incarceration_time IN OUT NUMBER) IS
    CURSOR c_captivity_history_record IS
        SELECT DATE_INCARCERATED, DATE_FREED, CAPTIVITY_ID
        FROM P_CAPTIVITY_HISTORY;
    c_captivity_history c_captivity_history_record%rowtype;
    v_captivity_id NUMBER;
BEGIN
    SELECT CAPTIVITY_HISTORY_ID INTO v_captivity_id FROM P_CRIMINALS WHERE CRIMINAL_ID = p_criminal_id;
    OPEN c_captivity_history_record;
    LOOP
        FETCH c_captivity_history_record INTO c_captivity_history;
        EXIT WHEN c_captivity_history_record%NOTFOUND;
        IF c_captivity_history.CAPTIVITY_ID = v_captivity_id THEN
            p_total_incarceration_time := p_total_incarceration_time + TO_NUMBER(MONTHS_BETWEEN(c_captivity_history.DATE_FREED, c_captivity_history.DATE_INCARCERATED));
        END IF;
    END LOOP;
    CLOSE c_captivity_history_record;
END;
/
DECLARE
    v_total_incarceration_time NUMBER := 0;
BEGIN
    p_get_total_incarceration_time(1, v_total_incarceration_time);
    DBMS_OUTPUT.PUT_LINE('Total incarceration time: ' || ROUND(v_total_incarceration_time, 2) || ' months');
END;
/
```

## Triggers
```SQL
-- Trigger: count the salary difference when its updated
CREATE OR REPLACE TRIGGER t_salary_difference
    BEFORE UPDATE OF salary ON p_salary
    FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Old salary: ' || :OLD.salary); 
    DBMS_OUTPUT.PUT_LINE('New salary: ' || :NEW.salary); 
    IF :OLD.salary > :NEW.salary THEN
        DBMS_OUTPUT.PUT_LINE('Salary decreased by ' || (:OLD.salary - :NEW.salary));
    ELSIF :OLD.salary < :NEW.salary THEN
        DBMS_OUTPUT.PUT_LINE('Salary increased by ' || (:NEW.salary - :OLD.salary));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Salary is the same');
    END IF;
END;
/
BEGIN
    UPDATE p_salary SET salary = 100000 WHERE officer_info_id = 1;
END;
/
```

## Cursors
```SQL
-- Display the list of crimes that happened in the JC sector with an explicit cursor
DECLARE
    CURSOR c_crimes_record (region_code VARCHAR2) IS
        SELECT *
        FROM p_crime_history
        WHERE region = region_code;
    c_crimes c_crimes_record%rowtype;
BEGIN
    OPEN c_crimes_record('JC');
    LOOP
        FETCH c_crimes_record INTO c_crimes;
        EXIT WHEN c_crimes_record%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Crime id: ' || c_crimes.CRIMINAL_ID || ' | Crime date: ' || c_crimes.CRIME_DATE || ' | Offense: ' || c_crimes.OFFENSE);
    END LOOP;
    CLOSE c_crimes_record;
END;
/
```

# Database schema
The database comprises of several tables shown in the following image:

   <img src="https://github.com/v4n00/mti-criminal-database/blob/master/project%20files/database%20schema.png?raw=true" alt="Database schema" />