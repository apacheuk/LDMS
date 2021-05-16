SET TERMOUT OFF
SET VERIFY OFF
ACCEPT dept PROMPT 'Enter a Department ID'
BREAK ON TODAY
COLUMN TODAY NEW_VALUE _DATE
SELECT TO_CHAR(SYSDATE, 'DD/MM/RRRR') TODAY FROM dual;
COLUMN DEPTNAME NEW_VALUE _deptname
SELECT department_name deptname from departments_file where department_id=&dept;
CLEAR BREAKS
SET TERMOUT ON
TTITLE CENTER 'List Employees For Department: &_deptname' RIGHT _DATE
BTITLE  RIGHT 'PAGE:' SQL.PNO SKIP 2
COLUMN employee_id HEADING 'Employee|ID'
COLUMN employee_name FORMAT A30 HEADING 'Employee|Name'
COLUMN job_title FORMAT A20 HEADING 'Job Title'
COLUMN manager_id HEADING 'Manger|ID'
COLUMN date_hired HEADING 'Date Hired'
COLUMN salary HEADING 'Salary'
COLUMN department_id HEADING 'Department|ID'
COLUMN department_name HEADING 'Department|Name'
COLUMN managers_name FORMAT A30 HEADING 'Managers|Name'
COLUMN sum(salary) HEADING 'Total Salary'
SET LINESIZE 180


SPOOL list_employees_by_department.lis

SELECT  ef.employee_id ,
        ef.employee_name ,
        ef.job_title ,
        ef.manager_id ,
        managers.employee_name managers_name ,
        ef.date_hired ,
        ef.salary ,
        ef.department_id
FROM employees_file ef,
     employees_file managers
WHERE ef.manager_id = managers.employee_id(+)
AND  ef.department_id = &dept;

SPOOL OFF