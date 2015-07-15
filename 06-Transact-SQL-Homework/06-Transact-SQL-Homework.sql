
--Problem 1.	Create a database with two tables - Persons (id (PK), first name, last name, SSN)
-- and Accounts (id (PK), person id (FK), balance). Insert few records for testing. 
--Write a stored procedure that selects the full names of all persons.

CREATE DATABASE BankDB
GO

USE BankDB

CREATE TABLE Persons(
	PersonID INT IDENTITY NOT NULL,
	FirstName NVARCHAR(40) NOT NULL,
	LastName NVARCHAR(40) NOT NULL,
	SSN VARCHAR(10) NOT NULL,
CONSTRAINT PK_Persons PRIMARY KEY(PersonID))
GO

CREATE TABLE Accounts(
	AccountID INT IDENTITY NOT NULL,
	PersonID INT,
	Balance MONEY,
CONSTRAINT PK_Accounts PRIMARY KEY(AccountID),
CONSTRAINT FK_Accounts_Persons FOREIGN KEY(PersonID) REFERENCES Persons(PersonID))
GO

INSERT INTO Persons(FirstName,LastName,SSN)
	VALUES('Emo', 'Ivanov', '060606060'),
		  ('Miro', 'Petkov', '121212121'),	
	      ('Stancho', 'Petkov', '131313131')
GO

INSERT INTO Accounts(PersonID, Balance) 
		VALUES(2, 36000),
			  (3, 10000),
			  (4, 10000)
GO

CREATE PROC usp_SelectFullName
AS
SELECT p.FirstName + ' ' + p.LastName AS [FullName]
FROM Persons p 
GO

EXEC usp_SelectFullName
GO

-----------------------------------------------------------------------------------------------------------------

--Problem 2.	Create a stored procedure.  Your task is to create a stored procedure that accepts a number as a parameter
--and returns all persons who have more money in their accounts than the supplied number

CREATE PROC usp_SelectPersonsWithMoreMOney(@amount MONEY)
AS
SELECT p.FirstName + ' ' + p.LastName AS [FullName], a.Balance
FROM Persons p 
JOIN Accounts a ON p.PersonID = a.PersonID
WHERE a.Balance > @amount
GO

EXEC usp_SelectPersonsWithMoreMOney 10000
GO

-----------------------------------------------------------------------------------------------------------------

--Problem 3.	Create a function with parameters.  Your task is to create a function that accepts as parameters – sum, 
--yearly interest rate and number of months. It should calculate and return the new sum. Write a SELECT to test if it works.

CREATE FUNCTION ufn_CalculateAmount(@amount MONEY, @interestRate FLOAT, @months INT) RETURNS MONEY
AS
BEGIN
DECLARE @interestPerMonth FLOAT =  @interestRate/12
RETURN @amount * (POWER(1 + @interestPerMonth, @months))
END
GO

DECLARE @result money
SELECT @result = dbo.ufn_CalculateAmount(1000, 0.12, 12)
print @result
GO

-----------------------------------------------------------------------------------------------------------------

--Problem 4.	Create a stored procedure that uses the function from the previous example.  Your task is to create a
--stored procedure that uses the function from the previous example to give an interest to a person's account for one month. 
--It should take the AccountId and the interest rate as parameters

CREATE PROC usp_CalculateMonthlyInterest(@accountID INT, @interestRate FLOAT)
AS
SELECT  p.FirstName, 
		p.LastName, 
		a.Balance AS [Initial balance], 
		dbo.ufn_CalculateAmount(a.Balance, @interestRate, 1) AS [Balance with interest for one month]
FROM Persons p 
JOIN Accounts a ON p.PersonID = a.PersonID
WHERE a.AccountID = @accountID
GO

EXEC usp_CalculateMonthlyInterest 7, 0.12 
GO
-----------------------------------------------------------------------------------------------------------------

--Problem 5.	Add two more stored procedures WithdrawMoney and DepositMoney.
--Add two more stored procedures WithdrawMoney (AccountId, money) and DepositMoney (AccountId, money) that operate in transactions.

CREATE PROC usp_WithdrawMoney(@accountID INT, @amount MONEY)
AS
DECLARE @InitialBalance MONEY 
SELECT @InitialBalance = a.Balance 
FROM Accounts a 
WHERE a.AccountID = @accountID

IF (@InitialBalance = 0)
BEGIN
	RAISERROR('Your amount is 0. You can not withdraw', 16, 1)
	RETURN
END

IF (@amount > @InitialBalance)
BEGIN
	RAISERROR('Insufficient availability', 16, 1)
	RETURN
END

UPDATE Accounts
SET Balance = (Balance - @amount)
WHERE AccountID = @accountID
GO

