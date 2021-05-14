DROP TABLE departments_file; 
DROP TABLE employees_file; 
    
CREATE TABLE departments_file (department_id NUMBER(6) GENERATED ALWAYS AS IDENTITY CONSTRAINT df_dept_id_nn NOT NULL,
                               department_name VARCHAR2(50) CONSTRAINT df_dept_name_nn NOT NULL,
                               location VARCHAR2(50) CONSTRAINT df_loc_nn NOT NULL,
                               PRIMARY KEY (department_id));

CREATE TABLE employees_file (employee_id NUMBER(10) GENERATED ALWAYS AS IDENTITY START WITH 90001 INCREMENT BY 1 CONSTRAINT ef_emp_id_nn NOT NULL,
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


commit;