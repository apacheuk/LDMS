CREATE OR REPLACE PACKAGE BODY employees_file_api AS 

    /* use to create an employee */ 
    PROCEDURE create_employee (p_emp_name IN VARCHAR2,
                               p_job_title IN VARCHAR2,
                               p_manager_id IN VARCHAR2,
                               p_date_hired IN DATE,
                               p_salary IN NUMBER,
                               p_dept_id IN NUMBER) IS
                             
    BEGIN
    
      NULL;
    
    END create_employee;

END employees_file_api;