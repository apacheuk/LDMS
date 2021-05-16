CREATE OR REPLACE PACKAGE BODY employees_file_api AS 

    /*  checks to see if a department id exists
        accepts:-
            p_dept_id - the id of the department to be checked
        returns:-
            l_found - 'FALSE' if record NOT found
    */
    FUNCTION check_department_id (p_dept_id IN departments_file.department_id%TYPE) RETURN VARCHAR2 IS
        CURSOR check_department_id (cv_department_id IN departments_file.department_id%TYPE) IS
        SELECT 'TRUE'
        FROM departments_file
        WHERE department_id = cv_department_id;
        
        l_found VARCHAR2(10) := 'TRUE';
        
    BEGIN
    
        OPEN check_department_id (p_dept_id);
        FETCH check_department_id INTO l_found;
        IF (check_department_id%NOTFOUND) THEN
            l_found := 'FALSE';
        END IF;
        CLOSE check_department_id;
        
        RETURN l_found;
    
    END check_department_id;
    
    /*  checks to see if a manager id exists
        we could add check here for job_title as well, but not
        a requirement at the moment as job_title is free format text
        accepts:-
            p_manager_id - the id of the manager to be checked
        returns:-
            l_found - 'FALSE' if record NOT found
    */
    FUNCTION check_manager_id (p_manager_id IN employees_file.manager_id%TYPE) RETURN VARCHAR2 IS
        CURSOR check_manager_id (cv_manager_id IN employees_file.manager_id%TYPE) IS
        SELECT 'TRUE'
        FROM employees_file
        WHERE employee_id = cv_manager_id;
        
        l_found VARCHAR2(10) := 'TRUE';
        
    BEGIN
    
        OPEN check_manager_id (p_manager_id);
        FETCH check_manager_id INTO l_found;
        IF (check_manager_id%NOTFOUND) THEN
            l_found := 'FALSE';
        END IF;
        CLOSE check_manager_id;
        
        RETURN l_found;
    
    END check_manager_id;    
    
    /*  used to validate the department
        accepts:-
            p_dept_id - the id of the department to be checked
        raises:-
            -20101 Department ID cannot be null
            -20102 Department ID does not exist        
    */
    PROCEDURE validate_department(p_dept_id IN departments_file.department_id%TYPE) IS
    BEGIN
        IF (p_dept_id IS NULL) THEN
            RAISE_APPLICATION_ERROR(-20101, 'Department ID cannot be null!');
        END IF;
        IF (check_department_id(p_dept_id) = 'FALSE') THEN
            RAISE_APPLICATION_ERROR(-20102, 'Department ID does not exist!');
        END IF;
    END validate_department;

    /*  used to validate the salary, cehcks not to big and not negative
        accepts:-
            p_salary - the salary to be checked
        raises:-
            -20201 Salary to big
            -20202 salary can not be negative
    */
    PROCEDURE validate_salary(p_salary IN employees_file.salary%TYPE) IS
    BEGIN
        IF (p_salary > 9999999999) THEN
            RAISE_APPLICATION_ERROR(-20201,'Salary too big!');
        END IF;
        IF (p_salary < 0) THEN
            RAISE_APPLICATION_ERROR(-20202,'Salary can not be negative');
        END IF;    
    END validate_salary;

    /*  used to validate the hire_Date, can not be null
        accepts:-
            p_date_hired - hire date
        raises:-
            -20301 hire date cannot be null;
    */
    PROCEDURE validate_hire_date(p_date_hired IN employees_file.date_hired%TYPE) IS
    BEGIN
        IF (p_date_hired IS NULL) THEN
            RAISE_APPLICATION_ERROR(-20301,'Hire Date cannot be NULL!');
        END IF;
    END validate_hire_date;


    /*  use to create an employee 
        accepts:-
            p_id
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
    PROCEDURE create_employee (p_id IN NUMBER,
                               p_name IN VARCHAR2,
                               p_job_title IN VARCHAR2,
                               p_manager_id IN VARCHAR2,
                               p_date_hired IN DATE,
                               p_salary IN NUMBER,
                               p_dept_id IN departments_file.department_id%TYPE) IS
                               
        e_id EXCEPTION;
        e_name EXCEPTION;
        e_job_title  EXCEPTION;
        e_manager_id EXCEPTION;
        e_hire_date EXCEPTION;
        e_salary EXCEPTION;
        e_dept EXCEPTION;
        
        PRAGMA EXCEPTION_INIT(e_dept, -20101);
        PRAGMA EXCEPTION_INIT(e_salary, -20201);
        PRAGMA EXCEPTION_INIT(e_salary, -20202);
                             
    BEGIN
        -- validates hire date, cannot be null
        validate_hire_date(p_date_hired);
    
        -- validate salary, check for too big and negative
        validate_salary(p_salary);
    
        -- validate department check for null and invalid id
        validate_department(p_dept_id);
    
        INSERT INTO employees_file (employee_id,
                                    employee_name,
                                    job_title,
                                    manager_id,
                                    date_hired,
                                    salary,
                                    department_id)
        VALUES (p_id,
                p_name,
                p_job_title,
                p_manager_id,
                p_date_hired,
                p_salary,
                p_dept_id);

    
    EXCEPTION
        WHEN e_id THEN
            null;
        WHEN e_name THEN
            null;
        WHEN e_job_title THEN
            null;
        WHEN e_manager_id THEN
            null;
        WHEN e_hire_date THEN
            null;
        WHEN e_salary THEN
            RAISE_APPLICATION_ERROR(sqlcode, sqlerrm);
        WHEN e_dept THEN
            RAISE_APPLICATION_ERROR(sqlcode, sqlerrm);    
    END create_employee;

END employees_file_api;