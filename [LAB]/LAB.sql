select Title from Questions 
order by title 

--2--------------------------------------------------------------------

select a.Content , a.CreatedOn from Answers a 
where a.CreatedOn > '15-June-2012' and a.CreatedOn < '22-Mar-2013'
order by a.CreatedOn

--3--------------------------------------------------------------------

select u.Username,
 u.LastName , 
 [Has Phone] = case
	when u.PhoneNumber is null then '0'
else '1'
end
from users u
order by u.LastName

--4--------------------------------------------------------------------

select q.Title as [Question Title] , u.Username as [Author]
from Questions q
join Users u on q.UserId = u.Id
order by q.Title

--5--------------------------------------------------------------------

select top 50 a.Content as [Answer Content],
 a.CreatedOn,
  u.Username as [Answer Author], 
  q.Title as [Question Title],
   c.Name as [Category Name]
 from Answers a
 join Users u on a.UserId = u.Id
 join Questions q on a.QuestionId = q.Id
 join Categories c on q.CategoryId = c.Id
 order by c.Name, u.Username, a.CreatedOn

--6--------------------------------------------------------------------

select c.Name as Category , q.Title as Question, q.CreatedOn
from Questions q 
right join Categories c on q.CategoryId = c.Id 
order by c.Name, q.Title

--7--------------------------------------------------------------------

select u.id as Id, u.Username, u.FirstName, u.PhoneNumber, u.RegistrationDate, u.Email
from Users u 
left join Questions q on q.UserId = u.Id
where u.PhoneNumber is null 
and u.Id not in (select q.UserId from Questions q)
order by u.RegistrationDate

--8-------------------------------------------------------------------

select top 1 aMin.CreatedOn as MinDate , aMax.CreatedOn as MaxDate
from Answers aMin , Answers aMax
where Year(aMin.CreatedOn) = '2012'
and Year(aMax.CreatedOn) = '2014'
order by aMin.CreatedOn, aMax.CreatedOn desc

--9-------------------------------------------------------------------

select top 10 a.Content as Answer, a.CreatedOn, u.Username
from Answers a
join Users u on a.UserId = u.Id
order by a.CreatedOn desc

--10-------------------------------------------------------------------


--11-------------------------------------------------------------------

select c.Name as Category , count(a.Id) as [Answers Count]
from Categories c
left join Questions	q on q.CategoryId = c.Id
left join Answers a on a.QuestionId = q.Id
group by c.Name
order by count(a.Id) desc

--12-------------------------------------------------------------------

select c.Name as Category , u.Username, u.PhoneNumber , COUNT (a.id) as [Answers Count]
from Categories c
join Questions	q on q.CategoryId = c.Id
join Answers a on a.QuestionId = q.Id
join Users u on a.UserId = u.Id
group by c.Name, u.Username, u.PhoneNumber
having u.PhoneNumber is not null
order by [Answers Count] desc, u.Username

--13-------------------------------------------------------------------

create table Towns(
	Id int identity not null,
	Name nvarchar(max) not null,
	CONSTRAINT PK_Towns PRIMARY KEY(Id))
GO
ALTER TABLE Users ADD TownId INT
GO
ALTER TABLE Users ADD CONSTRAINT FK_Towns_Users
FOREIGN KEY (TownId) REFERENCES Towns(Id)
GO

INSERT INTO Towns(Name) VALUES ('Sofia'), ('Berlin'), ('Lyon')
UPDATE Users SET TownId = (SELECT Id FROM Towns WHERE Name='Sofia')
INSERT INTO Towns VALUES
('Munich'), ('Frankfurt'), ('Varna'), ('Hamburg'), ('Paris'), ('Lom'), ('Nantes')
go

UPDATE Users 
SET TownId = (SELECT t.Id FROM Towns t WHERE t.Name = 'Paris')
		   WHERE  DATENAME(dw, RegistrationDate) = 'friday' 
go

update Answers
set QuestionId  = (select q.Id from Questions q  where q.Title = 'Java += operator')
					WHERE  DATENAME(dw, CreatedOn) in ('monday' , 'sunday') 
					and MONTH(CreatedOn) = '2'
go

create table #AnswersId(
	AnswerId int not null)
go

insert into #AnswersId
select a.id from answers a
	join votes v on v.AnswerId = a.Id
	group by a.id
	having sum(v.value) < 0

delete from votes
from votes v 
where v.AnswerId in (
	select a.id from answers a
	join votes v on v.AnswerId = a.Id
	group by a.id
	having sum(v.value) < 0
)

delete from Answers 
from Answers a
where a.Id in (select aa.AnswerId from #AnswersId aa)

drop table #AnswersId

insert into Questions(title, Content, CategoryId, UserId, CreatedOn)
		values('Fetch NULL values in PDO query',
			'When I run the snippet, NULL values are converted to empty strings. How can fetch NULL values',
			(select c.Id from Categories c where c.Name = 'Databases'),
			(select u.Id from Users u where u.Username = 'darkcat'),
			Getdate())

select t.Name as Town, u.Username, COUNT(a.Id) as AnswersCount
 from  Answers a
full outer join Users u on a.UserId = u.Id
full outer join Towns t on t.Id = u.TownId
group by t.Name,u.Username
order by COUNT(a.Id) desc, u.Username
go
--14-------------------------------------------------------------------

create view AllQuestions 
as
select 
	u.id as UId,u.Username, u.FirstName, u.LastName, u.Email, u.PhoneNumber, u.RegistrationDate,
	q.Id as QId, q.Title, q.Content, q.CategoryId, q.UserId, q.CreatedOn
from Users u 
right join Questions q on q.UserId = u.Id

select * from AllQuestions

----

if (OBJECT_ID(N'fn_ListUsersQuestions') is not null)
drop function fn_ListUsersQuestions
go

create function fn_ListUsersQuestions()
	returns @tbl_Users_Questions table(
	UserName nvarchar(max),
	Questions nvarchar(max)
	)
as
begin
	declare UsersCursor CURSOR for
		select Username
		from  Users
		order by Username;
	open UsersCursor;
	declare @username nvarchar(max);
	fetch next from UsersCursor into @username;
	while @@FETCH_STATUS = 0 
	begin
		declare @questions nvarchar(max) = null;
		select 
			@questions = case
				when @questions is null then CONVERT(nvarchar(max), title, 112)
				else @questions + ', ' + CONVERT(nvarchar(max), title, 112)
			end
		from AllQuestions
		where Username = @username
		order by title desc;

		insert into @tbl_Users_Questions
		values (@username, @questions)

		fetch next from UsersCursor into @username;
	end;
close UsersCursor;
deallocate UsersCursor;
return;
end
go

select * from fn_ListUsersQuestions()