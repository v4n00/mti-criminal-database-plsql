-- deleting the tables
DROP TABLE p_captivity_history CASCADE CONSTRAINTS;
DROP TABLE p_crime_history CASCADE CONSTRAINTS;
DROP TABLE p_criminals CASCADE CONSTRAINTS;
DROP TABLE p_involved_officers CASCADE CONSTRAINTS;
DROP TABLE p_involved_victims CASCADE CONSTRAINTS;
DROP TABLE p_officer_info CASCADE CONSTRAINTS;
DROP TABLE p_victim_info CASCADE CONSTRAINTS;
DROP TABLE p_salary CASCADE CONSTRAINTS;

-- creating the tables
CREATE TABLE p_criminals
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
);

CREATE TABLE p_crime_history
(
 crime_id NUMBER(6) CONSTRAINT ch_pk PRIMARY KEY,
 criminal_id NUMBER(6) CONSTRAINT ch_fk REFERENCES p_criminals(criminal_id),
 officer_id NUMBER(6) UNIQUE,
 victim_id NUMBER(6) UNIQUE,
 crime_date DATE,
 offense VARCHAR2(100),
 address VARCHAR2(40),
 region CHAR(2)
); 

CREATE TABLE p_captivity_history
(
 cell NUMBER(1),
 date_incarcerated DATE,
 date_freed DATE,
 captivity_id NUMBER(6) CONSTRAINT caph_fk REFERENCES p_criminals(captivity_history_id),
 CONSTRAINT caph_pk PRIMARY KEY (cell,date_incarcerated)
);

CREATE TABLE p_officer_info
(
 officer_info_id NUMBER(6) CONSTRAINT oi_pk PRIMARY KEY,
 first_name VARCHAR2(30),
 last_name VARCHAR2(30),
 rank VARCHAR2(20),
 chief_id NUMBER(6),
 age NUMBER(2),
 CONSTRAINT chief_fk FOREIGN KEY (CHIEF_ID) REFERENCES P_OFFICER_INFO (OFFICER_INFO_ID)
);

CREATE TABLE p_involved_officers
(
 officer_id NUMBER(6),
 officer_info_id NUMBER(6),
 date_assigned DATE,
 CONSTRAINT io_pk PRIMARY KEY (officer_id, officer_info_id),
 CONSTRAINT io_fk1 FOREIGN KEY (officer_id) REFERENCES p_crime_history (officer_id),
 CONSTRAINT io_fk2 FOREIGN KEY (officer_info_id) REFERENCES p_officer_info (officer_info_id)
);

CREATE TABLE p_victim_info
(
 victim_info_id NUMBER(6) CONSTRAINT vi_pk PRIMARY KEY,
 first_name VARCHAR2(30),
 last_name VARCHAR2(30),
 age NUMBER(2),
 gender CHAR(1),
 address VARCHAR2(40)
);

CREATE TABLE p_involved_victims
(
 victim_id NUMBER(6),
 victim_info_id NUMBER(6),
 has_insurance CHAR(1),
 CONSTRAINT iv_pk PRIMARY KEY (victim_id, victim_info_id),
 CONSTRAINT iv_fk1 FOREIGN KEY (victim_id) REFERENCES p_crime_history (victim_id),
 CONSTRAINT iv_fk2 FOREIGN KEY (victim_info_id) REFERENCES p_victim_info (victim_info_id)
);

CREATE TABLE p_salary
(
 officer_info_id NUMBER(6) CONSTRAINT sal_fk REFERENCES p_officer_info(officer_info_id),
 salary NUMBER(6) DEFAULT 9000,
 bonus NUMBER(6),
 CONSTRAINT sal_uni UNIQUE (officer_info_id)
);

-- inserting the data
-- p_criminals
INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (6073683838378, 1, 1, 'Marisa', 'Kirisame', 25, 'f', 'Str Greensage 63', null); 
INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (6038536829398, 2, 2, 'Flandre', 'Scarlet', 21, 'f', 'Str Ogoal 7', null);
INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (6094536537363, 3, 3, 'Remilia', 'Scarlet', 21, 'f', 'Str Ogoal 7', 'under house arrest'); 
INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (5039579378368, 4, 4, 'Jak', 'Mar', 37, 'm', 'Str Klaw 15', 'psychiatric problems'); 
INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (5085547536482, 5, 5, 'Karlsefni', 'Thorfinn', 19, 'm', 'Str Igubun 37', null); 
INSERT INTO p_criminals (cnp, criminal_id, captivity_history_id, first_name, last_name, age, gender, address, remarks) VALUES (6072686799263, 6, 6, 'Patchouli', 'Knowledge', 38, 'f', 'Str Librariei 7', 'psychiatric problems'); 

