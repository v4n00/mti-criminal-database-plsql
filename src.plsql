-- A. Creating the tables/inserting the data

-- Deleting the tables
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE p_captivity_history CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE p_crime_history CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE p_criminals CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE p_involved_officers CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE p_involved_victims CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE p_officer_info CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE p_victim_info CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE p_salary CASCADE CONSTRAINTS';
END;
/

-- Creating the tables
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE p_criminals
    (
    cnp NUMBER(13),
    criminal_id NUMBER(6) CONSTRAINT c_pk PRIMARY KEY,
    captivity_history_id NUMBER(6) UNIQUE,
    first_name VARCHAR2(30),
    last_name VARCHAR2(30),
    age NUMBER(2),
    gender CHAR(1),
    address VARCHAR2(40),
    remarks VARCHAR2(1000)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE p_crime_history
    (
    crime_id NUMBER(6) CONSTRAINT ch_pk PRIMARY KEY,
    criminal_id NUMBER(6) CONSTRAINT ch_fk REFERENCES p_criminals(criminal_id),
    officer_id NUMBER(6) UNIQUE,
    victim_id NUMBER(6) UNIQUE,
    crime_date DATE,
    offense VARCHAR2(100),
    address VARCHAR2(40),
    region CHAR(2)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE p_captivity_history
    (
    cell NUMBER(1),
    date_incarcerated DATE,
    date_freed DATE,
    captivity_id NUMBER(6) CONSTRAINT caph_fk REFERENCES p_criminals(captivity_history_id),
    CONSTRAINT caph_pk PRIMARY KEY (cell,date_incarcerated)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE p_officer_info
    (
    officer_info_id NUMBER(6) CONSTRAINT oi_pk PRIMARY KEY,
    first_name VARCHAR2(30),
    last_name VARCHAR2(30),
    rank VARCHAR2(20),
    chief_id NUMBER(6),
    age NUMBER(2),
    CONSTRAINT chief_fk FOREIGN KEY (CHIEF_ID) REFERENCES P_OFFICER_INFO (OFFICER_INFO_ID)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE p_involved_officers
    (
    officer_id NUMBER(6),
    officer_info_id NUMBER(6),
    date_assigned DATE,
    CONSTRAINT io_pk PRIMARY KEY (officer_id, officer_info_id),
    CONSTRAINT io_fk1 FOREIGN KEY (officer_id) REFERENCES p_crime_history (officer_id),
    CONSTRAINT io_fk2 FOREIGN KEY (officer_info_id) REFERENCES p_officer_info (officer_info_id)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE p_victim_info
    (
    victim_info_id NUMBER(6) CONSTRAINT vi_pk PRIMARY KEY,
    first_name VARCHAR2(30),
    last_name VARCHAR2(30),
    age NUMBER(2),
    gender CHAR(1),
    address VARCHAR2(40)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE p_involved_victims
    (
    victim_id NUMBER(6),
    victim_info_id NUMBER(6),
    has_insurance CHAR(1),
    CONSTRAINT iv_pk PRIMARY KEY (victim_id, victim_info_id),
    CONSTRAINT iv_fk1 FOREIGN KEY (victim_id) REFERENCES p_crime_history (victim_id),
    CONSTRAINT iv_fk2 FOREIGN KEY (victim_info_id) REFERENCES p_victim_info (victim_info_id)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE p_salary
    (
    officer_info_id NUMBER(6) CONSTRAINT sal_fk REFERENCES p_officer_info(officer_info_id),
    salary NUMBER(6) DEFAULT 9000,
    bonus NUMBER(6),
    CONSTRAINT sal_uni UNIQUE (officer_info_id)
    )';
END;
/

-- Inserting the data
BEGIN
    -- p_criminals
    EXECUTE IMMEDIATE 'INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (6073683838378, 1, 1, ''Patchouli'', ''Knowledge'', 20, ''m'', ''Str Greensage 63'', null)'; 
    EXECUTE IMMEDIATE 'INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (6038536829398, 2, 2, ''Flandre'', ''Scarlet'', 21, ''f'', ''Str Ogoal 7'', null)';
    EXECUTE IMMEDIATE 'INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (6094536537363, 3, 3, ''Remilia'', ''Scarlet'', 24, ''f'', ''Str Ogoal 7'', ''under house arrest'')'; 
    EXECUTE IMMEDIATE 'INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (5039579378368, 4, 4, ''Jak'', ''Mar'', 37, ''m'', ''Str Klaw 15'', ''psychiatric problems'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (5085547536482, 5, 5, ''Karlsefni'', ''Thorfinn'', 25, ''m'', ''Str Igubun 37'', ''in hospital'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (6072686799263, 6, 6, ''Marisa'', ''Kirisame'', 20, ''f'', ''Str Librariei 7'', null)'; 
    -- p_crime_history
    EXECUTE IMMEDIATE 'INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (1, 1, 1, 1, TO_DATE(''21-05-2022'',''DD-MM-RRRR''), ''theft'', ''Str Gensokyo 223'', ''IC'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (2, 1, 2, 2, TO_DATE(''17-09-2021'',''DD-MM-RRRR''), ''assault'', ''Str Daxter 19'', ''IC'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (3, 1, 3, 3, TO_DATE(''05-03-2021'',''DD-MM-RRRR''), ''disorderly conduct'', ''Str Gol 44'', ''IC'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (4, 2, 4, 4, TO_DATE(''29-01-2020'',''DD-MM-RRRR''), ''littering'', ''Str Maya 98'', ''BR'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (5, 3, 5, 5, TO_DATE(''02-03-2022'',''DD-MM-RRRR''), ''traffic offense'', ''Str Sunken 42'', ''YU'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (6, 3, 6, 6, TO_DATE(''09-05-2022'',''DD-MM-RRRR''), ''traffic offense'', ''Str Precursor 26'', ''YU'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (7, 4, 7, 7, TO_DATE(''30-12-2021'',''DD-MM-RRRR''), ''hunting without a license'', ''Str Bullet 4'', ''TC'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (8, 5, 8, 8, TO_DATE(''08-05-2020'',''DD-MM-RRRR''), ''excessive noise'', ''Str Sumap 172'', ''HL'')';
    -- p_captivity_history
    EXECUTE IMMEDIATE 'INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (1, TO_DATE(''05-03-2021'', ''DD-MM-RRRR''), TO_DATE(''22-03-2022'', ''DD-MM-RRRR''), 1)';
    EXECUTE IMMEDIATE 'INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (1, TO_DATE(''17-09-2021'', ''DD-MM-RRRR''), TO_DATE(''17-10-2022'', ''DD-MM-RRRR''), 1)';
    EXECUTE IMMEDIATE 'INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (3, TO_DATE(''02-03-2022'', ''DD-MM-RRRR''), TO_DATE(''03-03-2022'', ''DD-MM-RRRR''), 3)';
    EXECUTE IMMEDIATE 'INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (2, TO_DATE(''09-05-2022'', ''DD-MM-RRRR''), TO_DATE(''10-05-2022'', ''DD-MM-RRRR''), 3)';
    EXECUTE IMMEDIATE 'INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (2, TO_DATE(''30-12-2021'', ''DD-MM-RRRR''), TO_DATE(''30-01-2022'', ''DD-MM-RRRR''), 4)';
    EXECUTE IMMEDIATE 'INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (1, TO_DATE(''08-05-2020'', ''DD-MM-RRRR''), TO_DATE(''15-05-2020'', ''DD-MM-RRRR''), 5)';
    -- p_officer_info
    EXECUTE IMMEDIATE 'INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (1, ''Hecatia'', ''Lapislazuli'', ''captain'', null, 28)';
    EXECUTE IMMEDIATE 'INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (2, ''Keiki'', ''Haniyasushin'', ''corporal'', 1, 25)';
    EXECUTE IMMEDIATE 'INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (3, ''Koishi'', ''Komeiji'', ''corporal'', 1, 31)';
    EXECUTE IMMEDIATE 'INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (4, ''Alice'', ''Margatroid'', ''officer'', 3, 26)';
    EXECUTE IMMEDIATE 'INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (5, ''Hong'', ''Meiling'', ''officer'', 2, 29)';
    EXECUTE IMMEDIATE 'INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (6, ''Minamitsu'', ''Murasa'', ''officer'', 3, 31)';
    EXECUTE IMMEDIATE 'INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (7, ''Nitori'', ''Kwashiro'', ''officer'', 3, 26)';
    -- p_involved_officers
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (1, 3, TO_DATE(''21-05-2022'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (2, 1, TO_DATE(''17-09-2021'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (2, 2, TO_DATE(''18-09-2021'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (3, 4, TO_DATE(''06-03-2021'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (4, 5, TO_DATE(''29-01-2020'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (5, 4, TO_DATE(''02-03-2022'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (5, 5, TO_DATE(''04-03-2022'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (6, 7, TO_DATE(''09-05-2022'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (7, 2, TO_DATE(''30-12-2021'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (7, 7, TO_DATE(''03-01-2022'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (7, 4, TO_DATE(''04-01-2022'',''DD-MM-RRRR''))';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (8, 7, TO_DATE(''08-05-2020'',''DD-MM-RRRR''))';
    -- p_victim_info
    EXECUTE IMMEDIATE 'INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (1, ''Ran'', ''Yakumo'', 28, ''f'', ''Str Nue 19'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (2, ''Reisen'', ''Udonge'', 47, ''f'', ''Str Ringo 38'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (3, ''Satori'', ''Komeiji'', 30, ''f'', ''Str Seiran 144'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (4, ''Saimos'', ''Sage'', 25, ''m'', ''Str Sandover 89'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (5, ''Tenshi'', ''Hinanai'', 45, ''f'', ''Str Urumi 121'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (6, ''Tewi'', ''Inaba'', 62, ''f'', ''Str Forma 60'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (7, ''Yuyuko'', ''Saigyouji'', 52, ''f'', ''Str Lob 108'')';
    -- p_involved_victims
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (1, 3, ''y'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (1, 4, ''n'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (1, 2, ''n'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (2, 1, ''y'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (2, 7, ''n'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (3, 5, ''n'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (5, 7, ''y'')';
    EXECUTE IMMEDIATE 'INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (8, 6, ''y'')';
    -- p_salary
    EXECUTE IMMEDIATE 'INSERT INTO p_salary(officer_info_id, salary, bonus) VALUES (1, 12000, 0)';
    EXECUTE IMMEDIATE 'INSERT INTO p_salary(officer_info_id, salary, bonus) VALUES (3, 11000, 0)';
    EXECUTE IMMEDIATE 'INSERT INTO p_salary(officer_info_id, salary, bonus) VALUES (7, 11450, 0)';
END;
/

-- B. Classic SQL Queries

-- Correct the IC region typo to JC
BEGIN
    EXECUTE IMMEDIATE 'UPDATE p_crime_history SET region = ''JC'' WHERE region = ''IC''';
    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || sql%rowcount);
END;
/

-- Delete officers that dont have any cases
BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM p_officer_info WHERE officer_info_id NOT IN (SELECT officer_info_id FROM p_involved_officers)';
    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || sql%rowcount);
END;
/

-- Add the deleted officer back
BEGIN
    EXECUTE IMMEDIATE 'INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (6, ''Minamitsu'', ''Murasa'', ''officer'', 3, 31)';
    DBMS_OUTPUT.PUT_LINE('Rows added: ' || sql%rowcount);
END;
/

-- Update salaries
BEGIN
    EXECUTE IMMEDIATE 'MERGE INTO p_salary s
    USING (SELECT officer_info_id, COUNT(officer_info_id) AS no_cases FROM p_involved_officers GROUP BY officer_info_id ORDER BY officer_info_id) w
    ON (s.officer_info_id = w.officer_info_id)
    WHEN MATCHED THEN
    UPDATE SET s.bonus = s.bonus + (w.no_cases) * 100, s.salary = s.salary + (w.no_cases) * 100
    WHEN NOT MATCHED THEN
    INSERT (s.officer_info_id, salary, bonus)
    VALUES (w.officer_info_id, 9000 + w.no_cases * 100, w.no_cases * 100)';
END;
/

-- C. Alternative and repetitive structures

-- Display if a victim has or not insurance (input: 3)
DECLARE
    v_has_insurance P_INVOLVED_VICTIMS.HAS_INSURANCE%TYPE;
BEGIN
    SELECT HAS_INSURANCE INTO v_has_insurance FROM P_INVOLVED_VICTIMS WHERE VICTIM_INFO_ID = &victim_info_id;
    IF v_has_insurance = 'y' THEN
        DBMS_OUTPUT.PUT_LINE('Victim has insurance');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Victim does not have insurance');
    END IF;
END;
/

-- Display whether an officer's salary is above, below or the same as the average salary (input: 2)
DECLARE
    v_officer_salary P_SALARY.SALARY%TYPE;
    v_salary_average P_SALARY.SALARY%TYPE;
BEGIN
    SELECT AVG(salary) INTO v_salary_average FROM P_SALARY;
    SELECT SALARY INTO v_officer_salary FROM P_SALARY WHERE OFFICER_INFO_ID = &officer_info_id;
    CASE
    WHEN v_officer_salary < v_salary_average THEN
        DBMS_OUTPUT.PUT_LINE('Officer salary (' || v_officer_salary || ') is below average (' || v_salary_average || ')');
    WHEN v_officer_salary > v_salary_average THEN
        DBMS_OUTPUT.PUT_LINE('Officer salary (' || v_officer_salary || ') is above average (' || v_salary_average || ')');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Officer salary (' || v_officer_salary || ') is the same as the average (' || v_salary_average || ')');
    END CASE;
END;
/

-- Display the victims with ids between 1 and 7 in order as long as their age is lower than the average with a for loop
DECLARE
    v_age_average P_CRIMINALS.AGE%TYPE;
    v_criminal_id P_CRIMINALS.CRIMINAL_ID%TYPE;
    v_criminal_first_name P_CRIMINALS.FIRST_NAME%TYPE;
    v_criminal_last_name P_CRIMINALS.LAST_NAME%TYPE;
    v_criminal_age P_CRIMINALS.AGE%TYPE;
BEGIN
    SELECT AVG(age) INTO v_age_average FROM P_CRIMINALS;
    DBMS_OUTPUT.PUT_LINE('Average age: ' || v_age_average);
    FOR i IN 1..7 LOOP
        SELECT CRIMINAL_ID, FIRST_NAME, LAST_NAME, AGE INTO v_criminal_id, v_criminal_first_name, v_criminal_last_name, v_criminal_age FROM P_CRIMINALS WHERE CRIMINAL_ID = i;
        EXIT WHEN v_criminal_age > v_age_average;
        DBMS_OUTPUT.PUT_LINE('Criminal id: ' || v_criminal_id || ' | Name: ' || v_criminal_first_name || ' ' || v_criminal_last_name || ' | Age: ' || v_criminal_age);
    END LOOP;
END;
/

-- Display the criminals with ids between 1 and 4 in order as long as their age is lower than the average with a while loop
DECLARE
    v_age_average P_VICTIM_INFO.AGE%TYPE;
    v_victim_id P_VICTIM_INFO.VICTIM_INFO_ID%TYPE;
    v_victim_first_name P_VICTIM_INFO.FIRST_NAME%TYPE;
    v_victim_last_name P_VICTIM_INFO.LAST_NAME%TYPE;
    v_victim_age P_VICTIM_INFO.AGE%TYPE;
    i NUMBER := 1;
BEGIN
    SELECT AVG(age) INTO v_age_average FROM P_VICTIM_INFO;
    DBMS_OUTPUT.PUT_LINE('Average age: ' || v_age_average);
    WHILE i <= 4 LOOP
        SELECT VICTIM_INFO_ID, FIRST_NAME, LAST_NAME, AGE INTO v_victim_id, v_victim_first_name, v_victim_last_name, v_victim_age FROM P_VICTIM_INFO WHERE VICTIM_INFO_ID = i;
        EXIT WHEN v_victim_age > v_age_average;
        DBMS_OUTPUT.PUT_LINE('Victim id: ' || v_victim_id || ' | Name: ' || v_victim_first_name || ' ' || v_victim_last_name || ' | Age: ' || v_victim_age);
        i := i + 1;
    END LOOP;
END;
/

-- D. Collections

-- Display all the police department force ids except the lowest ranks (officers) using indexed tables
DECLARE
    type num_table is table of p_officer_info.officer_info_id%type index by pls_integer;
    v_tab num_table;
    v_index pls_integer := 1;
BEGIN
    FOR i IN (SELECT officer_info_id FROM p_officer_info WHERE rank != 'officer') LOOP
        v_tab(v_index) := i.officer_info_id;
        v_index := v_index + 1;
    END LOOP;
    FOR i IN 1..v_tab.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Officer id: ' || v_tab(i));
    END LOOP;
END;
/

-- Add all the criminals name to a nested table and display them    
DECLARE
    CURSOR c_criminals IS
        SELECT FIRST_NAME
        FROM p_criminals;
    TYPE t_criminal_name_type IS TABLE OF P_CRIMINALS.FIRST_NAME%TYPE;
    v_criminal_name t_criminal_name_type := t_criminal_name_type();
BEGIN
    FOR i IN c_criminals LOOP
        v_criminal_name.EXTEND;
        v_criminal_name(v_criminal_name.COUNT) := i.first_name;
    END LOOP;
    FOR i IN v_criminal_name.FIRST..v_criminal_name.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Criminal name: ' || v_criminal_name(i));
    END LOOP;
END;
/

-- Add all the officers name to a variable array and display them
DECLARE
    CURSOR c_officers IS
        SELECT FIRST_NAME
        FROM p_officer_info;
    TYPE t_officer_name_type IS VARRAY(10) OF P_OFFICER_INFO.FIRST_NAME%TYPE;
    v_officer_name t_officer_name_type := t_officer_name_type();
    v_index NUMBER := 1;
BEGIN
    FOR i IN c_officers LOOP
        v_officer_name.extend();
        v_officer_name(v_index) := i.first_name;
        v_index := v_index + 1;
    END LOOP;
    FOR i IN v_officer_name.FIRST..v_officer_name.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Officer name: ' || v_officer_name(i));
    END LOOP;
END;
/

-- E. Exceptions (3 implicit, 2 explicit)

-- Display the criminal with id 10 and if it does not exist, treat the exception
DECLARE
    v_criminal_id P_CRIMINALS.CRIMINAL_ID%TYPE := 10;
    v_criminal_first_name P_CRIMINALS.FIRST_NAME%TYPE;
    v_criminal_last_name P_CRIMINALS.LAST_NAME%TYPE;
    v_criminal_age P_CRIMINALS.AGE%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME, AGE INTO v_criminal_first_name, v_criminal_last_name, v_criminal_age FROM P_CRIMINALS WHERE CRIMINAL_ID = v_criminal_id;
    DBMS_OUTPUT.PUT_LINE('Criminal id: ' || v_criminal_id || ' | Name: ' || v_criminal_first_name || ' ' || v_criminal_last_name || ' | Age: ' || v_criminal_age);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The criminal with id ' || v_criminal_id || ' was not found.');
END;
/

-- Display the crimes of criminal with id 2 and if it returns too many rows, treat the exception
DECLARE
    v_criminal_id P_CRIMINALS.CRIMINAL_ID%TYPE := 1;
    v_crime_id P_CRIME_HISTORY.CRIME_ID%TYPE;
    v_crime_date P_CRIME_HISTORY.CRIME_DATE%TYPE;
BEGIN
    SELECT CRIME_ID, CRIME_DATE INTO v_crime_id, v_crime_date FROM P_CRIME_HISTORY WHERE CRIMINAL_ID = v_criminal_id;
    DBMS_OUTPUT.PUT_LINE('Criminal id: ' || v_criminal_id || ' | Crime id: ' || v_crime_id || ' | Crime date: ' || v_crime_date);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('The criminal with id ' || v_criminal_id || ' has too many crimes.');
END;
/

-- Try to insert a new record into the table p_crime_history and if the exception is raised, display the error message
DECLARE
    INSERT_EXCEPT EXCEPTION;
    PRAGMA EXCEPTION_INIT(INSERT_EXCEPT, -00001);
BEGIN
    INSERT INTO p_crime_history (crime_id, offense, address, region) VALUES (1, 'theft', 'Str Gensokyo 223', 'IC');
EXCEPTION
    WHEN INSERT_EXCEPT THEN
        DBMS_OUTPUT.PUT_LINE('Not enough information has been provided.');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Try to update criminal with id 9, if they don't exist treat it with a custom exception
DECLARE
    v_criminal_id P_CRIMINALS.CRIMINAL_ID%TYPE := 9;
    v_criminal_first_name P_CRIMINALS.FIRST_NAME%TYPE := 'Aya';
    v_criminal_last_name P_CRIMINALS.LAST_NAME%TYPE := 'Shameimaru';
    v_criminal_age P_CRIMINALS.AGE%TYPE := 16;
    e_exc1 EXCEPTION;
BEGIN
    UPDATE P_CRIMINALS
    SET FIRST_NAME = v_criminal_first_name, LAST_NAME = v_criminal_last_name, AGE = v_criminal_age
    WHERE CRIMINAL_ID = v_criminal_id;
    IF SQL%NOTFOUND THEN
        RAISE e_exc1;
    END IF;
EXCEPTION
    WHEN e_exc1 THEN
        DBMS_OUTPUT.PUT_LINE('The criminal with id ' || v_criminal_id || ' was not found.');
END;
/

-- Try to add a new criminal, if the age is under 14 a custom exception will be thrown
DECLARE
    v_criminal_id P_CRIMINALS.CRIMINAL_ID%TYPE := 8;
    v_criminal_first_name P_CRIMINALS.FIRST_NAME%TYPE := 'Aya';
    v_criminal_last_name P_CRIMINALS.LAST_NAME%TYPE := 'Shameimaru';
    v_criminal_age P_CRIMINALS.AGE%TYPE := 13;
    e_exc2 EXCEPTION;
BEGIN
    IF v_criminal_age < 14 THEN
        RAISE e_exc2;
    END IF;
    INSERT INTO P_CRIMINALS (CRIMINAL_ID, FIRST_NAME, LAST_NAME, AGE) VALUES (v_criminal_id, v_criminal_first_name, v_criminal_last_name, v_criminal_age);
EXCEPTION
    WHEN e_exc2 THEN
        DBMS_OUTPUT.PUT_LINE('The criminal with id ' || v_criminal_id || ' is too young.');
END;
/

-- F. Cursors

-- Modify the region BR to HL, if the region is not found, display an error message
BEGIN
    UPDATE P_CRIME_HISTORY
    SET region = 'BR'
    WHERE region = 'HL';
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('The region BR was not found on any records.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The region IC was found on ' || SQL%ROWCOUNT || ' records.');
    END IF;
END;
/

-- Delete a salary for a given officer id, if the officer id is not found, display an error message (input: 2)
DECLARE
    v_officer_id P_SALARY.OFFICER_INFO_ID%TYPE := &officer_id;
BEGIN
    DELETE FROM P_SALARY
    WHERE OFFICER_INFO_ID = v_officer_id;
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('The criminal with id ' || v_officer_id || ' was not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The criminal with id ' || v_officer_id || ' was found and deleted.');
    END IF;
END;
/

-- Display how many rows the criminal with a given id has in the crime history table (input: 3)
DECLARE
    v_criminal_id P_CRIMINALS.CRIMINAL_ID%TYPE := &id;
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM P_CRIME_HISTORY WHERE CRIMINAL_ID = v_criminal_id;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The criminal with id ' || v_criminal_id || ' has ' || v_count || ' rows in the crime history table.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The criminal with id ' || v_criminal_id || ' was not found.');
    END IF;
END;
/

-- Display 3 of the oldest criminals with an explicit cursor
DECLARE
    CURSOR c_criminals IS
        SELECT *
        FROM p_criminals
        ORDER BY age DESC;
    v_index NUMBER := 1;
BEGIN
    FOR i IN c_criminals LOOP
        IF v_index <= 3 THEN
            DBMS_OUTPUT.PUT_LINE('Criminal id: ' || i.criminal_id || ' | Name: ' || i.first_name || ' ' || i.last_name || ' | Age: ' || i.age);
            v_index := v_index + 1;
        END IF;
    END LOOP;
END;
/

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

-- G. Packages (3 functions, 3 procedures, and 1 package)

-- Make afunction to return average age of criminals
CREATE OR REPLACE FUNCTION f_get_average_age RETURN NUMBER IS
    v_average_age NUMBER;
BEGIN
    SELECT AVG(age) INTO v_average_age FROM p_criminals;
    RETURN v_average_age;
END;
/
SELECT f_get_average_age FROM dual;

-- Make a function to return the number of criminals
CREATE OR REPLACE FUNCTION f_get_criminals_count RETURN NUMBER IS
    v_criminals_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_criminals_count FROM p_criminals;
    RETURN v_criminals_count;
END;
/
SELECT f_get_criminals_count FROM dual;

-- Make a function to return number of crimes for a given criminal id
CREATE OR REPLACE FUNCTION f_get_crimes_count(p_criminal_id IN NUMBER) RETURN NUMBER IS
    v_crimes_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_crimes_count FROM p_crime_history WHERE criminal_id = p_criminal_id;
    RETURN v_crimes_count;
END;
/
SELECT f_get_crimes_count(1) FROM dual;

-- Make a procedure to update a salary
CREATE OR REPLACE PROCEDURE p_update_salary(p_officer_id IN NUMBER, p_salary IN NUMBER) IS
BEGIN
    UPDATE p_salary
    SET salary = p_salary
    WHERE officer_info_id = p_officer_id;
END;
/
CALL p_update_salary(1, 100000);

-- Make a procedure to return total incarceration time of a criminal
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

-- Make a procedure that shows only criminals that have remarks in the p_criminals table (those who don't have remarks have the field null)
CREATE OR REPLACE PROCEDURE p_show_criminals_with_remarks IS
    CURSOR c_criminals_record IS
        SELECT *
        FROM p_criminals
        WHERE remarks IS NOT NULL;
    c_criminals c_criminals_record%rowtype;
BEGIN
    OPEN c_criminals_record;
    LOOP
        FETCH c_criminals_record INTO c_criminals;
        EXIT WHEN c_criminals_record%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Criminal id: ' || c_criminals.CRIMINAL_ID || ' | Name: ' || c_criminals.FIRST_NAME || ' ' || c_criminals.LAST_NAME || ' | Age: ' || c_criminals.AGE || ' | Remarks: ' || c_criminals.REMARKS);
    END LOOP;
    CLOSE c_criminals_record;
END;
/
CALL p_show_criminals_with_remarks();

-- Make a package with different utilities
CREATE OR REPLACE PACKAGE p_utilities AS
    -- Function: Find a criminal by name
    FUNCTION f_find_criminal_by_name(p_first_name IN VARCHAR2, p_last_name IN VARCHAR2) RETURN NUMBER;
    
    -- Procedure: Find a salary that is given
    PROCEDURE f_find_salary(p_salary IN NUMBER, p_officer_info_id IN OUT NUMBER);

    -- Function: Return the full name of a criminal
    FUNCTION f_get_full_name(p_criminal_id IN NUMBER) RETURN VARCHAR2;
END;
/

CREATE OR REPLACE PACKAGE BODY p_utilities AS
    FUNCTION f_find_criminal_by_name(p_first_name IN VARCHAR2, p_last_name IN VARCHAR2) RETURN NUMBER IS
        c_criminal_row P_CRIMINALS%ROWTYPE;
    BEGIN
        SELECT * INTO c_criminal_row FROM p_criminals WHERE first_name = p_first_name AND last_name = p_last_name;
        RETURN c_criminal_row.CRIMINAL_ID;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('There are more than one criminal with the same name');
            RETURN NULL;
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('There is no criminal with the given name');
            RETURN NULL;
    END f_find_criminal_by_name;
    
    PROCEDURE f_find_salary(p_salary IN NUMBER, p_officer_info_id IN OUT NUMBER) IS
        v_officer_id NUMBER;
    BEGIN
        SELECT officer_info_id INTO v_officer_id FROM p_salary WHERE salary = p_salary;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('There are more than one officer with the same salary');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('There is no officer with the given salary');
    END f_find_salary;

    FUNCTION f_get_full_name(p_criminal_id IN NUMBER) RETURN VARCHAR2 IS
        v_full_name VARCHAR2(100);
        v_first_name VARCHAR2(50);
        v_last_name VARCHAR2(50);
    BEGIN
        SELECT first_name, last_name INTO v_first_name, v_last_name FROM p_criminals WHERE criminal_id = p_criminal_id;
        v_full_name := v_first_name || ' ' || v_last_name;
        RETURN v_full_name;
    END f_get_full_name;
END p_utilities;
/

DECLARE
    v_officer_id NUMBER;
    v_criminal_id NUMBER;
BEGIN
    SELECT p_utilities.f_find_criminal_by_name('John', 'Doe') INTO v_criminal_id FROM dual;
    p_utilities.f_find_salary(2500, v_officer_id);
    IF v_officer_id IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Officer id: ' || v_officer_id);
    END IF;
    DBMS_OUTPUT.PUT_LINE('Full name: ' || p_utilities.f_get_full_name(2));
END;
/

-- H. Triggers

-- Create a trigger: count the salary difference when its updated
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

-- Create a trigger: when adding a criminal if the age is under 14 there will be an error raised
CREATE OR REPLACE TRIGGER t_criminal_age
    BEFORE INSERT ON p_criminals
    FOR EACH ROW
BEGIN
    IF :NEW.age < 14 THEN
        RAISE_APPLICATION_ERROR(-20101, 'Criminal age is under 14');
    END IF;
END;
/
BEGIN
    INSERT INTO p_criminals(CRIMINAL_ID, FIRST_NAME, LAST_NAME, AGE) VALUES (9, 'John', 'Doe', 13);
END;
/

-- Create a trigger: checks if there is an existing criminal with the same name, if a duplicate is found, it raises an exception and rolls back the transaction.
CREATE OR REPLACE TRIGGER prevent_duplicate_criminals
AFTER INSERT OR UPDATE ON P_CRIMINALS
DECLARE
   v_duplicate_count INTEGER;
BEGIN
   SELECT COUNT(*)
   INTO v_duplicate_count
   FROM p_criminals
   WHERE P_UTILITIES.F_GET_FULL_NAME(CRIMINAL_ID) IN
   (SELECT P_UTILITIES.F_GET_FULL_NAME(CRIMINAL_ID) AS full_name FROM p_criminals GROUP BY P_UTILITIES.F_GET_FULL_NAME(CRIMINAL_ID) HAVING COUNT(*) > 1);

   IF v_duplicate_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Duplicate criminal full name is not allowed.');
   END IF;
END;
/
BEGIN
    INSERT INTO p_criminals(CRIMINAL_ID, FIRST_NAME, LAST_NAME, AGE) VALUES (10, 'Flandre', 'Scarlet', 15);
END;
/

-- Create a trigger: if the criminals remarks are not in a list of predermined remarks, it will raise an exception and roll back the transaction.
CREATE OR REPLACE TRIGGER validate_criminal_status
AFTER INSERT OR UPDATE ON p_criminals
DECLARE
   v_invalid_status_count INTEGER;
BEGIN
   SELECT COUNT(*)
   INTO v_invalid_status_count
   FROM p_criminals
   WHERE remarks NOT IN ('in hospital', 'psychiatric problems', 'under house arrest');

   IF v_invalid_status_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Invalid criminal status found.');
   END IF;
END;
/
BEGIN
    INSERT INTO p_criminals(CRIMINAL_ID, FIRST_NAME, LAST_NAME, AGE, REMARKS) VALUES (11, 'John', 'Doe', 44, 'being happy');
END;
/