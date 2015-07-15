--Problem 1.	Create a table in SQL Server.  Your task is to create a table in SQL Server with 10 000 000 entries (date + text). 
--Search in the table by date range. Check the speed (without caching).

use BankDB
go

create table HomeworkTable(
Dates datetime not null,
Text nvarchar(50))
go

declare @n int = 10000000
while (@n > 0)
begin
	insert into HomeworkTable
	values(GETDATE(), CONVERT(varchar(50), @n))
	set @n = @n - 1
end

select *
from HomeworkTable 
where Dates between CONVERT(datetime, '2015-07-08 10:00:00.000') and CONVERT(datetime, '2015-07-08 11:00:00.000')

--Problem 2.	Add an index to speed-up the search by date 
--Your task is to add an index to speed-up the search by date. Test the search speed (after cleaning the cache).

create index IX_HomeworkTable_Dates
    on HomeworkTable(Dates); 
go

