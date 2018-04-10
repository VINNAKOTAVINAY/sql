--1. Display the last name concatenated with the job ID, separated by a comma and space, and name the column Employee and Title.

SELECT LAST_NAME || ’, ’ || JOB_ID "Employee and Title"
  FROM EMPLOYEES;

--2. Create a query to display all the data from the EMPLOYEES table. Separate each column by a comma. Name the column THE_OUTPUT.

SELECT EMPLOYEE_ID || ’,
       ’ || FIRST_NAME || ’,
       ’ || LAST_NAME || ’,
       ’ || EMAIL || ’,
       ’ || PHONE_NUMBER || ’,
       ’ || JOB_ID || ’,
       ’ || MANAGER_ID || ’,
       ’ || HIRE_DATE || ’,
       ’ || SALARY || ’,
       ’ || COMMISSION_PCT || ’,
       ’ || DEPARTMENT_ID THE_OUTPUT
  FROM EMPLOYEES;

--3. Create a query to display the last name and salary for all employees whose salary is not in the range of 5,000 and 12,000.

SELECT LAST_NAME, SALARY
  FROM EMPLOYEES
 WHERE SALARY NOT BETWEEN 5000 AND 12000;

--4. Display the employee last name, job ID, and start date of employees hired between February 20, 1998, and May 1, 1998. Order the query in ascending order by start date.

  SELECT LAST_NAME, JOB_ID, HIRE_DATE
    FROM EMPLOYEES
   WHERE HIRE_DATE BETWEEN TO_DATE ('20-FEB-98', 'DD-MON-YY')
                       AND TO_DATE ('01-MAY-98', 'DD-MON-YY')
ORDER BY HIRE_DATE;

--5. Display the last name and department number of all employees in departments 20 and 50 in alphabetical order by name.

  SELECT LAST_NAME, DEPARTMENT_ID
    FROM EMPLOYEES
   WHERE DEPARTMENT_ID IN (20, 50)
ORDER BY LAST_NAME;

--6. Display the last name and job title of all employees who do not have a manager.

SELECT A.LAST_NAME, B.JOB_TITLE
  FROM EMPLOYEES A, JOBS B
 WHERE A.JOB_ID = B.JOB_ID AND A.MANAGER_ID IS NULL;

--7. Display the last name, salary, and commission for all employees who earn commissions. Sort data in descending order of salary and commissions.

  SELECT LAST_NAME, SALARY, COMMISSION_PCT
    FROM EMPLOYEES
   WHERE COMMISSION_PCT IS NOT NULL
ORDER BY SALARY DESC, COMMISSION_PCT DESC;

--8. For each employee, display the employee number, last_name, salary, and salary increased by 15% and expressed as a whole number. Label the column New Salary.

SELECT EMPLOYEE_ID,
       LAST_NAME,
       SALARY,
       ROUND (SALARY * 1.15, 0) "New Salary"
  FROM EMPLOYEES;

--9. Modify your above query to add a column that subtracts the old salary from the new salary. Label the column Increase.

SELECT EMPLOYEE_ID,
       LAST_NAME,
       SALARY,
       ROUND (SALARY * 1.15, 0) "New Salary",
       ROUND (SALARY * 1.15, 0) - SALARY "Increase"
  FROM EMPLOYEES;

--10. Write a query that displays the employee’s last names with the first letter capitalized and all other letters lowercase and the length of the name for all employees whose name starts with J, A, or M. Give each column an appropriate label. Sort the results by the employees’ last names.

  SELECT INITCAP (LAST_NAME) "Name", LENGTH (LAST_NAME) "Length"
    FROM EMPLOYEES
   WHERE LAST_NAME LIKE 'J%' OR LAST_NAME LIKE 'M%' OR LAST_NAME LIKE 'A%'
ORDER BY LAST_NAME;

--11. Create a unique listing of all jobs that are in department 80. Include the location of the department in the output.

SELECT DISTINCT JOB.JOB_TITLE, LOC.CITY, DEPT.DEPARTMENT_ID
  FROM EMPLOYEES EMP,
       DEPARTMENTS DEPT,
       JOBS JOB,
       LOCATIONS LOC
 WHERE     EMP.DEPARTMENT_ID = DEPT.DEPARTMENT_ID
       AND EMP.JOB_ID = JOB.JOB_ID
       AND DEPT.LOCATION_ID = LOC.LOCATION_ID
       AND EMP.DEPARTMENT_ID = 80;

--12. Display the employee last name and department name for all employees who have an “a” (lowercase) in their last names.

SELECT EMP.LAST_NAME, DEPT.DEPARTMENT_NAME
  FROM EMPLOYEES EMP, DEPARTMENTS DEPT
 WHERE     EMP.DEPARTMENT_ID = DEPT.DEPARTMENT_ID
       AND LOWER (EMP.LAST_NAME) LIKE '%a%';

--13. Write a query to display the last name, job, department number, and department name for all employees who work in Toronto.

SELECT E.LAST_NAME,
       J.JOB_TITLE,
       E.DEPARTMENT_ID,
       D.DEPARTMENT_NAME
  FROM EMPLOYEES E
       JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
       JOIN LOCATIONS L ON (D.LOCATION_ID = L.LOCATION_ID)
       JOIN JOBS J ON (E.JOB_ID = J.JOB_ID)
 WHERE LOWER (L.CITY) = ’Toronto’;

