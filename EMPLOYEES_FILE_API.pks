CREATE OR REPLACE PACKAGE employees_file_api AS 

    /*  use to create an employee 
        accepts:-
            p_id - Employee id
            p_name - Employees full name
            p_job_title - Employees job title
            p_manager_id - Employees manger id
            p_hire_date - Employees hire date
            p_salary - starting salary of employee
            p_dept_id - Empoyees department id
        raises:-
            e_id - employee id
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
                               p_dept_id IN departments_file.department_id%TYPE);

    /*  returns an employees salary
        accepts:-
            p_emp_id - employee id
        raises:-
            e_emp_id - raised when invlaid emp_id is passed
        returns:-
            salary of employee passed in
    */
    FUNCTION get_salary (p_emp_id IN employees_file.employee_id%TYPE) RETURN employees_file.salary%TYPE;
                               
    /*  modifies an employees salary, can increase or decrease (+/-) value
        by percentage, then validates the new salary
        accepts:-
            p_emp_id - employee id
            p_percentage - amount to change salary by, expressed as a percentage
                           ie. increase by 10%
        raises:-
            e_emp_id - raised when invlaid emp_id is passed
            e_salary - raised when salary is missing or invalid (too big or neg)

    */
    PROCEDURE modify_salary(p_emp_id IN employees_file.employee_id%TYPE,
                            p_percentage IN NUMBER);                               

    /*  moves an employee from one department to another
        accepts:-
            p_emp_id - employee id
            p_new_dept_id - new department id
        raises:-
            e_dept_id -20101 Department ID cannot be null
                      -20102 Department ID does not exist   
    */
    PROCEDURE move_employee (p_emp_id IN employees_file.employee_id%TYPE,
                             p_new_dept_id IN departments_file.department_id%TYPE);

END employees_file_api;