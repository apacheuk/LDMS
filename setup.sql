DROP TABLE departments_file;    
    
CREATE TABLE departments_file (department_id NUMBER(6) GENERATED AS IDENTITY CONSTRAINT df_dept_id_nn NOT NULL,
                               department_name VARCHAR2(50) CONSTRAINT df_dept_name_nn NOT NULL,
                               location VARCHAR2(50) CONSTRAINT df_loc_nn NOT NULL);
                               
INSERT INTO departments_file(department_name, location) VALUES ('Management','London');
INSERT INTO departments_file(department_name, location) VALUES ('Engineering','Cardiff');
INSERT INTO departments_file(department_name, location) VALUES ('Research '||CHR(38)||' Development','Edinburgh');
INSERT INTO departments_file(department_name, location) VALUES ('Sales','Belfast');


commit;