select PeakName from Peaks
order by PeakName

--2-----------------------------------------------------

select top 30 c.CountryName, c.Population 
from Countries c
where c.ContinentCode = 'eu'
order by c.Population desc, c.CountryName

--3-----------------------------------------------------

select  c.CountryName, c.CountryCode, Currency = case c.CurrencyCode
	WHEN 'Eur' then 'Euro'
	ELSE 'Not Euro'
	End
from Countries c
order by c.CountryName

--4-----------------------------------------------------

select c.CountryName as [Country Name] , c.IsoCode as [ISO Code]
from Countries c 
where c.CountryName like '%a%a%a%'
order by c.IsoCode

--5-----------------------------------------------------

select p.PeakName, m.MountainRange as Mountain, p.Elevation
 from Peaks p join Mountains m on p.MountainId = m.Id
 order by p.Elevation desc

--6-----------------------------------------------------

select p.PeakName, m.MountainRange as Mountain, c.CountryName, ct.ContinentName
from Peaks p 
join Mountains m on p.MountainId = m.Id
join MountainsCountries mc on m.Id = mc.MountainId
join Countries c on mc.CountryCode = c.CountryCode
join Continents ct on c.ContinentCode = ct.ContinentCode
order by p.PeakName, c.CountryName

--7-----------------------------------------------------

select r.RiverName as River, COUNT(cr.CountryCode) as [Countries Count]
from Rivers r 
join CountriesRivers cr on cr.RiverId  = r.Id
join Countries c on cr.CountryCode = c.CountryCode
group by r.RiverName
having COUNT(r.RiverName) >= 3
order by r.RiverName

--8-----------------------------------------------------

select MAX(p.Elevation) as MaxElevation, MIN(p.Elevation) as MinElevation, AVG(p.Elevation) as AverageElevation
from Peaks p 

--9-----------------------------------------------------

select c.CountryName, ct.ContinentName, COUNT(r.Id) as RiversCount,isnull(sum(r.Length), 0) as TotalLength
from Countries c 
left join CountriesRivers cr on cr.CountryCode = c.CountryCode
left join Rivers r on  cr.RiverId = r.Id
left join Continents ct on c.ContinentCode = ct.ContinentCode
group by c.CountryName, ct.ContinentName
order by COUNT(r.Id) desc, TotalLength desc, c.CountryName

--10-----------------------------------------------------

select cur.CurrencyCode, cur.Description as Currency , count(c.CurrencyCode) as NumberOfCountries
from Currencies cur 
left join Countries c on c.CurrencyCode = cur.CurrencyCode
group by cur.CurrencyCode, cur.Description
order by count(c.CurrencyCode) desc, cur.Description

--11-----------------------------------------------------

select con.ContinentName, sum(c.AreaInSqKm) as CountriesArea, sum(CAST(c.Population as bigint)) as CountriesPopulation
from Continents con 
left join Countries c on con.ContinentCode = c.ContinentCode
group by con.ContinentName
order by CountriesPopulation desc

--12-----------------------------------------------------

select c.CountryName, max(p.Elevation) as HighestPeakElevation, max(r.Length) as LongestRiverLength
from Countries c 
left join MountainsCountries mc on mc.CountryCode = c.CountryCode
left join Mountains m on m.Id = mc.MountainId
left join Peaks p on p.MountainId = mc.MountainId 
left join CountriesRivers cr on cr.CountryCode = c.CountryCode
left join Rivers r on cr.RiverId = r.Id
group by c.CountryName
order by HighestPeakElevation desc, LongestRiverLength desc, c.CountryName

--13-----------------------------------------------------

select p.PeakName, r.RiverName,lower(SUBSTRING(p.PeakName, 1 , len(p.PeakName) -1)) + lower(SUBSTRING(r.RiverName, 1, len(r.RiverName))) as Mix
from Peaks p , Rivers r
where SUBSTRING(p.PeakName, len(p.PeakName) , 1) = SUBSTRING(r.RiverName, 1, 1)
order by Mix

