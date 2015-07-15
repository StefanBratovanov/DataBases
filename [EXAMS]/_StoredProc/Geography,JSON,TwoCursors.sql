IF OBJECT_ID('fn_MountainsPeaks') IS NOT NULL
  DROP FUNCTION fn_MountainsPeaks
GO

CREATE FUNCTION fn_MountainsPeaks()
	RETURNS NVARCHAR(max)
AS
BEGIN
	DECLARE @json NVARCHAR(max) = '{"mountains":['

	DECLARE mountainsCursor CURSOR FOR
	SELECT id, MountainRange
	FROM Mountains

	OPEN mountainsCursor
	DECLARE @mountainName NVARCHAR(max)
	DECLARE @mountainId INT

	FETCH NEXT FROM mountainsCursor INTO @mountainId, @mountainName
	WHILE @@FETCH_STATUS = 0
		BEGIN
		SET @json = @json + '{"name":"' + @mountainName + '","peaks":['

		DECLARE peaksCursor CURSOR FOR 
		SELECT PeakName, Elevation
		FROM Peaks
		WHERE MountainId = @mountainId

		OPEN peaksCursor
		DECLARE @peakName NVARCHAR(max)
		DECLARE @peakElevation INT

		FETCH NEXT FROM peaksCursor INTO @peakName, @peakElevation
		WHILE @@FETCH_STATUS = 0
			BEGIN
			SET @json = @json + '{"name":"' + @peakName + '",'+
								'"elevation":' + CONVERT(NVARCHAR(max), @peakElevation) + '}'

			FETCH NEXT FROM peaksCursor INTO @peakName, @peakElevation
			IF @@FETCH_STATUS = 0
				SET @json = @json + ','
			END

			CLOSE peaksCursor
			DEALLOCATE peaksCursor

			SET @json = @json + ']}'

	FETCH NEXT FROM mountainsCursor INTO @mountainId, @mountainName
		IF @@FETCH_STATUS = 0
			SET @json = @json + ','
		END
	
	CLOSE mountainsCursor
		DEALLOCATE mountainsCursor

		SET @json = @json + ']}'
	RETURN @json
END
GO

SELECT dbo.fn_MountainsPeaks()