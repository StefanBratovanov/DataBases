SELECT TeamName FROM Teams
ORDER BY TeamName
--2--------------------------------------

SELECT top 50 c.CountryName, c.PopulatiON FROM Countries c
ORDER BY c.PopulatiON desc, c.CountryName 

--3--------------------------------------

SELECT  c.CountryName, c.CountryCode, EurozONe = CASE c.CurrencyCode
	WHEN 'Eur' then 'Inside'
	ELSE 'Outside'
	END
FROM Countries c
ORDER BY c.CountryName 

--4--------------------------------------

SELECT t.TeamName AS [Team Name], t.CountryCode AS [Country Code]
FROM Teams t
WHERE t.TeamName like '%[0-9]%'
ORDER BY t.CountryCode


--5--------------------------------------

SELECT ho.CountryName AS [Home Team], aw.CountryName [Away Team], im.MatchDate AS [Match Date]
FROM Countries ho, Countries aw, InternatiONalMatches im
WHERE ho.CountryCode = im.HomeCountryCode and aw.CountryCode = im.AwayCountryCode
ORDER BY im.MatchDate desc
--
SELECT
  c1.CountryName AS [Home Team],
  c2.CountryName AS [Away Team],
  MatchDate AS [Match Date]
FROM InternationalMatches im
JOIN Countries c1 ON im.HomeCountryCode = c1.CountryCode
JOIN Countries c2 ON im.AwayCountryCode = c2.CountryCode
ORDER BY MatchDate DESC

--6--------------------------------------

SELECT 
t.TeamName AS [Team Name],
l.LeagueName AS [League],
[League Country] =  CASE 
	WHEN l.CountryCode is null then 'International'
	ELSE c.CountryName
	END 
FROM Teams t
left JOIN Leagues_Teams lt ON t.Id = lt.TeamId
left JOIN Leagues l ON lt.LeagueId = l.Id
left JOIN Countries c ON l.CountryCode = c.CountryCode
ORDER BY t.TeamName,l.LeagueName

--7--------------------------------------

SELECT t.TeamName AS [Team], COUNT(t.Id) AS [Matches Count]
FROM Teams t
	JOIN TeamMatches tm ON t.Id = tm.HomeTeamId OR t.Id = tm.AwayTeamId
GROUP BY t.Id,t.TeamName 
HAVING COUNT(t.Id) > 1
ORDER BY t.TeamName

--8--------------------------------------???????

SELECT l.LeagueName AS [League Name],
	COUNT(DISTINCT lt.TeamId) AS Teams,
	COUNT (DISTINCT tm.Id) AS Matches ,
	ISNULL(AVG(tm.HomeGoals + tm.AwayGoals),0) AS [Average Goals]
FROM Leagues l 
LEFT JOIN TeamMatches tm ON l.Id = tm.LeagueId
LEFT JOIN Leagues_Teams lt ON l.Id = lt.LeagueId
GROUP BY l.LeagueName
ORDER BY  Teams DESC, Matches DESC 

--9--------------------------------------

SELECT
t.TeamName ,
	ISNULL((SELECT SUM(tm.HomeGoals) FROM TeamMatches tm WHERE tm.HomeTeamId = t.Id), 0) + 
    ISNULL((SELECT SUM(tm.AwayGoals) FROM TeamMatches tm WHERE tm.AwayTeamId = t.Id), 0) AS [Total Goals]
FROM Teams t
ORDER BY [Total Goals] DESC, t.TeamName


--Wrong--SELECT t.TeamName as [Team Name], (ISNULL(sum(tmH.HomeGoals),0) + ISNULL(sum(tmA.AwayGoals),0)) as [Total Goals]
--FROM Teams t
--left join TeamMatches tmH on t.Id = tmH.HomeTeamId
--left join TeamMatches tmA on t.Id = tmA.AwayTeamId
--group by t.TeamName
--ORDER BY [Total Goals] desc, t.TeamName 



--10--------------------------------------

SELECT tmFd.MatchDate AS [First Date], tmSd.MatchDate AS [Second Date]
FROM TeamMatches tmFd, TeamMatches tmSd
WHERE tmFd.MatchDate < tmSd.MatchDate and DATEDIFF(DAY,tmFd.MatchDate,tmSd.MatchDate) < 1
ORDER BY tmFd.MatchDate DESC,tmSd.MatchDate DESC

--11--------------------------------------

