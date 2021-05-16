# LDMS

To install run ```setup.sql``` once logged into the schema owner

## Assumptions
Have assumed all objects will be stored in the same schema and user will login as that schema owner, so haven't created synonyms or grants, obivously if that isn't the case these can be easily added.

### Data Structures
Departments File
Spec doesn't say whether the department ID is just a sequential number or whether the numbers have significance to the department name and should be user defined. In this case I have made the assuption that it is just a sequence and its value has no meaning.

### Employees File
Spec doesn't say whether the employee ID is just a sequential number or whether the numbers have significance to the employee name and should be user defined. In this case I have made the assuption that they should be user defined.
Have made the assumption both salepersons report to Jimmy Willis, manager id is null in the source data - or at least it is for me when viewed through googledocs

## Creating and Employee
An employee can be created by making a call to the following procedure

```SQL
employees_file_api.create_employee(p_id, p_name, p_job_title, p_manager_id, p_date_hired, p_salary, p_dept_id);
```

This procedure accepts the following parameters :-
| Parameter Name | Description |
| ---------------| ------------|
| p_id           | This is an Employee ID, user defined|
| p_name         | This is the Employees full name (max 50 chars)|
| p_job_title    | Employees job title (max 50 chars)|
| p_manager_id   | Employees Manger id, must be a valid employee themselves |
| p_hire_date    | Employees hire date |
| p_salary       | starting salary of employee |
| p_dept_id      |  Employees department id, must exist in the table ```departments_file``` |

This procedure can raise the following exceptions
| Code           | Decription |
| -------------- | ---------- |
| -20101         | Department ID cannot be null |
| -20102 		 | Department ID does not exist |
| -20201 		 | Salary to big |
| -20202 		 | salary can not be negative |
| -20301 		 | hire date cannot be null |
| -20401 		 | Manager does not exsist! |
| -20501 		 | job title description too long! |
| -20601 		 | Employees Name too long! |
| -20701 		 | Employee ID can not be null! |
| -20702 		 | Employee ID already exsist! |