--14. Create a query that displays employee last names, department numbers, and all the employees who work in the same department as a given employee. Give each column an appropriate label.

  SELECT E.DEPARTMENT_ID DEPARTMENT,
         E.LAST_NAME EMPLOYEE,
         C.LAST_NAME COLLEAGUE
    FROM EMPLOYEES E JOIN EMPLOYEES C ON (E.DEPARTMENT_ID = C.DEPARTMENT_ID)
   WHERE E.EMPLOYEE_ID <> C.EMPLOYEE_ID
ORDER BY E.DEPARTMENT_ID, E.LAST_NAME, C.LAST_NAME;

--15. Display the names and hire dates for all employees who were hired before their managers, along with their manager’s names and hire dates. Label the columns Employee, Emp Hired, Manager, and Mgr Hired, respectively.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 -- OR

SELECT A.LAST_NAME,
       A.HIRE_DATE,
       B.LAST_NAME,
       B.HIRE_DATE
  FROM EMPLOYEES A JOIN EMPLOYEES B ON (A.MANAGER_ID = B.EMPLOYEE_ID)
 WHERE A.HIRE_DATE < B.HIRE_DATE;

--16. Display the highest, lowest, sum, and average salary of all employees. Label the columns Maximum, Minimum, Sum, and Average, respectively. Round your results to the nearest whole number

SELECT ROUND (MAX (SALARY), 0) "Maximum",
       ROUND (MIN (SALARY), 0) "Minimum",
       ROUND (SUM (SALARY), 0) "Sum",
       ROUND (AVG (SALARY), 0) "Average"
  FROM EMPLOYEES;

--17. Determine the number of managers without listing them. Label the column Number of Managers.

SELECT COUNT (DISTINCT MANAGER_ID) "Number of Managers" FROM EMPLOYEES;

--18. Create a query that will display the total number of employees and, of that total, the number of employees hired in 1995, 1996, 1997, and 1998. Create appropriate column headings.

SELECT COUNT (*) TOTAL,
       SUM (DECODE (TO_CHAR (HIRE_DATE, ’YYYY’), 1995, 1, 0)) "1995",
       SUM (DECODE (TO_CHAR (HIRE_DATE, ’YYYY’), 1996, 1, 0)) "1996",
       SUM (DECODE (TO_CHAR (HIRE_DATE, ’YYYY’), 1997, 1, 0)) "1997",
       SUM (DECODE (TO_CHAR (HIRE_DATE, ’YYYY’), 1998, 1, 0)) "1998"
  FROM EMPLOYEES;

--19. Create a matrix query to display the job, the salary for that job based on department number, and the total salary for that job, for departments 20, 50, 80, and 90, giving each column an appropriate heading.

  SELECT JOB_ID "Job",
         SUM (DECODE (DEPARTMENT_ID, 20, SALARY)) "Dept 20",
         SUM (DECODE (DEPARTMENT_ID, 50, SALARY)) "Dept 50",
         SUM (DECODE (DEPARTMENT_ID, 80, SALARY)) "Dept 80",
         SUM (DECODE (DEPARTMENT_ID, 90, SALARY)) "Dept 90",
         SUM (SALARY) "Total"
    FROM EMPLOYEES
GROUP BY JOB_ID;

--20. Write a query that displays the employee numbers and last names of all employees who work in a department with any employee whose last name contains a “u”.

SELECT EMPLOYEE_ID, LAST_NAME
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                           FROM EMPLOYEES
                          WHERE LAST_NAME LIKE '%u%');

--21. Write a query to display the last name, department number, and salary of any employee whose department number and salary both match the department number and salary of any employee who earns a commission.

SELECT LAST_NAME, DEPARTMENT_ID, SALARY
  FROM EMPLOYEES
 WHERE (SALARY, DEPARTMENT_ID) IN (SELECT SALARY, DEPARTMENT_ID
                                     FROM EMPLOYEES
                                    WHERE COMMISSION_PCT IS NOT NULL);

--22. Create a query to display the last name, hire date, and salary for all employees who have the same salary and commission as Kochhar.

SELECT LAST_NAME, HIRE_DATE, SALARY
  FROM EMPLOYEES
 WHERE     (SALARY, NVL (COMMISSION_PCT, 0)) IN (SELECT SALARY,
                                                        NVL (COMMISSION_PCT,
                                                             0)
                                                   FROM EMPLOYEES
                                                  WHERE LAST_NAME =
                                                           ’Kochhar’)
       AND LAST_NAME != ’Kochhar’;

--23. Write a query to find all employees who earn more than the average salary in their departments. Display last name, salary, department ID, and the average salary for the department. Sort by average salary. Use aliases for the columns retrieved by the query as shown in the sample output.

  SELECT E.LAST_NAME ENAME,
         E.SALARY SALARY,
         E.DEPARTMENT_ID DEPTNO,
         AVG (A.SALARY) DEPT_AVG
    FROM EMPLOYEES E, EMPLOYEES A
   WHERE     E.DEPARTMENT_ID = A.DEPARTMENT_ID
         AND E.SALARY > (SELECT AVG (SALARY)
                           FROM EMPLOYEES
                          WHERE DEPARTMENT_ID = E.DEPARTMENT_ID)
GROUP BY E.LAST_NAME, E.SALARY, E.DEPARTMENT_ID
ORDER BY AVG (A.SALARY);