SELECT LOWER(SUBSTRING(t1.TeamName, 1, LEN(t1.TeamName) - 1)) + LOWER(SUBSTRING(REVERSE(t2.TeamName), 1, LEN(t2.TeamName))) AS Mix
FROM Teams t1, Teams t2
WHERE SUBSTRING(t1.TeamName, LEN(t1.TeamName) , 1) = SUBSTRING(REVERSE(t2.TeamName),1,1)  --WHERE RIGHT(t1.TeamName, 1) = RIGHT(t2.TeamName, 1)
ORDER BY Mix

--12--------------------------------------

SELECT  c.CountryName AS [Country Name], 
		COUNT(DISTINCT imHome.Id) + COUNT(DISTINCT imAway.ID) AS [International Matches],
		COUNT(DISTINCT tm.Id) AS [Team Matches]
FROM Countries c
LEFT JOIN InternationalMatches imHome ON c.CountryCode = imHome.HomeCountryCode
LEFT JOIN InternationalMatches imAway ON c.CountryCode = imAway.AwayCountryCode
LEFT JOIN Leagues l ON c.CountryCode = l.CountryCode
LEFT JOIN TeamMatches tm ON l.Id = tm.LeagueId
GROUP BY c.CountryName, tm.LeagueId
HAVING COUNT(DISTINCT imHome.Id) + COUNT(DISTINCT imAway.Id) >= 1 OR COUNT(DISTINCT tm.id) >= 1
ORDER BY [International Matches] DESC, [Country Name]

--13--------------------------------------

create table FriendlyMatches(
	Id int identity not null,
	HomeTeamId int ,
	AwayTeamId int,
	MatchDate datetime
	CONSTRAINT PK_FriendlyMatches PRIMARY KEY(Id)
	CONSTRAINT FK_FriendlyMatches_Teams FOREIGN KEY(Id) REFERENCES Teams(Id))

	INSERT INTO Teams(TeamName) VALUES
 ('US All Stars'),
 ('Formula 1 Drivers'),
 ('Actors'),
 ('FIFA Legends'),
 ('UEFA Legends'),
 ('Svetlio & The Legends')
GO

INSERT INTO FriendlyMatches(
  HomeTeamId, AwayTeamId, MatchDate) VALUES
  
((SELECT Id FROM Teams WHERE TeamName='US All Stars'), 
 (SELECT Id FROM Teams WHERE TeamName='Liverpool'),
 '30-Jun-2015 17:00'),
 
((SELECT Id FROM Teams WHERE TeamName='Formula 1 Drivers'), 
 (SELECT Id FROM Teams WHERE TeamName='Porto'),
 '12-May-2015 10:00'),
 
((SELECT Id FROM Teams WHERE TeamName='Actors'), 
 (SELECT Id FROM Teams WHERE TeamName='Manchester United'),
 '30-Jan-2015 17:00'),

((SELECT Id FROM Teams WHERE TeamName='FIFA Legends'), 
 (SELECT Id FROM Teams WHERE TeamName='UEFA Legends'),
 '23-Dec-2015 18:00'),

((SELECT Id FROM Teams WHERE TeamName='Svetlio & The Legends'), 
 (SELECT Id FROM Teams WHERE TeamName='Ludogorets'),
 '22-Jun-2015 21:00')

GO

SELECT ho.TeamName AS [Home Team], aw.TeamName [Away Team], fm.MatchDate [Match Date]
FROM Teams ho, Teams aw, FriendlyMatches fm
WHERE ho.Id = fm.HomeTeamId AND aw.Id = fm.AwayTeamId
UNION 
SELECT ho.TeamName AS [Home Team], aw.TeamName [Away Team], tm.MatchDate [Match Date]
FROM Teams ho, Teams aw, TeamMatches tm
WHERE ho.Id = tm.HomeTeamId AND aw.Id = tm.AwayTeamId
ORDER BY fm.MatchDate DESC
GO
--14--------------------------------------

ALTER TABLE Leagues ADD IsSeasonal BIT DEFAULT 0  --ALTER TABLE Leagues ADD IsSeasonal BIT NOT NULL DEFAULT 0

UPDATE Leagues SET  IsSeasonal = 0 WHERE IsSeasonal IS NULL
GO
--

