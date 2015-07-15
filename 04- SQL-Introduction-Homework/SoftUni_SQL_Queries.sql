
--use SELECTION to execute the single queries one by one.

--Problem 4.	Write a SQL query to find all information about all departments

SELECT * FROM Departments

-------------------------------------------------------------------------------
--Problem 5.	Write a SQL query to find all department names

SELECT name AS [Department Name] 
FROM Departments

-------------------------------------------------------------------------------

--Problem 6.	Write a SQL query to find the salary of each employee

SELECT (e.FirstName + ' ' +  e.LastName)AS Employee, e.Salary
FROM Employees e

-------------------------------------------------------------------------------

--Problem 7.	Write a SQL to find the full name of each employee

SELECT e.FirstName + ' ' + e.LastName AS [Full name] 
FROM Employees e

SELECT EmployeeId, FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name] FROM Employees

-------------------------------------------------------------------------------

--Problem 8.	Write a SQL query to find the email addresses of each employee.
-- (by his first and last name). Consider that the mail domain is softuni.bg. 
--Emails should look like “John.Doe@softuni.bg". The produced column should be named "Full Email Addresses".

SELECT e.FirstName + '.' + e.LastName + '@softuni.bg' AS [Full Email Addresses] 
FROM Employees e

-------------------------------------------------------------------------------

--Problem 9.	Write a SQL query to find all different employee salaries.

SELECT DISTINCT e.Salary AS [Different Salaries]
FROM Employees e 

-------------------------------------------------------------------------------

--Problem 10.	Write a SQL query to find all information about the employees whose
-- job title is “Sales Representative“.

SELECT * FROM Employees e
WHERE e.JobTitle = 'Sales Representative'

-------------------------------------------------------------------------------

--Problem 11.	Write a SQL query to find the names of all employees whose first name starts with "SA".

SELECT e.FirstName + ' ' + e.LastName AS [Names starting with "SA"]
FROM	Employees e
WHERE e.FirstName LIKE 'SA%'

-------------------------------------------------------------------------------

--Problem 12.	Write a SQL query to find the names of all employees whose last name contains "ei".

SELECT e.FirstName + ' ' + e.LastName AS [Names containg "ei"]
FROM Employees e
WHERE e.LastName LIKE '%ei%'

-------------------------------------------------------------------------------

--Problem 13.	Write a SQL query to find the salary of all employees whose salary is in the range [20000…30000].

SELECT e.FirstName + ' ' + e.LastName AS [Employee], e.Salary
FROM Employees e
WHERE e.Salary BETWEEN 20000 AND 30000
ORDER BY e.Salary

-------------------------------------------------------------------------------

--Problem 14.	Write a SQL query to find the names of all employees whose salary is 25000, 14000, 12500 or 23600.

SELECT e.FirstName + ' ' + e.LastName AS [Employees with salaries 25000, 14000, 12500 or 23600], e.Salary 
FROM Employees e
WHERE e.Salary IN (25000, 14000, 12500 , 23600)
ORDER BY e.Salary DESC

-------------------------------------------------------------------------------

--Problem 15.	Write a SQL query to find all employees that do not have manager.

SELECT e.FirstName + ' ' + e.LastName AS [Employees with no Manager] ,e.ManagerID 
FROM Employees e 
WHERE e.ManagerID is null

-------------------------------------------------------------------------------

--Problem 16.	Write a SQL query to find all employees that have salary more than 50000. Order them in decreasing order by salary.

SELECT e.FirstName + ' ' + e.LastName AS [Employees with salaries more than 50000], e.Salary 
FROM Employees e
WHERE e.Salary > 50000
ORDER BY e.Salary DESC

-------------------------------------------------------------------------------

--Problem 17.	Write a SQL query to find the top 5 best paid employees

SELECT TOP 5 e.FirstName + ' ' + e.LastName AS [Top 5 best paid employees], e.Salary 
FROM Employees e
ORDER BY e.Salary DESC

-------------------------------------------------------------------------------