EXEC usp_WithdrawMoney 7, 10000
GO

---

CREATE PROC usp_DepositMoney(@accountID INT, @amount MONEY)
AS
UPDATE Accounts
SET Balance = (Balance + @amount)
WHERE AccountID = @accountID
GO

EXEC usp_DepositMoney 7, 10500
GO

-----------------------------------------------------------------------------------------------------------------

--Problem 6.	Create table Logs.  Create another table – Logs (LogID, AccountID, OldSum, NewSum). Add a trigger to the 
--Accounts table that enters a new entry into the Logs table every time the sum on an account changes.

CREATE TABLE Logs(
LogID INT IDENTITY NOT NULL,
AccountID INT NOT NULL,
OldSum MONEY NOT NULL,
NewSum MONEY NOT NULL,
CONSTRAINT PK_Logs PRIMARY KEY(LogID))
GO

CREATE TRIGGER tr_BankAccoutsUpdate ON Accounts FOR UPDATE
AS
BEGIN
INSERT INTO Logs(AccountID, OldSum, NewSum)
SELECT d.AccountID, d.Balance, i.Balance
FROM deleted d, inserted i
END
GO

EXEC usp_DepositMoney 7, 10500
GO

EXEC usp_WithdrawMoney 5, 10000
GO

-----------------------------------------------------------------------------------------------------------------

--Problem 7.	Define function in the SoftUni database.
--Define a function in the database SoftUni that returns all Employee's names (first or middle or last name) and all town's names
-- that are comprised of given set of letters.  --Example: 'oistmiahf' will return 'Sofia', 'Smith', but not 'Rob' and 'Guy'.

USE SoftUni
GO

CREATE FUNCTION ufn_CheckWordInText(@word NVARCHAR(MAX), @text NVARCHAR(MAX)) RETURNS INT
AS
BEGIN
DECLARE @wordLength INT = LEN(@word)
DECLARE @index INT = 1
DECLARE @currentChar char(1)

IF (@word IS NULL)
			BEGIN
				RETURN 0
			END
WHILE (@index <= @wordLength)
	BEGIN
		SET @currentChar = SUBSTRING(@word, @index,1)
		
		IF(CHARINDEX(@currentChar,@text) > 0)
			BEGIN
				SET @index = @index + 1
			END
		ELSE
			BEGIN
				RETURN 0
			END
	END
	RETURN 1
END
GO

CREATE FUNCTION ufn_EmployeesNamesTownsInLetters(@text NVARCHAR(MAX))
RETURNS @resultsFromSearch TABLE(
		Matches NVARCHAR(MAX))
AS
BEGIN
INSERT INTO @resultsFromSearch
SELECT e.FirstName 
FROM Employees e
WHERE dbo.ufn_CheckWordInText(e.FirstName, @text) = 1
INSERT INTO @resultsFromSearch
SELECT e.MiddleName
FROM Employees e
WHERE dbo.ufn_CheckWordInText(e.MiddleName, @text) = 1
INSERT INTO @resultsFromSearch
SELECT e.LastName
FROM Employees e
WHERE dbo.ufn_CheckWordInText(e.LastName, @text) = 1
INSERT INTO @resultsFromSearch
SELECT t.Name
FROM Towns t
WHERE dbo.ufn_CheckWordInText(t.Name, @text) = 1
RETURN
END
GO

SELECT * FROM dbo.ufn_EmployeesNamesTownsInLetters('oistmiahf')

-----------------------------------------------------------------------------------------------------------------

--Problem 8.	Using database cursor write a T-SQL. Using database cursor write a T-SQL script that scans all employees and
-- their addresses and prints all pairs of employees that live in the same town.

DECLARE empCursor CURSOR FOR 
SELECT
	e.FirstName + ' ' + e.LastName, t.Name
FROM Employees e 
JOIN Addresses a ON e.AddressID = a.AddressID
JOIN Towns t ON a.TownID = t.TownID
ORDER BY t.Name

OPEN empCursor
DECLARE @town NVARCHAR(50), @fullName NVARCHAR(50)
DECLARE @currentTown NVARCHAR(50), @currentFullName NVARCHAR(50)

FETCH NEXT FROM empCursor INTO @fullName, @town
WHILE @@FETCH_STATUS = 0
  BEGIN
	SET @currentTown = @town
	SET @currentFullName = @fullName
	FETCH NEXT FROM empCursor INTO @fullName, @town

	IF(@currentTown = @town)
	BEGIN
		PRINT @town + ': ' + @fullName + '; ' + @currentFullName
	END
  END

CLOSE empCursor
DEALLOCATE empCursor