--14-----------------------------------------------------

select c.CountryName as Country,
		p.PeakName as [Highest Peak Name],
		p.Elevation as [Highest Peak Elevation], 
		m.MountainRange as Mountain
from Countries c 
left join MountainsCountries mc on mc.CountryCode = c.CountryCode
left join Mountains m on m.Id = mc.MountainId
left join Peaks p on p.MountainId = mc.MountainId 
where p.Elevation = (select max(p.Elevation)
					from Peaks p
					left join Mountains m on m.Id = p.MountainId
					left join MountainsCountries mc on mc.MountainId = m.Id
					where mc.CountryCode = c.CountryCode )
union 

select c.CountryName as Country,
		'(no highest peak)' as [Highest Peak Name],
		0 as [Highest Peak Elevation], 
		'(no mountain)' as Mountain
from Countries c 
left join MountainsCountries mc on mc.CountryCode = c.CountryCode
left join Mountains m on m.Id = mc.MountainId
left join Peaks p on p.MountainId = mc.MountainId 
where (select max(p.Elevation)
					from Peaks p
					left join Mountains m on m.Id = p.MountainId
					left join MountainsCountries mc on mc.MountainId = m.Id
					where mc.CountryCode = c.CountryCode ) is null
order by c.CountryName, [Highest Peak Name]

-----------------

select c.CountryName as Country,
	case
		 when max(isnull(p.Elevation, 0)) = 0 then '(no highest peak)'
		 else (select PeakName from Peaks 
			  where Elevation = max(isnull(p.Elevation, 0)))
	end	 as [Highest Peak Name],
	max(isnull(p.Elevation, 0)) as [Highest Peak Elevation], 
	case 
		 when max(isnull(p.Elevation, 0)) = 0 then '(no mountain)'
		 else (select Mountains.MountainRange from Mountains   
			  left join Peaks  on Peaks.MountainId = Mountains.Id
			  where Peaks.Elevation = max(isnull(p.Elevation, 0)))
	end	 as Mountain
from Countries c 
left join MountainsCountries mc on mc.CountryCode = c.CountryCode
left join Mountains m on m.Id = mc.MountainId
left join Peaks p on p.MountainId = m.Id
group by c.CountryName
order by c.CountryName, [Highest Peak Elevation]

------

SELECT
	c.CountryName AS Country,
	ISNULL((SELECT pe.PeakName FROM Peaks pe
			WHERE pe.Elevation = (SELECT MAX(pp.Elevation)
										FROM Countries cc
										LEFT JOIN MountainsCountries mmcc
											ON cc.CountryCode = mmcc.CountryCode
										LEFT JOIN Mountains mm
											ON mmcc.MountainId = mm.Id
										LEFT JOIN Peaks pp
											ON mm.Id = pp.MountainId
										WHERE cc.CountryName = c.CountryName
			)), '(no highest peak)') AS [Highest Peak Name],
	ISNULL(MAX(p.Elevation), 0)      AS [Highest Peak Elevation],
	ISNULL((SELECT mm.MountainRange FROM Mountains mm
			WHERE mm.Id = (SELECT pe.MountainId
									FROM Peaks pe
									WHERE pe.Elevation = (SELECT MAX(pp.Elevation)
														FROM Countries cc
														LEFT JOIN MountainsCountries mmcc
															ON cc.CountryCode = mmcc.CountryCode
														LEFT JOIN Mountains mm
															ON mmcc.MountainId = mm.Id
														LEFT JOIN Peaks pp
															ON mm.Id = pp.MountainId
															WHERE cc.CountryName = c.CountryName
															))), '(no mountain)') AS Mountain
FROM Countries c
LEFT JOIN MountainsCountries mc
	ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains m
	ON mc.MountainId = m.Id
LEFT JOIN Peaks p
	ON m.Id = p.MountainId
GROUP BY c.CountryName
ORDER BY c.CountryName, [Highest Peak Name]

--15-----------------------------------------------------

