COLUMN department_id HEADING 'Department|ID'
COLUMN department_name HEADING 'Department|Name'
COLUMN sum(salary) HEADING 'Total Salary'
COLUMN sum(salary) FORMAT 999,999,990

select ef.department_id, df.department_name, sum(salary)
from employees_file ef,
     departments_file df
where ef.department_id = df.department_id
group by ef.department_id, df.department_name
order by ef.department_id;