-- p_crime_history
INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (1, 1, 1, 1, TO_DATE('21-05-2022','DD-MM-RRRR'), 'theft', 'Str Gensokyo 223', 'IC');
INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (2, 1, 2, 2, TO_DATE('17-09-2021','DD-MM-RRRR'), 'assault', 'Str Daxter 19', 'IC');
INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (3, 1, 3, 3, TO_DATE('05-03-2021','DD-MM-RRRR'), 'disorderly conduct', 'Str Gol 44', 'IC');
INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (4, 2, 4, 4, TO_DATE('29-01-2020','DD-MM-RRRR'), 'littering', 'Str Maya 98', 'BR');
INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (5, 3, 5, 5, TO_DATE('02-03-2022','DD-MM-RRRR'), 'traffic offense', 'Str Sunken 42', 'YU');
INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (6, 3, 6, 6, TO_DATE('09-05-2022','DD-MM-RRRR'), 'traffic offense', 'Str Precursor 26', 'YU');
INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (7, 4, 7, 7, TO_DATE('30-12-2021','DD-MM-RRRR'), 'hunting without a license', 'Str Bullet 4', 'TC');
INSERT INTO p_crime_history (crime_id, criminal_id, officer_id, victim_id, crime_date, offense, address, region) VALUES (8, 5, 8, 8, TO_DATE('08-05-2020','DD-MM-RRRR'), 'excessive noise', 'Str Sumap 172', 'HL');

-- p_captivity_history
INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (1, TO_DATE('05-03-2021', 'DD-MM-RRRR'), TO_DATE('22-03-2022', 'DD-MM-RRRR'), 1);
INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (1, TO_DATE('17-09-2021', 'DD-MM-RRRR'), TO_DATE('17-10-2022', 'DD-MM-RRRR'), 1);
INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (3, TO_DATE('02-03-2022', 'DD-MM-RRRR'), TO_DATE('03-03-2022', 'DD-MM-RRRR'), 3);
INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (2, TO_DATE('09-05-2022', 'DD-MM-RRRR'), TO_DATE('10-05-2022', 'DD-MM-RRRR'), 3);
INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (2, TO_DATE('30-12-2021', 'DD-MM-RRRR'), TO_DATE('30-01-2022', 'DD-MM-RRRR'), 4);
INSERT INTO p_captivity_history (cell, date_incarcerated, date_freed, captivity_id) VALUES (1, TO_DATE('08-05-2020', 'DD-MM-RRRR'), TO_DATE('15-05-2020', 'DD-MM-RRRR'), 5);

-- p_officer_info
INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (1, 'Hecatia', 'Lapislazuli', 'captain', null, 28);
INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (2, 'Keiki', 'Haniyasushin', 'corporal', 1, 25);
INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (3, 'Koishi', 'Komeiji', 'corporal', 1, 31);
INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (4, 'Alice', 'Margatroid', 'officer', 3, 26);
INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (5, 'Hong', 'Meiling', 'officer', 2, 29);
INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (6, 'Minamitsu', 'Murasa', 'officer', 3, 31);
INSERT INTO p_officer_info (officer_info_id, first_name, last_name, rank, chief_id, age) VALUES (7, 'Nitori', 'Kwashiro', 'officer', 3, 26);

-- p_involved_officers
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (1, 3, TO_DATE('21-05-2022','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (2, 1, TO_DATE('17-09-2021','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (2, 2, TO_DATE('18-09-2021','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (3, 4, TO_DATE('06-03-2021','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (4, 5, TO_DATE('29-01-2020','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (5, 4, TO_DATE('02-03-2022','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (5, 5, TO_DATE('04-03-2022','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (6, 7, TO_DATE('09-05-2022','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (7, 2, TO_DATE('30-12-2021','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (7, 7, TO_DATE('03-01-2022','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (7, 4, TO_DATE('04-01-2022','DD-MM-RRRR'));
INSERT INTO p_involved_officers (officer_id, officer_info_id, date_assigned) VALUES (8, 7, TO_DATE('08-05-2020','DD-MM-RRRR'));

-- p_victim_info
INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (1, 'Ran', 'Yakumo', 28, 'f', 'Str Nue 19');
INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (2, 'Reisen', 'Udonge', 47, 'f', 'Str Ringo 38');
INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (3, 'Satori', 'Komeiji', 30, 'f', 'Str Seiran 144');
INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (4, 'Saimos', 'Sage', 25, 'm', 'Str Sandover 89');
INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (5, 'Tenshi', 'Hinanai', 45, 'f', 'Str Urumi 121');
INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (6, 'Tewi', 'Inaba', 62, 'f', 'Str Forma 60');
INSERT INTO p_victim_info (victim_info_id, first_name, last_name, age, gender, address) VALUES (7, 'Yuyuko', 'Saigyouji', 52, 'f', 'Str Lob 108');

-- p_involved_victims
INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (1, 3, 'y');
INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (1, 4, 'n');
INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (1, 2, 'n');
INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (2, 1, 'y');
INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (2, 7, 'n');
INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (3, 5, 'n');
INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (5, 7, 'y');
INSERT INTO p_involved_victims (victim_id, victim_info_id, has_insurance) VALUES (8, 6, 'y');

-- p_salary
INSERT INTO p_salary(officer_info_id, salary, bonus) VALUES (1, 12000, 0);
INSERT INTO p_salary(officer_info_id, salary, bonus) VALUES (3, 11000, 0);
INSERT INTO p_salary(officer_info_id, salary, bonus) VALUES (7, 11450, 0);