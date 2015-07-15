--use SELECTION to execute the single queries one by one.

--Problem 1.	Write a SQL query to find the names and salaries of the employees that take the minimal salary in the company.
--Use a nested SELECT statement.

SELECT e.FirstName, e.LAStName, e.Salary
FROM Employees e
WHERE e.Salary = (SELECT MIN(e.Salary) FROM Employees e)

----------------------------------------------------------------------------------------------------------------------------------

--Problem 2.	Write a SQL query to find the names and salaries of the employees that have a salary that is up to 10% higher than 
--the minimal salary for the company.

SELECT e.FirstName,e.LAStName,e.Salary
FROM Employees e 
WHERE e.Salary <= 1.1 * (SELECT MIN(e.Salary) FROM	Employees e) 

----------------------------------------------------------------------------------------------------------------------------------

--Problem 3.	Write a SQL query to find the full name, salary and department of the employees that take the minimal salary in
-- their department. Use a nested SELECT statement.

SELECT e.FirstName, e.LAStName, e.Salary, d.Name AS [Department name]
FROM Employees e 
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = (SELECT MIN(e.Salary) FROM Employees e WHERE e.DepartmentID = d.DepartmentID)			

----------------------------------------------------------------------------------------------------------------------------------

--Problem 4.	Write a SQL query to find the average salary in the department #1.

SELECT AVG(e.Salary) AS [Average Salary], d.DepartmentID, d.Name AS [Department name]
FROM Employees e 
JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.Name
HAVING  d.DepartmentID = 1

