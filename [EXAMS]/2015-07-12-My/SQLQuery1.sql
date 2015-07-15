

select TOP 50 g.Name ,  CAST(g.Start AS DATE) as Start
from Games g
where YEAR(g.Start) = 2011 OR  YEAR(g.Start) = 2012
order by g.Start, g.Name
--2

select TOP 50 g.Name as Game ,  CONVERT(nvarchar(10), g.Start, 126) as Start
from Games g
where YEAR(g.Start) = '2011' OR  YEAR(g.Start) = '2012'
order by g.Start, g.Name

--3--

select Username,SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) as [Email Provider]
from Users
order by [Email Provider], username

--4--
select Username, IpAddress as [IP Address]
 from users
 where IpAddress like '___.1_%._%.___'
 order by Username

 --5

 select g.Name as Game,[Part of the Day] = CASE 
	WHEN DATEPART(HOUR, g.Start) >= 18   then 'Evening'
	else case 
	WHEN DATEPART(HOUR, g.Start) >= 0 and DATEPART(HOUR, g.Start) <  12   then 'Morning'
	else   'Afternoon'
	end
	END ,
	[Duration] =  CASE 
	WHEN g.Duration   <=  3   then 'Extra Short'
	else case 
	WHEN g.Duration >= 4  and g.Duration <=  6  then 'Short'
	else case 
	WHEN g.Duration > 6   then 'Long'
	else 'Extra Long'
	end
	END
	end
from Games g
order by g.name,[Duration], [Part of the Day]

--06

select  SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) as [Email Provider], count(Email) as [Number Of Users]
from Users
group by SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email))
order by [Number Of Users] desc, [Email Provider]

--7

select g.Name as Game, gt.Name as [Game Type], u.Username, ug.Level, ug.Cash, c.Name as Character
from Users u 
left join UsersGames ug on ug.UserId = u.Id
left join games g on ug.GameId = g.Id
left join GameTypes gt on g.GameTypeId = gt.Id
left join characters c on ug.CharacterId = c.Id
order by ug.Level desc,  u.Username, g.Name

--8

select u.Username, g.Name as Game, count(ugi.ItemId) as [Items Count], sum(i.Price) as [Items Price]
from Users u 
left join UsersGames ug on ug.UserId = u.Id
left join games g on ug.GameId = g.Id
left join UserGameItems ugi on ugi.UserGameId = ug.id
left join Items i on ugi.ItemId = i.Id
group by g.Name, u.Username
order by  [Items Count] desc, [Items Price] desc, u.Username


select u.Username, g.Name as Game, count(ugi.ItemId) as [Items Count], sum(i.Price) as [Items Price]
from games g
left join GameTypes gt on g.GameTypeId = gt.Id
left join UsersGames ug on ug.GameId = g.Id
left join Users u on ug.UserId = u.Id
left join UserGameItems ugi on ugi.UserGameId = ug.Id
join Items i on ugi.ItemId = i.Id
group by g.Name, u.Username 
having count(ugi.ItemId) >= 10
order by  [Items Count] desc, [Items Price] desc, u.Username

--10

select i.Name, i.Price, i.MinLevel, s.Strength, s.Defence, s.Speed, s.Luck, s.Mind
 from items i 
 left join [Statistics] s on i.StatisticId = s.id
 group by i.Name, i.Price, i.MinLevel, s.Strength, s.Defence, s.Speed, s.Luck, s.Mind
 having s.Mind > (select avg(st.Mind) from [Statistics] st) 
 and s.Luck > (select avg(st.Luck) from [Statistics] st) 
 and s.Speed > (select avg(st.Speed) from [Statistics] st) 
 order by i.name

 --11

 select i.Name as Item, i.Price, i.MinLevel , gt.name as [Forbidden Game Type]
 from items i 
left join GameTypeForbiddenItems fi on fi.ItemId = i.Id
left join GameTypes gt on fi.GameTypeId = gt.Id
 order by gt.name desc, i.name

--12--

--UsersGames - change Cash update
--UserGameItems - add itemId, UserGameId ->from UsersGames - id - alex + edinbr


select * from users where Username = 'Alex'

select id, Price from items where name ='Blackguard'

select * from games where name = 'Edinburgh'

select  * from usersgames ug where ug.UserId = 5


insert into UserGameItems(ItemId, UserGameId)
values((select id from items where name ='Blackguard'), (select ug.Id from UsersGames ug 
																	join Games g on ug.GameId = g.Id
																	join Users u on ug.UserId = u.Id
																	where u.Username = 'Alex' and g.Name = 'Edinburgh'))


update UsersGames
set Cash = Cash - (select Price from items where name ='Blackguard')
where GameId = (select Id from Games where name = 'Edinburgh') and UserId = (select Id from users where Username = 'Alex')
--

insert into UserGameItems(ItemId, UserGameId)
values((select id from items where name ='Bottomless Potion of Amplification'), (select ug.Id from UsersGames ug 
																	join Games g on ug.GameId = g.Id
																	join Users u on ug.UserId = u.Id
																	where u.Username = 'Alex' and g.Name = 'Edinburgh'))


update UsersGames
set Cash = Cash - (select Price from items where name ='Bottomless Potion of Amplification')
where GameId = (select Id from Games where name = 'Edinburgh') and UserId = (select Id from users where Username = 'Alex')

--

insert into UserGameItems(ItemId, UserGameId)
values((select id from items where name ='Hellfire Amulet'), (select ug.Id from UsersGames ug 
																	join Games g on ug.GameId = g.Id
																	join Users u on ug.UserId = u.Id
																	where u.Username = 'Alex' and g.Name = 'Edinburgh'))


update UsersGames
set Cash = Cash - (select Price from items where name ='Hellfire Amulet')
where GameId = (select Id from Games where name = 'Edinburgh') and UserId = (select Id from users where Username = 'Alex')
--

select u.Username , g.Name , ug.Cash, i.Name as [Item Name]
from Games g 
left join UsersGames ug on ug.GameId = g.Id
left join Users u on ug.UserId = u.Id
left join UserGameItems ugi on ugi.UserGameId = ug.Id
left join Items i on ugi.ItemId = i.Id
where g.Name = 'Edinburgh'
order by i.name

--13--


ALTER TABLE `job_ad_applications` 
ADD CONSTRAINT `fk_1` FOREIGN KEY (`job_ad_id`)  REFERENCES `job_ads` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD  CONSTRAINT `fk_2` FOREIGN KEY (`user_id`)  REFERENCES `Users` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

select *
from job_ad_applications jaa
left join users u on jaa.user_id = u.id
left join job_ads ja on jaa.salary_id = s.id