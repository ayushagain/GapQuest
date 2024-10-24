CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL
);
CREATE TABLE Skills (
    skill_id SERIAL PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL,
    skill_group VARCHAR(50) NOT NULL,
    description TEXT
);
CREATE TABLE EmployeeSkills (
    employee_skill_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES Employees(employee_id) ON DELETE CASCADE,
    skill_id INT REFERENCES Skills(skill_id) ON DELETE CASCADE,
    proficiency_level VARCHAR(20) NOT NULL,
    last_assessed_date DATE
);
CREATE TABLE Competencies (
    competency_id SERIAL PRIMARY KEY,
    competency_name VARCHAR(100) NOT NULL,
    description TEXT
);
CREATE TABLE EmployeeCompetencies (
    employee_competency_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES Employees(employee_id) ON DELETE CASCADE,
    competency_id INT REFERENCES Competencies(competency_id) ON DELETE CASCADE,
    competency_level VARCHAR(20) NOT NULL
);
CREATE TABLE TrainingPrograms (
    training_id SERIAL PRIMARY KEY,
    training_name VARCHAR(100) NOT NULL,
    description TEXT,
    skill_id INT REFERENCES Skills(skill_id)
);
ALTER TABLE Skills
ADD CONSTRAINT unique_skill_name UNIQUE (skill_name);

ALTER TABLE Competencies
ADD CONSTRAINT unique_competency_name UNIQUE (competency_name);

ALTER TABLE TrainingPrograms
ADD CONSTRAINT unique_training_name UNIQUE (training_name);

DELETE FROM Employees;
DELETE FROM Skills;
DELETE FROM EmployeeSkills;
DELETE FROM Competencies;
DELETE FROM EmployeeCompetencies;
DELETE FROM TrainingPrograms;

SELECT * FROM Employees;