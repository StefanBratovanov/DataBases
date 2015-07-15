select TeamName from Teams
order by TeamName

--2-----------------------------------------

select top 50 CountryName, Population from Countries
order by Population desc, CountryName 

--3-----------------------------------------

select c.CountryName, c.CountryCode, [Eurozone] = (case c.CurrencyCode 
	when 'eur' then 'Inside'
	else 'Outside'
	end)
from Countries c
order by c.CountryName

--4-----------------------------------------

select TeamName as [Team Name],  CountryCode as [Country Code] from Teams
where TeamName like '%[0-9]%'
order by CountryCode

--5-----------------------------------------

select ch.CountryName as [Home Team], ca.CountryName as [Away Team], im.MatchDate as [Match Date]
from Countries Ch, Countries Ca, InternationalMatches im
where Ch.CountryCode = im.HomeCountryCode and Ca.CountryCode = im.AwayCountryCode
order by [Match Date] desc

--6-----------------------------------------

select t.TeamName as [Team Name],  l.LeagueName as League, isnull(c.CountryName, 'International') as [League Country]
from Teams t 
left join Leagues_Teams lt on lt.TeamId = t.Id
left join Leagues l on lt.LeagueId = l.Id
left join Countries c on c.CountryCode = l.CountryCode
order by t.TeamName, l.LeagueName

--7-----------------------------------------

select t.TeamName as Team, count(t.id) as [Matches Count]
from Teams t 
left join TeamMatches tm on tm.HomeTeamId = t.Id or tm.AwayTeamId = t.id
group by t.TeamName
having count(t.id) > 1
order by t.TeamName

--8-----------------------------------------

select l.LeagueName as [League Name], 
COUNT(distinct lt.TeamId) as Teams, 
COUNT(distinct tm.id) as Matches,
isnull(avg(tm.HomeGoals + tm.AwayGoals), 0) as [Average Goals]
from Leagues l
left join Leagues_Teams lt  on lt.LeagueId = l.Id
left join TeamMatches tm on tm.LeagueId = l.Id
group by l.LeagueName
order by Teams desc, Matches desc

--9-----------------------------------------

select t.TeamName,
isnull((select sum(tm.HomeGoals)from TeamMatches tm where tm.HomeTeamId = t.id),0)+
isnull((select sum(tm.AwayGoals)from TeamMatches tm where tm.AwayTeamId = t.id),0) as [Total Goals]
from Teams t 
order by [Total Goals] desc, t.TeamName

--10-----------------------------------------

select tmFD.MatchDate as [First Date], tmSD.MatchDate as [Second Date]
from TeamMatches tmFD, TeamMatches tmSD
where tmFD.MatchDate < tmSD.MatchDate 
and DATEDIFF(day, tmFD.MatchDate, tmSD.MatchDate) < 1
ORDER BY tmFD.MatchDate DESC, tmSD.MatchDate DESC

--11-----------------------------------------

SELECT LOWER(SUBSTRING(t1.TeamName, 1, LEN(t1.TeamName) - 1)) + LOWER(SUBSTRING(REVERSE(t2.TeamName), 1, LEN(t2.TeamName))) AS Mix
FROM Teams t1, Teams t2
WHERE RIGHT(t1.TeamName, 1) = SUBSTRING(REVERSE(t2.TeamName), 1, 1)
ORDER BY Mix

--12-----------------------------------------

