SET TERMOUT OFF
SET VERIFY OFF
BREAK ON TODAY
COLUMN TODAY NEW_VALUE _DATE
SELECT TO_CHAR(SYSDATE, 'DD/MM/RRRR') TODAY FROM dual;
CLEAR BREAKS
SET TERMOUT ON
TTITLE CENTER 'Total Salaries by Department' RIGHT _DATE
BTITLE  RIGHT 'PAGE:' SQL.PNO SKIP 2
COLUMN department_id HEADING 'Department|ID'
COLUMN department_name HEADING 'Department|Name'
COLUMN sum(salary) HEADING 'Total Salary'
COLUMN sum(salary) FORMAT 999,999,990.00
SET LINESIZE 180

spool total_salaries_by_department.lis

select ef.department_id, df.department_name, sum(salary)
from employees_file ef,
     departments_file df
where ef.department_id = df.department_id
group by ef.department_id, df.department_name
order by ef.department_id;

spool off