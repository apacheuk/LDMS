CREATE OR REPLACE PACKAGE BODY employees_file_api AS 

    /*  use to create an employee 
        accepts:-
            p_name - Employees full name
            p_job_title - Employees job title
            p_manager_id - Employees manger id
            p_hire_date - Employees hire date
            p_salary - starting salary of employee
            p_dept_id - Empoyees department id
        raises:-
            e_name - rasied when Employee name is missing
            e_job_title - raised when job title is missing
            e_manager_id - raised when manager id invalid
            e_hire_date - raised when hire_date is missing
            e_salary - raised when salary is missing or invalid (too big or neg)
            e_dept - raised when dept is missing
            
    */ 
    PROCEDURE create_employee (p_emp_name IN VARCHAR2,
                               p_job_title IN VARCHAR2,
                               p_manager_id IN VARCHAR2,
                               p_date_hired IN DATE,
                               p_salary IN NUMBER,
                               p_dept_id IN NUMBER) IS
                               
        e_name EXCEPTION;
        e_job_title  EXCEPTION;
        e_manager_id EXCEPTION;
        e_hire_date EXCEPTION;
        e_salary EXCEPTION;
        e_dept EXCEPTION;
                             
    BEGIN
    
      NULL;
    
    EXCEPTION
        WHEN e_name THEN
            null;
        WHEN e_job_title THEN
            null;
        WHEN e_manager_id THEN
            null;
        WHEN e_hire_date THEN
            null;
        WHEN e_salary THEN
            null;
        WHEN e_dept THEN
            null;    
    END create_employee;

END employees_file_api;