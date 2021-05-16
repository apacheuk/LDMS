DROP TABLE employees_file; 
DROP TABLE departments_file; 

CREATE TABLE departments_file (department_id NUMBER(6) GENERATED ALWAYS AS IDENTITY CONSTRAINT df_dept_id_nn NOT NULL,
                               department_name VARCHAR2(50) CONSTRAINT df_dept_name_nn NOT NULL,
                               location VARCHAR2(50) CONSTRAINT df_loc_nn NOT NULL,
                               PRIMARY KEY (department_id));

CREATE TABLE employees_file (employee_id NUMBER(10),
                             employee_name VARCHAR2(50) CONSTRAINT ef_emp_name_nn NOT NULL,
                             job_title VARCHAR2(50) CONSTRAINT ef_job_title_nn NOT NULL,
                             manager_id NUMBER(10),
                             date_hired DATE CONSTRAINT ef_date_hired_nn NOT NULL,
                             salary NUMBER(10) CONSTRAINT ef_sal_nn NOT NULL,
                             department_id NUMBER(6) CONSTRAINT ef_dept_id_nn NOT NULL,
                             PRIMARY KEY (employee_id),
                             FOREIGN KEY(manager_id) REFERENCES employees_file(employee_id),
                             FOREIGN KEY(department_id) REFERENCES departments_file(department_id));

                               
INSERT INTO departments_file(department_name, location) VALUES ('Management','London');
INSERT INTO departments_file(department_name, location) VALUES ('Engineering','Cardiff');
INSERT INTO departments_file(department_name, location) VALUES ('Research '||CHR(38)||' Development','Edinburgh');
INSERT INTO departments_file(department_name, location) VALUES ('Sales','Belfast');

INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90001, 'John Smith', 'CEO',NULL,'01-JAN-1995',100000,1);
INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90002, 'Jimmy Willis', 'Manager',90001,'23-MAR-2003',52500,4);
INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90003, 'Roxy Jones', 'Salesperson',90002,'11-FEB-2017',35000,4);
INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90004, 'Selwyn Field', 'Salesperson',90002,'20-MAY-2015',32000,4);
INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90006, 'Sarah Phelps ', 'Manager',90001,'21-MAR-2015',45000,2);
INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90005, 'David Hallett', 'Engineer',90006,'17-APR-2018',40000,2);
INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90007, 'Louise Harper', 'Engineer',90006,'01-JAN-2013',47000,2);
INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90009, 'Gus Jones', 'Manager',90001,'15-MAY-2018',50000,3);
INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90008, 'Tina Hart', 'Engineer',90009,'28-JUL-2014',45000,3);
INSERT INTO employees_file(employee_id, employee_name, job_title, manager_id, date_hired, salary, department_id)
VALUES (90010, 'Mildred Hall', 'Secretary',90001,'12-OCT-1996',35000,1);

commit;