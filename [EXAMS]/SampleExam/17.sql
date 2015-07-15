CREATE VIEW AllAds as
	SELECT a.Id, a.Title, lower(u.Name) as Author, a.Date, t.Name as Town, c.Name as CateGOry, s.Status
	FROM ads a
	LEFT JOIN AspNetUsers u on a.OwnerId = u.Id
	LEFT JOIN Towns t on a.TownId = t.Id
	LEFT JOIN CateGOries c on a.CateGOryId = c.Id
	LEFT JOIN AdStatuses s on a.StatusId = s.Id
GO

CREATE FUNCTION fn_ListUsersAds()
	RETURNS @tbl_UsersAds TABLE(
		UserName NVARCHAR(MAX),
		AdDates NVARCHAR(MAX)
	)
AS
BEGIN
	DECLARE UsersCursor CURSOR FOR
		SELECT UserName FROM AspNetUsers
		ORDER BY UserName DESC;
	OPEN UsersCursor;
	DECLARE @username NVARCHAR(MAX);
	FETCH NEXT FROM UsersCursor INTO @username;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @ads NVARCHAR(MAX) = NULL;
		SELECT
			@ads = CASE
				WHEN @ads IS NULL THEN CONVERT(NVARCHAR(MAX), Date, 112)
				ELSE @ads + '; ' + CONVERT(NVARCHAR(MAX), Date, 112)
			END
		FROM AllAds
		WHERE Author = @username
		ORDER BY Date;

		INSERT INTO @tbl_UsersAds
		VALUES(@username, @ads)
		
		FETCH NEXT FROM UsersCursor INTO @username;
	END;
	CLOSE UsersCursor;
	DEALLOCATE UsersCursor;
	RETURN;
END
GO

SELECT * FROM fn_ListUsersAds()