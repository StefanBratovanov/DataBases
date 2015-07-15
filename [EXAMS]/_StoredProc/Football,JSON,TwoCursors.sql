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