INSERT INTO TeamMatches (HomeTeamId, AwayTeamId, HomeGoals, AwayGoals, MatchDate,LeagueId)
values ((select t.Id from Teams t where t.TeamName = 'Empoli'), 
		(select t.Id from Teams t where t.TeamName = 'Parma'),
		 2, 
		 2, 
		 '19-Apr-2015 16:00',
		 (select l.Id from Leagues l where l.LeagueName = 'Italian Serie A'))

INSERT into TeamMatches (HomeTeamId, AwayTeamId, HomeGoals, AwayGoals, MatchDate,LeagueId)
values ((select t.Id from Teams t where t.TeamName = 'Internazionale'), 
		(select t.Id from Teams t where t.TeamName = 'AC Milan'),
		 0, 
		 0, 
		 '19-Apr-2015 21:45',
		 (select l.Id from Leagues l where l.LeagueName = 'Italian Serie A'))

UPDATE Leagues 
SET IsSeasonal = 1
WHERE Id IN ( SELECT l.Id
			  FROM Leagues l
			  JOIN TeamMatches tm ON l.Id = tm.LeagueId
			  GROUP BY L.Id
			  HAVING COUNT(DISTINCT tm.Id) > 0)


SELECT tH.TeamName as [Home Team], tm.HomeGoals AS [Home Goals], tA.TeamName  AS [Away Team], tm.AwayGoals AS [Away Goals], l.LeagueName AS [League Name]
FROM TeamMatches tm
JOIN Teams tH on tm.HomeTeamId = tH.Id
JOIN Teams tA on tm.AwayTeamId = tA.Id
JOIN Leagues l on tm.LeagueId = l.Id
WHERE l.IsSeasonal = 1
AND tm.MatchDate > '2015-04-10'
ORDER BY [League Name], [Home Goals] DESC, [Away Goals] DESC
GO
--15--------------------------------------

CREATE FUNCTION fn_TeamsJSON() RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @output NVARCHAR(MAX) = '{"teams":['
	DECLARE teamCursor CURSOR FOR
	SELECT id, TeamName
	FROM Teams
	WHERE CountryCode = 'BG'
	ORDER BY TeamName

	OPEN teamCursor
	DECLARE @teamId INT
	DECLARE @teamName NVARCHAR(MAX)
	
	FETCH NEXT FROM teamCursor INTO @teamId, @teamName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @output = @output + '{"name":"' + @teamName + '","matches":['

		DECLARE matchesCursor CURSOR FOR
		SELECT tH.TeamName, tm.HomeGoals, tA.TeamName, tm.AwayGoals, tm.MatchDate 
		FROM TeamMatches tm
		LEFT JOIN Teams tH on tm.HomeTeamId = tH.Id
		LEFT JOIN Teams tA on tm.AwayTeamId = tA.Id 
		WHERE tm.HomeTeamId = @teamId OR tm.AwayTeamId = @teamId
		ORDER BY tm.MatchDate DESC

		OPEN matchesCursor
		DECLARE @homeTeamName NVARCHAR(MAX)
		DECLARE @awayTeamName NVARCHAR(MAX)
		DECLARE @homeTeamGoals INT
		DECLARE @awayTeamGoals INT
		DECLARE @matchDate DATE

		FETCH NEXT FROM matchesCursor INTO @homeTeamName, @homeTeamGoals, @awayTeamName, @awayTeamGoals, @matchDate
		WHILE @@FETCH_STATUS = 0
			BEGIN
			SET @output = @output + '{"' + @homeTeamName + '":' + CONVERT(NVARCHAR(MAX),@homeTeamGoals) + ',"' +
										   @awayTeamName + '":' + CONVERT(NVARCHAR(MAX),@awayTeamGoals) + ',' +
										   '"date":' + CONVERT(NVARCHAR(MAX), @matchDate, 103) + '}'

			FETCH NEXT FROM matchesCursor INTO @homeTeamName, @homeTeamGoals, @awayTeamName, @awayTeamGoals, @matchDate
			IF @@FETCH_STATUS = 0
				SET @output = @output + ','
			END
		
		CLOSE matchesCursor
		DEALLOCATE matchesCursor
		SET @output = @output + ']}'

		FETCH NEXT FROM teamCursor INTO @teamId, @teamName
		IF @@FETCH_STATUS = 0
			SET @output = @output + ','
		END

		CLOSE teamCursor
		DEALLOCATE teamCursor

	SET @output = @output + ']}'
	RETURN @output
END
GO

--drop function fn_TeamsJSON

SELECT  dbo.fn_TeamsJSON()