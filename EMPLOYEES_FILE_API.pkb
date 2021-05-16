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
    
    /*  checks to see if a emp id exists
        accepts:-
            p_emp_id - the id of the employee to be checked
        returns:-
            l_found - 'FALSE' if record NOT found
    */
    FUNCTION check_emp_id (p_emp_id IN employees_file.employee_id%TYPE) RETURN VARCHAR2 IS
        CURSOR check_emp_id (cv_emp_id IN employees_file.employee_id%TYPE) IS
        SELECT 'TRUE'
        FROM employees_file
        WHERE employee_id = cv_emp_id;
        
        l_found VARCHAR2(10) := 'TRUE';
        
    BEGIN
    
        OPEN check_emp_id (p_emp_id);
        FETCH check_emp_id INTO l_found;
        IF (check_emp_id%NOTFOUND) THEN
            l_found := 'FALSE';
        END IF;
        CLOSE check_emp_id;
        
        RETURN l_found;
    
    END check_emp_id;   
    
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

    /*  used to validate the manager, must exist
        accepts:-
            p_manager_id - employee id of manager
        raises:-
            -20401 Manager does not exsist!;
    */
    PROCEDURE validate_manager_id(p_manager_id IN employees_file.manager_id%TYPE) IS
    BEGIN
        IF (check_emp_id(p_manager_id) = 'FALSE') THEN
            RAISE_APPLICATION_ERROR(-20401, 'Manger does not exist!');
        END IF;
    END validate_manager_id;
    
    /*  used to validate the job title, can not be greater than 50 charcters
        no other validation at this point
        accepts:-
            p_job_title - job_title
        raises:-
            -20501 job title description too long!;
    */
    PROCEDURE validate_job_title(p_job_title IN employees_file.job_title%TYPE) IS
    BEGIN
        IF (length(p_job_title) > 50) THEN
            RAISE_APPLICATION_ERROR(-20501, 'Job title description is too big (max: 50)!');
        END IF;
    END validate_job_title;   
    
    /*  used to validate the employee name, can not be greater than 50 charcters
        no other validation at this point
        accepts:-
            p_employee_name - Employees name
        raises:-
            -20601 Employees Name too long!;
    */
    PROCEDURE validate_employee_name(p_employee_name IN employees_file.employee_name%TYPE) IS
    BEGIN
        IF (length(p_employee_name) > 50) THEN
            RAISE_APPLICATION_ERROR(-20601, 'Employee Name is too big (max: 50)!');
        END IF;
    END validate_employee_name;    
    
    /*  used to validate the employee id
        accepts:-
            p_emp_id - employee id to check
            p_check_type - EXISTS - will check for existence of a row (DEFAULT)
                           NOTEXISTS - will check if row missing
        raises:-
            -20701 Employee ID can not be null!;
            -20702 Employee ID already exsist!;
    */
    PROCEDURE validate_employee_id(p_emp_id IN employees_file.employee_id%TYPE,
                                   p_check_type IN VARCHAR2 DEFAULT 'EXISTS') IS
    BEGIN
        IF (p_emp_id IS NULL) THEN
            RAISE_APPLICATION_ERROR(-20701, 'Employee ID cannot be null!');
        END IF;
        IF (p_check_type = 'EXISTS') THEN
            IF (check_emp_id(p_emp_id) = 'TRUE') THEN
                RAISE_APPLICATION_ERROR(-20702, 'Employee ID already exists!');
            END IF;
        ELSE
            IF (check_emp_id(p_emp_id) = 'FALSE') THEN
                RAISE_APPLICATION_ERROR(-20703, 'Employee ID does not exist!');
            END IF;        
        END IF;
    END validate_employee_id;
    
    
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
    PROCEDURE create_employee (p_id IN employees_file.employee_id%TYPE,
                               p_name IN employees_file.employee_name%TYPE,
                               p_job_title IN employees_file.job_title%TYPE,
                               p_manager_id IN employees_file.manager_id%TYPE,
                               p_date_hired IN employees_file.date_hired%TYPE,
                               p_salary IN employees_file.salary%TYPE,
                               p_dept_id IN departments_file.department_id%TYPE) IS
                               
        e_id EXCEPTION;
        e_name EXCEPTION;
        e_job_title  EXCEPTION;
        e_manager_id EXCEPTION;
        e_hire_date EXCEPTION;
        e_salary EXCEPTION;
        e_dept EXCEPTION;
        
        PRAGMA EXCEPTION_INIT(e_dept, -20101);
        PRAGMA EXCEPTION_INIT(e_dept, -20102);
        PRAGMA EXCEPTION_INIT(e_salary, -20201);
        PRAGMA EXCEPTION_INIT(e_salary, -20202);
        PRAGMA EXCEPTION_INIT(e_hire_date, -20302);
        PRAGMA EXCEPTION_INIT(e_manager_id, -20401);
        PRAGMA EXCEPTION_INIT(e_job_title, -20501);
        PRAGMA EXCEPTION_INIT(e_name, -20601);
        PRAGMA EXCEPTION_INIT(e_id, -20701);
        PRAGMA EXCEPTION_INIT(e_id, -20702);
                             
    BEGIN
        dbms_output.put_line('validating params');
        -- validates the employee id, must not exist!
        validate_employee_id(p_id);
        
        -- validates the employee_name, currently only checks to see 
        -- breaks length 
        validate_employee_name(p_name);

        -- validates the job_title, currently only checks to see 
        -- breaks length 
        validate_job_title(p_job_title);
        
        -- validates the manager id, must exist but can be null!
        IF (p_manager_id IS NOT NULL) THEN
            validate_manager_id(p_manager_id);
        END IF;
        
        -- validates hire date, cannot be null
        validate_hire_date(p_date_hired);
    
        -- validate salary, check for too big and negative
        validate_salary(p_salary);
    
        -- validate department check for null and invalid id
        validate_department(p_dept_id);
        
        dbms_output.put_line('inserting row');    
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

        dbms_output.put_line('ending');
    EXCEPTION
        WHEN e_id THEN
            -- any additional exception handling?
            -- any additional exception handling?
            -- raise error
            RAISE;
        WHEN e_name THEN
            -- any additional exception handling?
            -- raise error
            RAISE;
        WHEN e_job_title THEN
            -- any additional exception handling?
            -- raise error
            RAISE;
        WHEN e_manager_id THEN
            -- any additional exception handling?
            -- raise error
            RAISE;
        WHEN e_hire_date THEN
            -- any additional exception handling?
            -- raise error
            RAISE;
        WHEN e_salary THEN
            -- any additional exception handling?
            -- raise error
            RAISE;
        WHEN e_dept THEN
            -- any additional exception handling?
            -- raise error
            RAISE;
    END create_employee;

    /*  returns an employees salary
        accepts:-
            p_emp_id - employee id
        raises:-
            e_emp_id - raised when invlaid emp_id is null or not valid
        returns:-
            salary of employee passed in
    */
    FUNCTION get_salary (p_emp_id IN employees_file.employee_id%TYPE) RETURN employees_file.salary%TYPE AS
        CURSOR get_salary(cv_emp_id employees_file.employee_id%TYPE) IS
        SELECT salary
        FROM employees_file
        WHERE employee_id = cv_emp_id;
        
        l_salary employees_file.salary%TYPE;

        e_id EXCEPTION;

        PRAGMA EXCEPTION_INIT(e_id, -20701);
        PRAGMA EXCEPTION_INIT(e_id, -20703);
        
    BEGIN
        -- validate employee id, this will check for null emp_id and
        -- if the emp_id is a valid one
        validate_employee_id(p_emp_id => p_emp_id, 
                             p_check_type => 'NOTEXISTS');

        -- employee_id already validated
        OPEN get_salary (p_emp_id);
        FETCH get_salary INTO l_salary;
        CLOSE get_salary;
        
        RETURN l_salary;
    EXCEPTION
        WHEN e_id THEN
            -- any additional exception handling?
            -- raise error
            RAISE;

    END get_salary;

    /*  moves an employee from one department to another
        accepts:-
            p_emp_id - employee id
            p_new_dept_id - new department id
        raises:-
            e_dept_id -20101 Department ID cannot be null
                      -20102 Department ID does not exist   
    */
    PROCEDURE move_employee (p_emp_id IN employees_file.employee_id%TYPE,
                             p_new_dept_id IN departments_file.department_id%TYPE) IS

        e_dept EXCEPTION;
        e_id EXCEPTION;

        PRAGMA EXCEPTION_INIT(e_dept, -20101);
        PRAGMA EXCEPTION_INIT(e_dept, -20102); 
        PRAGMA EXCEPTION_INIT(e_id, -20701);
        PRAGMA EXCEPTION_INIT(e_id, -20703);        
        
    BEGIN
        -- validate employee id, this will check for null emp_id and
        -- if the emp_id is a valid one
        validate_employee_id(p_emp_id => p_emp_id, 
                             p_check_type => 'NOTEXISTS');
    
        -- validate department check for null and invalid id
        validate_department(p_new_dept_id);
        
        UPDATE employees_file
        SET department_id = p_new_dept_id
        WHERE employee_id = p_emp_id;
    EXCEPTION
        WHEN e_id THEN
            -- any additional exception handling?
            -- any additional exception handling?
            -- raise error
            RAISE;
        WHEN e_dept THEN
            -- any additional exception handling?
            -- raise error
            RAISE;                
    END move_employee;

END employees_file_api;