--Problem 18.	Write a SQL query to find all employees along with their address. Use inner join with ON clause.

SELECT e.FirstName,e.LastName, t.Name AS [Town], a.AddressText AS [Address]
FROM Employees e
INNER JOIN Addresses a ON e.AddressID = a.AddressID
INNER JOIN Towns t ON a.TownID = t.TownID

-------------------------------------------------------------------------------

--Problem 19.	Write a SQL query to find all employees and their address. Use equijoins (conditions in the WHERE clause).

SELECT e.FirstName,e.LastName, t.Name AS [Town], a.AddressText AS [Address]
FROM Employees e,Addresses a, Towns t
WHERE e.AddressID = a.AddressID AND a.TownID = t.TownID

-------------------------------------------------------------------------------
--Problem 20.	Write a SQL query to find all employees along with their manager.

SELECT e.FirstName + ' ' +  e.LastName AS [Employee], m.FirstName + ' ' +  m.LastName AS [Manager]
FROM Employees e 
JOIN Employees m
ON e.ManagerID = m.EmployeeID

-------------------------------------------------------------------------------

--Problem 21.	Write a SQL query to find all employees, along with their manager and their address.
--You should join the 3 tables: Employees e, Employees m and Addresses a.

SELECT e.FirstName + ' ' + e.LastName AS [Employee], a.AddressText AS [Address], t.Name AS [Town], m.FirstName + ' ' + m.LastName AS [Manager]
FROM Employees e
INNER JOIN Addresses a ON e.AddressID = a.AddressID
INNER JOIN Employees m ON e.ManagerID = m.EmployeeID
INNER JOIN Towns t ON a.TownID = t.TownID


--SELECT e.FirstName + ' ' + e.LastName AS [Employee Name],
--	ea.AddressText AS [Employee Address],
--	m.FirstName + ' ' + m.LastName AS [Manager Name],
--	ma.AddressText AS [Manager Address]
--FROM Employees e
--INNER JOIN Employees m
--ON e.ManagerID = m.EmployeeID
--INNER JOIN Addresses ma
--ON m.AddressID = ma.AddressID
--INNER JOIN Addresses ea
--ON e.AddressID = ea.AddressID

-------------------------------------------------------------------------------

--Problem 22.	Write a SQL query to find all departments and all town names as a single list. Use UNION.

SELECT d.Name AS [Name]
FROM Departments d
UNION 
SELECT t.Name AS [Name]
FROM Towns t

-------------------------------------------------------------------------------
--Problem 23.	Write a SQL query to find all the employees and the manager for each of them along with the employees
--that do not have manager. Use right outer join. Rewrite the query to use left outer join.

SELECT e.FirstName + ' ' +  e.LastName AS [Employee], m.FirstName + ' ' +  m.LastName AS [Manager]
FROM Employees e 
LEFT OUTER JOIN Employees m
ON e.ManagerID = m.EmployeeID


SELECT e.FirstName + ' ' +  e.LastName AS [Employee], m.FirstName + ' ' +  m.LastName AS [Manager]
FROM Employees m 
RIGHT OUTER JOIN Employees e
ON e.ManagerID = m.EmployeeID

-------------------------------------------------------------------------------

--Problem 24.	Write a SQL query to find the names of all employees from the departments "Sales" and "Finance" 
--whose hire year is between 1995 and 2005.

SELECT e.FirstName + ' ' + e.LastName AS [Employee], d.Name AS [Department], e.HireDate
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE (d.Name = 'Sales' OR d.Name = 'Finance') AND (e.HireDate BETWEEN '1995-01-01' AND '2005-01-01')


SELECT e.FirstName + ' ' + e.LastName AS [Employee], d.Name AS [Department], e.HireDate
FROM Employees e
INNER JOIN Departments d 
ON (d.DepartmentID = e.DepartmentID
AND (d.Name = 'Sales' OR d.Name = 'Finance') 
AND (e.HireDate between '1995-01-01' and '2005-01-01'))