CREATE TABLE Monasteries(
	Id INT IDENTITY NOT NULL,
	Name nvarchar(100) NOT NULL,
	CountryCode char(2) not null
	CONSTRAINT PK_Monastries PRIMARY KEY(Id)
)
GO

drop table Monasteries

ALTER TABLE Monasteries ADD CONSTRAINT FK_Monastries_Countries
FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode)
GO

--ALTER TABLE Countries ADD IsDeleted BIT NOT NULL DEFAULT 0
ALTER TABLE Countries ADD IsDeleted BIT DEFAULT 0
UPDATE Countries SET  IsDeleted = 0 WHERE IsDeleted IS NULL
GO



UPDATE Countries 
SET IsDeleted = 1
WHERE CountryName IN ( SELECT c.CountryName
			  FROM Countries c
			  left join CountriesRivers cr on cr.CountryCode = c.CountryCode
			  left join Rivers r on  cr.RiverId = r.Id
			  GROUP BY c.CountryName
			  HAVING COUNT(r.Id) > 3)

select m.Name as Monastery , c.CountryName as Country
from Monasteries m
left join Countries c on m.CountryCode = c.CountryCode
where c.IsDeleted = 'false'    --where c.IsDeleted = 0
order by m.Name 

--16-----------------------------------------------------


UPDATE Countries 
SET CountryName = 'Burma' where CountryName = (select c.CountryName from Countries c where c.CountryName = 'Myanmar')

INSERT INTO Monasteries (Name, CountryCode)
values ('Hanga Abbey', 
		(select c.CountryCode from Countries c where c.CountryName = 'Tanzania'))

INSERT INTO Monasteries (Name, CountryCode)
values ('Myin-Tin-Daik', 
		(select c.CountryCode from Countries c where c.CountryName = 'Myanmar'))

--delete from Monasteries where  name = 'Myin-Tin-Daik'

select ct.ContinentName,c.CountryName, COUNT(distinct m.Id) as MonasteriesCount
from Continents ct
left join Countries c on c.ContinentCode = ct.ContinentCode
left join Monasteries m on m.CountryCode = c.CountryCode
where c.IsDeleted = 0
group by ct.ContinentName, c.CountryName
order by MonasteriesCount desc, c.CountryName

--17-----------------------------------------------------

IF OBJECT_ID('fn_MountainsPeaks') IS NOT NULL
  DROP FUNCTION fn_MountainsPeaks
GO

create function fn_MountainsPeaks()
	returns nvarchar(max)
as
begin
	declare @json nvarchar(max) = '{"mountains":['

	declare mountainsCursor CURSOR for
	select id, MountainRange
	from Mountains

	open mountainsCursor
	declare @mountainName nvarchar(max)
	declare @mountainId int

	fetch next from mountainsCursor into @mountainId, @mountainName
	while @@FETCH_STATUS = 0
		begin
		set @json = @json + '{"name":"' + @mountainName + '","peaks":['

		declare peaksCursor CURSOR for 
		select PeakName, Elevation
		from Peaks
		where MountainId = @mountainId

		open peaksCursor
		declare @peakName nvarchar(max)
		declare @peakElevation int

		fetch next from peaksCursor into @peakName, @peakElevation
		while @@FETCH_STATUS = 0
			begin
			set @json = @json + '{"name":"' + @peakName + '",'+
			'"elevation":' + CONVERT(nvarchar(max), @peakElevation) + '}'
			fetch next from peaksCursor into @peakName, @peakElevation
			if @@FETCH_STATUS = 0
				set @json = @json + ','
			end

			close peaksCursor
			deallocate peaksCursor

			set @json = @json + ']}'

	fetch next from mountainsCursor into @mountainId, @mountainName
		if @@FETCH_STATUS = 0
			set @json = @json + ','
		end
	
	close mountainsCursor
		deallocate mountainsCursor

		set @json = @json + ']}'
	return @json
end
go

select dbo.fn_MountainsPeaks()