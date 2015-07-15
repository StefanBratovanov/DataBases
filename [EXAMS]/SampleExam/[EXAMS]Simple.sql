
--01---------------------------------------------------------------
SELECT title as [Title] FROM ads	
ORDER BY Title

--02---------------------------------------------------------------

SELECT a.Title, a.Date
FROM ads a
WHERE a.Date >= '2014-12-26' and a.Date <= '2015-01-02'
ORDER BY a.Date

--03---------------------------------------------------------------

SELECT a.Title, a.Date, [Has Image] = CASE 
	WHEN a.ImageDataURL IS NULL THEN  'no'
	ELSE 'yes'
	END
FROM ads a
ORDER BY a.Id

--04---------------------------------------------------------------

SELECT * FROM Ads
WHERE TownId IS NULL or CateGOryId is  null or ImageDataURL IS NULL
ORDER BY  Id

--05---------------------------------------------------------------

SELECT a.Title, t.Name as [Town]
FROM Ads a 
LEFT JOIN Towns t on a.TownId = t.Id
ORDER BY a.Id

--06---------------------------------------------------------------

SELECT a.Title, c.Name as [CateGOryName], t.Name as [TownName], st.Status
FROM Ads a 
LEFT JOIN Towns t on a.TownId = t.Id
LEFT JOIN CateGOries c on a.CateGOryId = c.Id
LEFT JOIN AdStatuses st on a.StatusId = st.Id
ORDER BY a.Id

--07---------------------------------------------------------------

SELECT a.Title, c.Name as [CateGOryName], t.Name as [TownName], st.Status
FROM Ads a 
LEFT JOIN Towns t on a.TownId = t.Id
LEFT JOIN CateGOries c on a.CateGOryId = c.Id
LEFT JOIN AdStatuses st on a.StatusId = st.Id
WHERE t.Name in ('Sofia', 'BlaGOevgrad', 'Stara ZaGOra') and st.Status = 'Published'
ORDER BY a.Title

--08---------------------------------------------------------------

SELECT MIN(a.Date) as [MinDate] , MAX(a.Date) as [MaxDate]
FROM ads a

--09---------------------------------------------------------------

SELECT top 10 a.Title, a.Date, ads.Status
FROM ads a 
JOIN AdStatuses ads on a.StatusId = ads.Id
ORDER BY a.Date DESC

--10---------------------------------------------------------------

SELECT a.Id, a.Title, a.Date, ads.Status
FROM ads a 
JOIN AdStatuses ads on a.StatusId = ads.Id
WHERE ads.Status != 'Published'
and YEAR(a.Date) = YEAR((SELECT min(a.Date) FROM ads a))
and MONTH(a.Date) = MONTH((SELECT min(a.Date) FROM ads a))
ORDER BY a.Id

--11---------------------------------------------------------------

SELECT st.Status, COUNT(a.StatusId) as [Count]
FROM Ads a JOIN
AdStatuses st on a.StatusId = st.Id
GROUP BY st.Status
ORDER BY st.Status

--12---------------------------------------------------------------

SELECT t.Name as [Town Name], st.Status, COUNT(st.Status) as [Count]
FROM Towns t 
JOIN ads a on t.id = a.TownId
JOIN AdStatuses st on a.StatusId = st.Id
GROUP BY t.Name, st.Status
ORDER BY t.Name, st.Status

--13---------------------------------------------------------------

SELECT LOWER(us.Name) as [UserName], COUNT(a.OwnerId) as [AdsCount], 
				(CASE WHEN us.Name 	IN (SELECT us.Name FROM AspNetUsers us
										LEFT JOIN AspNetUserRoles usr on us.Id = usr.UserId
										LEFT JOIN AspNetRoles roles on  usr.RoleId = roles.Id
										WHERE roles.Name = 'Administrator')
				 THEN 'yes' ELSE 'no' END) as [IsAdministrator]
FROM AspNetUsers us
LEFT JOIN ads a on us.Id = a.OwnerId
GROUP BY us.Name
ORDER BY us.Name

---

select Lower(u.Name) as UserName, count (a.Id) as AdsCount, case  
when u.Id in (select ur.UserId from AspNetUserRoles ur 
				left join AspNetRoles r on r.Id = ur.RoleId
				where r.name = 'Administrator') then 'yes'
else 'no' end as IsAdministrator
from AspNetUsers u
left join ads a on a.OwnerId = u.Id
group by u.Name, u.Id
order by u.Name


--14---------------------------------------------------------------

SELECT COUNT(a.Id) as [AdsCount], ISNULL(t.Name, '(no town)') as [Town]
FROM Ads a
LEFT JOIN Towns t on a.TownId = t.Id
GROUP BY t.Name
HAVING COUNT(a.Id) in (2,3)
ORDER BY t.Name