SELECT AVG(Salary) AS [Average Salary IN Dep#1] FROM Employees
WHERE DepartmentID = 1

----------------------------------------------------------------------------------------------------------------------------------

--Problem 5.	Write a SQL query to find the average salary in the "Sales" department

SELECT AVG(e.Salary) AS [Average Salary], d.Name AS [Department name]
 FROM	Employees e 
 JOIN Departments d
 ON e.DepartmentID = d.DepartmentID
 GROUP BY d.Name
 having d.Name = 'Sales'

 select AVG(e.Salary) as [Average Salary Dep "Sales"] from Employees e
where e.DepartmentID= 
						(select d.DepartmentID from Departments d
						where d.Name='Sales')

----------------------------------------------------------------------------------------------------------------------------------

--Problem 6.	Write a SQL query to find the number of employees in the "Sales" department.

SELECT COUNT(e.EmployeeID) AS [Employees count], d.Name AS [Department name]
FROM Employees e 
JOIN Departments d
ON e.DepartmentID = d.DepartmentID  
GROUP BY d.Name 
having d.name = 'Sales'


select COUNT(e.FirstName) as [Number of employees in Sales]
from Employees e
where e.DepartmentID in 
					(select d.DepartmentID from Departments d
					where d.Name='Sales')

----------------------------------------------------------------------------------------------------------------------------------

--Problem 7.	Write a SQL query to find the number of all employees that have manager.

SELECT  COUNT(e.ManagerID) AS [Employees with manager]
FROM Employees e

----------------------------------------------------------------------------------------------------------------------------------

--Problem 8.	Write a SQL query to find the number of all employees that have no manager.

SELECT  COUNT(e.EmployeeID) AS [Employees without manager]
FROM Employees e
WHERE e.ManagerID IS NULL

SELECT  COUNT(e.EmployeeID) - COUNT(e.ManagerID) AS [Employees without manager]
FROM Employees e

----------------------------------------------------------------------------------------------------------------------------------

--Problem 9.	Write a SQL query to find all departments and the average salary for each of them

SELECT d.Name AS [Department name], AVG(e.Salary) AS [Average salary]
FROM Employees e JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name

----------------------------------------------------------------------------------------------------------------------------------

--Problem 10.	Write a SQL query to find the COUNT of all employees in each department and for each town

SELECT  t.Name AS [Town], d.Name AS [Department name], COUNT(d.Name) AS [Employees count]
FROM Employees e JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Addresses a ON e.AddressID = a.AddressID
JOIN Towns t ON a.TownID = t.TownID
GROUP BY t.Name, d.Name

select t.Name as [Town], d.Name as [Department], COUNT(e.FirstName) as [Count]
from Employees e, Departments d, Towns t, Addresses a
where e.DepartmentID=d.DepartmentID and e.AddressID = a.AddressID and t.TownID = a.TownID
group by d.Name, t.Name

ORDER BY [Department] ASC;

----------------------------------------------------------------------------------------------------------------------------------

--Problem 11.	Write a SQL query to find all managers that have exactly 5 employees. Display their first name and last name.

SELECT m.FirstName, m.LastName, COUNT(m.EmployeeID)  AS [Employees count]
FROM Employees m JOIN Employees e
ON e.ManagerID = m.EmployeeID
GROUP BY m.FirstName, m.LastName
having COUNT(m.EmployeeID) = 5
---
SELECT m.FirstName, m.LastName, COUNT(e.ManagerID)  AS [Employees count]
FROM Employees m JOIN Employees e
ON e.ManagerID = m.EmployeeID
GROUP BY m.FirstName, m.LastName
having COUNT(e.ManagerID) = 5

----------------------------------------------------------------------------------------------------------------------------------

--Problem 12.	Write a SQL query to find all employees along with their managers. For employees that do not have manager 
--display the value "(no manager)".

SELECT e.FirstName, e.LastName, ISNULL(m.FirstName + m.LastName, 'No Manager') AS [Manager]
FROM Employees e 
LEFT OUTER JOIN Employees m
ON e.ManagerID = m.EmployeeID

----------------------------------------------------------------------------------------------------------------------------------

--Problem 13.	Write a SQL query to find the names of all employees whose last name is exactly 5 characters long. 
--Use the built-in LEN(str) function.

SELECT e.FirstName, e.LastName, LEN(e.LastName) AS [Last name's length]
FROM Employees e
WHERE LEN(e.LastName) = 5

----------------------------------------------------------------------------------------------------------------------------------

--Problem 14.	Write a SQL query to display the current date and time in the following format "day.month.year hour:minutes:seconds:milliseconds". 

SELECT CONVERT(VARCHAR(24),GETDATE(),104) + ' ' + CONVERT(VARCHAR(24),GETDATE(),114) AS [Current date and time]

----------------------------------------------------------------------------------------------------------------------------------

--Problem 15.	Write a SQL statement to create a table Users. Users should have username, password, full name and last login time. 
--Choose appropriate data types for the table fields. Define a primary key column with a primary key constraint. Define the primary key column as 
--identity to facilitate inserting records. Define unique constraint to avoid repeating usernames. Define a check constraint to ensure 
--the password is at least 5 characters long

CREATE TABLE Users(
UserID INT IDENTITY,
UserName NVARCHAR(50) NOT NULL UNIQUE,
FullName NVARCHAR(50) NOT NULL,
UserPassword NVARCHAR(50) NOT NULL,
LastLoginTime DATETIME ,
CONSTRAINT PK_Users PRIMARY KEY(UserID),
CONSTRAINT CK_Users_Pass CHECK(LEN(UserPassword) >= 5)
)
GO

----------------------------------------------------------------------------------------------------------------------------------

--Problem 16.	Write a SQL statement to create a view that displays the users from the Users table that have been in the system today.

CREATE VIEW [UsersView] AS 
SELECT * FROM Users u 
WHERE u.LastLoginTime > DATEADD(DAY, -1, GETDATE())   
GO

SELECT * FROM UsersView
GO

CREATE VIEW [UsersView] AS
SELECT *
FROM Users
WHERE DAY(LastLoginTime) = DAY(GETDATE());

----------------------------------------------------------------------------------------------------------------------------------

--Problem 17.	Write a SQL statement to create a table Groups. Groups should have unique name (use unique constraint). Define primary key
-- and identity column.

CREATE TABLE Groups(
GroupID INT IDENTITY,
Name NVARCHAR(50) NOT NULL,
CONSTRAINT PK_Groups PRIMARY KEY(GroupID),
CONSTRAINT UK_Groups_Name UNIQUE(Name)
)
GO

----------------------------------------------------------------------------------------------------------------------------------

--Problem 18.	Write a SQL statement to add a column GroupID to the table Users. Fill some data in this new column and as well in the Groups table.
-- Write a SQL statement to add a foreign key constraint between tables Users and Groups tables.

ALTER TABLE Users ADD GroupId INT 
ALTER TABLE Users
ADD CONSTRAINT FK_Users_Groups
FOREIGN KEY(GroupId) REFERENCES Groups(GroupID)

----------------------------------------------------------------------------------------------------------------------------------

--Problem 19.	Write SQL statements to insert several records in the Users and Groups tables

INSERT INTO Users (Username, UserPassword, FullName, LastLoginTime, GroupId)
	VALUES 	('pesho', '111111', 'Pesho P', '2015-06-30', 1),
			('gosho', '222222', 'Gosho G', '2015-06-30', 2),
			('mimi', '333333', 'Mimi M', '2015-06-01',2),
			('sisi', '444444', 'Sosi S', '2015-06-01',3)
GO

INSERT INTO Groups(Name)
	VALUES 	('PHP'),
			('Databases'),
			('DB_Applications')
GO

----------------------------------------------------------------------------------------------------------------------------------

--Problem 20.	Write SQL statements to update some of the records in the Users and Groups tables

UPDATE Groups
SET Name = 'DATABASES'
WHERE Name = 'Databases'

UPDATE Groups
SET Name = 'C#'
WHERE Name = 'CSharp'

UPDATE Users
SET Username = 'Miro',
	FullName = 'Miro B',
	LastLoginTime = '1981-01-01'
WHERE Username = 'dddd'

----------------------------------------------------------------------------------------------------------------------------------

--Problem 21.	Write SQL statements to delete some of the records from the Users and Groups tables

DELETE FROM Users
WHERE  Username = 'Miro'

DELETE FROM Groups
WHERE  Name = 'PHP'

----------------------------------------------------------------------------------------------------------------------------------

--Problem 22.	Write SQL statements to insert in the Users table the names of all employees from the Employees table.
--Combine the first and last names as a full name. For username use the first letter of the first name + the last name (in lowercase). 
--Use the same for the password, and NULL for last login time.

INSERT INTO Users(Username, UserPassword, FullName, LastLoginTime)
SELECT  LEFT(e.FirstName, 1) + '. ' + ISNULL(UPPER(MiddleName), '_') + LOWER(e.LastName),
		LEFT(e.FirstName, 1) + LOWER(e.LastName) + 'pass',
		e.FirstName + ' ' + e.LastName,
		NULL
FROM Employees e

----------------------------------------------------------------------------------------------------------------------------------

--Problem 23.	Write a SQL statement that changes the password to NULL for all users that have not been in the system since 10.03.2010

ALTER TABLE Users
ALTER COLUMN UserPassword nvarchar(50) NULL

UPDATE Users
SET UserPassword = NULL
WHERE LastLoginTime > CONVERT(DATETIME, '20100310', 112)

---
UPDATE Users
SET UserPassword = NULL
WHERE LastLoginTime < CONVERT(DATE, '10-03-2010')

----------------------------------------------------------------------------------------------------------------------------------

--Problem 24.	Write a SQL statement that deletes all users without passwords (NULL password).

DELETE FROM Users
WHERE UserPassword IS NULL

----------------------------------------------------------------------------------------------------------------------------------

--Problem 25.	Write a SQL query to display the average employee salary by department and job title.

SELECT d.Name AS [Department], e.JobTitle, AVG(e.Salary) AS [Average Salary]
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle

----------------------------------------------------------------------------------------------------------------------------------

--Problem 26.	Write a SQL query to display the minimal employee salary by department and job title along with the name of 
--some of the employees that take it.

SELECT d.Name AS [Department], e.JobTitle, e.FirstName, MIN(e.Salary) AS [Mmin Salary]
FROM Employees e 
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle, e.FirstName

--only MIN
SELECT d.Name, e.JobTitle, e.FirstName, e.Salary AS [Min salary] FROM Employees AS e
	JOIN Departments AS d
	ON d.DepartmentID = e.DepartmentID
	WHERE e.Salary = (
		SELECT MIN(m.Salary)
		FROM Employees AS m
		WHERE DepartmentID = e.DepartmentID
	)
GROUP BY d.Name, e.JobTitle, e.FirstName, e.Salary

----------------------------------------------------------------------------------------------------------------------------------

--Problem 27.	Write a SQL query to display the town where maximal number of employees work

SELECT TOP 1 t.Name AS [Town] , COUNT(a.TownID) AS [Number of employees]
FROM Employees e 
INNER JOIN Addresses a ON e.AddressID = a.AddressID
INNER JOIN Towns t ON a.TownID = t.TownID
GROUP BY t.Name
ORDER BY COUNT(a.TownID) DESC

select top 1 t.Name, count(e.FirstName) as [employess]
from Employees e, Addresses a, Towns t
where e.AddressID= a.AddressID AND a.TownID= t.TownID
group by t.Name
order by [employess] desc

----------------------------------------------------------------------------------------------------------------------------------

--Problem 28.	Write a SQL query to display the number of managers from each town.

SELECT t.Name as [Town], COUNT (DISTINCT e.ManagerID) AS [Number of managers]
FROM Employees e 
INNER JOIN Employees m ON e.ManagerID = m.EmployeeID
INNER JOIN Addresses a ON m.AddressID = a.AddressID
INNER JOIN Towns t ON a.TownID = t.TownID
GROUP BY t.Name

----------------------------------------------------------------------------------------------------------------------------------

--Problem 29.	Write a SQL to create table WorkHours to store work reports for each employee.
--Each employee should have id, date, task, hours and comments. Don't forget to define identity, primary key and appropriate foreign key.

CREATE TABLE WorkHours(
WorkHourID INT IDENTITY NOT NULL,
[Date] DATETIME,
Task NVARCHAR(100) NOT NULL,
[Hours] FLOAT NOT NULL,
Comments NVARCHAR(150),
EmployeeID INT NOT NULL,
CONSTRAINT PK_WorkHours PRIMARY KEY(WorkHourID),
CONSTRAINT FK_WorkHours_Employees FOREIGN KEY(EmployeeID) REFERENCES Employees(EmployeeID),
CONSTRAINT CK_WorkHours_Hours CHECK([Hours] >= 0 AND [Hours] <= 24))

----------------------------------------------------------------------------------------------------------------------------------
--Problem 30.	Issue few SQL statements to insert, update and delete of some data in the table

INSERT INTO WorkHours([Date], Task, [Hours], Comments, EmployeeID)
VALUES  (CONVERT(DATETIME, '20150701', 112), 'Print docs', 2, NULL, 17),
		(CONVERT(DATETIME, '20150702', 112), 'Sale the product', 15, 'Do it!', 2),
		(CONVERT(DATETIME, '20150718', 112), 'Buy coffee', 1, 'No suggar, please!', 5),
		(NULL, 'Sing song', 5.4, 'Make it loud', 8)

UPDATE WorkHours
SET Comments = 'Buy printer first maybe', [Hours] = [Hours] + 3
WHERE WorkHourID = 1

DELETE FROM WorkHours
WHERE Task = 'Sing song'

----------------------------------------------------------------------------------------------------------------------------------

--Problem 31.	Define a table WorkHoursLogs to track all changes in the WorkHours table with triggers. For each change keep
-- the old record data, the new record data and the command (insert / update / delete).

CREATE TABLE WorkHoursLogs(
WorkHoursLogID INT NOT NULL IDENTITY PRIMARY KEY,	
WorkHoursID INT NOT NULL,
OldEmployeeID INT NULL,
NewEmployeeID INT NULL,
OldWorkHoursDate DATETIME NULL,
NewWorkHoursDate DATETIME NULL,
OldTask NVARCHAR(100) NULL,
NewTask NVARCHAR(100) NULL,
OldHours FLOAT NULL,
NewHours FLOAT NULL,
OldComments NVARCHAR(150) NULL,
NewComments NVARCHAR(150) NULL,
Command NVARCHAR(150)
)

GO

CREATE TRIGGER tr_WorkHoursUpdate ON WorkHours FOR UPDATE
AS
BEGIN
INSERT INTO WorkHoursLogs(WorkHoursID, OldEmployeeID, NewEmployeeID, OldWorkHoursDate, NewWorkHoursDate, OldTask, NewTask,
						  OldHours, NewHours, OldComments, NewComments, Command)

	SELECT 
		d.WorkHourID,
		d.EmployeeID,
		i.EmployeeID,
		d.[Date],
		i.[Date],
		d.Task,
		i.Task,
		d.[Hours],
		i.[Hours],
		d.Comments,
		i.Comments,
		'UPDATE'
	FROM DELETED d, INSERTED i
END
GO

UPDATE WorkHours
SET Comments = 'Good job, trigger!', [Hours] = 0
WHERE WorkHourID = 1
GO

CREATE TRIGGER tr_WorkHoursDelete ON WorkHours FOR DELETE
AS
BEGIN
INSERT INTO WorkHoursLogs(WorkHoursID, OldEmployeeID, NewEmployeeID, OldWorkHoursDate, NewWorkHoursDate, OldTask, NewTask,
						  OldHours, NewHours, OldComments, NewComments, Command)

	SELECT 
		d.WorkHourID,
		d.EmployeeID,
		NULL,
		d.[Date],
		NULL,
		d.Task,
		NULL,
		d.[Hours],
		NULL,
		d.Comments,
		NULL,
		'DELETE'
	FROM DELETED d
END
GO

DELETE FROM WorkHours
WHERE WorkHourID = 1
GO

CREATE TRIGGER tr_WorkHoursInsert ON WorkHours FOR INSERT
AS
BEGIN
INSERT INTO WorkHoursLogs(WorkHoursID, OldEmployeeID, NewEmployeeID, OldWorkHoursDate, NewWorkHoursDate, OldTask, NewTask,
						  OldHours, NewHours, OldComments, NewComments, Command)

	SELECT 
		i.WorkHourID,
		NULL,
		i.EmployeeID,
		NULL,
		i.[Date],
		NULL,
		i.Task,
		NULL,
		i.[Hours],
		NULL,
		i.Comments,
		'INSERT'
	FROM INSERTED i
END
GO

INSERT INTO WorkHours([Date], Task, [Hours], Comments, EmployeeID)
VALUES  (CONVERT(DATETIME, '20150701', 113), 'Check INSERT trigger', 3, 'Hope it works', 1)

----------------------------------------------------------------------------------------------------------------------------------

--Problem 32.	Start a database transaction, delete all employees from the 'Sales' department along with all dependent records 
--from the other tables. At the end rollback the transaction

-- drop the foreign key constaint first
ALTER TABLE Departments
DROP CONSTRAINT FK_Departments_Employees

BEGIN TRAN 
DELETE e
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ROLLBACK

-- make foreign key constarint
ALTER TABLE Departments 
ADD CONSTRAINT FK_Departments_Employees
	FOREIGN KEY(ManagerID)
	REFERENCES Employees(EmployeeID)

----------------------------------------------------------------------------------------------------------------------------------

--Problem 33.	Start a database transaction and drop the table EmployeesProjects. Then how you could restore back the lost table data?

BEGIN TRAN 
DROP TABLE EmployeesProjects
ROLLBACK

----------------------------------------------------------------------------------------------------------------------------------

--Problem 34.	Find how to use temporary tables in SQL Server.
--Using temporary tables backup all records from EmployeesProjects and restore them back after dropping and re-creating the table.

CREATE TABLE #TempEmployeesProjects(
EmployeeID INT NOT NULL,
ProjectID INT NOT NULL)

INSERT INTO #TempEmployeesProjects(EmployeeID,ProjectID)
SELECT EmployeeID,ProjectID FROM EmployeesProjects

DROP TABLE EmployeesProjects

CREATE TABLE EmployeesProjects(
  EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID) NOT NULL,
   ProjectID INT FOREIGN KEY REFERENCES Projects(ProjectID) NOT NULL,
)

INSERT INTO EmployeesProjects(EmployeeID,ProjectID)
SELECT EmployeeID,ProjectID FROM #TempEmployeesProjects
