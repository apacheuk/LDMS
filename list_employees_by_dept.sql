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
COLUMN department_id HEADING 'Department|ID'
COLUMN department_name HEADING 'Department|Name'
COLUMN sum(salary) HEADING 'Total Salary'
COLUMN sum(salary) FORMAT 999,999,990.00
SET LINESIZE 180


spool total_salaries_by_department.lis

select  ef.employee_id ,
        ef.employee_name ,
        ef.job_title ,
        ef.manager_id ,
        ef.date_hired ,
        ef.salary ,
        ef.department_id
from employees_file ef,
     departments_file df
where ef.department_id = df.department_id
AND ef.department_id = &dept;

spool off