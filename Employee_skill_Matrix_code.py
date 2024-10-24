import pandas as pd
import psycopg2

db_params = {
    'dbname': 'Employee_Skill_Matrix',
    'user': 'postgres',
    'password': 'IS4H@N98Sh',
    'host': 'localhost',
    'port': 5432
}

df = pd.read_csv('employee_skill_matrix_updated_departments.csv')

conn = psycopg2.connect(**db_params)
cur = conn.cursor()

for _, row in df.iterrows():
    cur.execute("""
        INSERT INTO Employees (first_name, last_name, email, department, job_title, hire_date)
        VALUES (%s, %s, %s, %s, %s, %s) RETURNING employee_id
    """, (row['first_name'], row['last_name'], row['email'], row['department'], row['job_title'], row['hire_date']))
    employee_id = cur.fetchone()[0]

    cur.execute("""
        INSERT INTO Skills (skill_name, skill_group, description)
        VALUES (%s, %s, %s) ON CONFLICT (skill_name) DO NOTHING RETURNING skill_id
    """, (row['skill_name'], row['skill_group'], row['skill_description']))
    skill_id = cur.fetchone()[0] if cur.rowcount > 0 else None

    if skill_id:
        cur.execute("""
            INSERT INTO EmployeeSkills (employee_id, skill_id, proficiency_level, last_assessed_date)
            VALUES (%s, %s, %s, %s)
        """, (employee_id, skill_id, row['proficiency_level'], row['last_assessed_date']))

    cur.execute("""
        INSERT INTO Competencies (competency_name, description)
        VALUES (%s, %s) ON CONFLICT (competency_name) DO NOTHING RETURNING competency_id
    """, (row['competency_name'], row['competency_description']))
    competency_id = cur.fetchone()[0] if cur.rowcount > 0 else None

    if competency_id:
        cur.execute("""
            INSERT INTO EmployeeCompetencies (employee_id, competency_id, competency_level)
            VALUES (%s, %s, %s)
        """, (employee_id, competency_id, row['competency_level']))

    cur.execute("""
        INSERT INTO TrainingPrograms (training_name, description, skill_id)
        VALUES (%s, %s, %s) ON CONFLICT (training_name) DO NOTHING RETURNING training_id
    """, (row['training_name'], row['training_description'], skill_id))



conn.commit()
cur.close()
conn.close()

print("Data inserted successfully from CSV to PostgreSQL!")