SELECT COUNT(a.id) as AdsCount, ISNULL(t.Name, '(no town)') as Town
FROM Towns t
RIGHT JOIN ads a on a.TownId = t.Id
GROUP BY t.name
HAVING COUNT(a.Id) BETWEEN 2 AND 3
ORDER BY t.Name

--15---------------------------------------------------------------

SELECT a1.Date as FirstDate, a2.Date as SecondDate
FROM Ads a1, Ads a2
WHERE a1.Date < a2.Date
and DATEDIFF(HOUR, a1.date, a2.date) < 12
ORDER BY FirstDate, SecondDate 

--16---------------------------------------------------------------

CREATE TABLE Countries(
	Id INT IDENTITY NOT NULL,
	Name nvarchar(100) NOT NULL
	CONSTRAINT PK_Countries PRIMARY KEY(Id)
)
GO

ALTER TABLE Towns ADD CountryId INT
GO

ALTER TABLE Towns ADD CONSTRAINT FK_Towns_Countries
FOREIGN KEY (CountryId) REFERENCES Countries(Id)
GO

INSERT INTO Countries(Name) VALUES ('Bulgaria'), ('Germany'), ('France')
UPDATE Towns SET CountryId = (SELECT Id FROM Countries WHERE Name='Bulgaria')
INSERT INTO Towns VALUES
('Munich', (SELECT Id FROM Countries WHERE Name='Germany')),
('Frankfurt', (SELECT Id FROM Countries WHERE Name='Germany')),
('Berlin', (SELECT Id FROM Countries WHERE Name='Germany')),
('Hamburg', (SELECT Id FROM Countries WHERE Name='Germany')),
('Paris', (SELECT Id FROM Countries WHERE Name='France')),
('Lyon', (SELECT Id FROM Countries WHERE Name='France')),
('Nantes', (SELECT Id FROM Countries WHERE Name='France'))

UPDATE Ads 
SET TownId = (SELECT t.Id FROM Towns t WHERE t.Name = 'Paris')
WHERE DATENAME(dw,Date) = 'friday'

UPDATE Ads 
SET TownId = (SELECT t.Id FROM Towns t WHERE t.Name = 'Hamburg')
WHERE DATENAME(dw,Date) = 'thursday'

DELETE FROM Ads 
WHERE OwnerId in (SELECT u.Id
					FROM AspNetRoles r
					JOIN AspNetUserRoles ur on r.Id = ur.RoleId
					JOIN AspNetUsers u on ur.UserId = u.Id
					WHERE r.name = 'partner')

INSERT INTO ads (Title, Text, Date, OwnerId, StatusId)
VALUES ('Free Book','Free C# Book', GETDATE(),
		(SELECT u.Id
		FROM AspNetUsers u
		WHERE u.Name = 'nakov'),
		(SELECT s.Id 
		FROM AdStatuses s
		WHERE s.Status = 'Waiting Approval'))

SELECT t.Name as [Town], c.Name as [Country], COUNT(a.Id) as [AdsCount]
FROM ads a 
FULL OUTER JOIN Towns t on t.Id = a.TownId
FULL OUTER JOIN Countries c on t.CountryId = c.Id
GROUP BY t.Name, c.Name
ORDER BY t.Name, c.Name

--17---------------------------------------------------------------

CREATE VIEW AllAds as
	SELECT a.Id, a.Title, lower(u.Name) as Author, a.Date, t.Name as Town, c.Name as CateGOry, s.Status
	FROM ads a
	LEFT JOIN AspNetUsers u on a.OwnerId = u.Id
	LEFT JOIN Towns t on a.TownId = t.Id
	LEFT JOIN CateGOries c on a.CateGOryId = c.Id
	LEFT JOIN AdStatuses s on a.StatusId = s.Id
GO

CREATE FUNCTION fn_ListUsersAds() RETURNS @TABLEUserADDs TABLE(
UserName NVARCHAR(MAX),
ADDates NVARCHAR(MAX)
)
AS
BEGIN 
	DECLARE usersCursor CURSOR FOR
		SELECT UserName FROM AspNetUsers
		ORDER BY UserName DESC
	OPEN usersCursor

	DECLARE @userName NVARCHAR(MAX)
	FETCH NEXT FROM usersCursor INTO @userName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @adsDate NVARCHAR(MAX) = NULL
		SELECT @adsDate = CASE 
			WHEN @adsDate IS NULL THEN CONVERT(nvarchar(max), Date, 112)
			ELSE @adsDate + '; ' + CONVERT(nvarchar(max), Date, 112)
		END
		FROM AllAds
		WHERE Author = @userName
		ORDER BY Date

		INSERT INTO @TABLEUserADDs
		VALUES(@userName, @adsDate)

		FETCH NEXT FROM usersCursor INTO @userName
	END

	CLOSE usersCursor
	DEALLOCATE usersCursor
	RETURN
END
GO

SELECT * FROM fn_ListUsersAds()