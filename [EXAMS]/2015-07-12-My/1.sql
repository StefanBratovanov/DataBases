DROP DATABASE IF EXISTS `Job Portal`;

CREATE DATABASE `Job Portal` DEFAULT CHARACTER SET UTF8 COLLATE UTF8_UNICODE_CI ;

USE `Job Portal`;

DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `username` VARCHAR(45) NOT NULL ,
  `fullname`VARCHAR(100) ,
  PRIMARY KEY (`Id`));
  
  
  DROP TABLE IF EXISTS `job_ads`;


CREATE TABLE `job_ads` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(100),
  `author_id` INT NOT NULL,
  `salary_id` int,
  PRIMARY KEY (`Id`));
  

DROP TABLE IF EXISTS `job_ad_applications`;

CREATE TABLE `job_ad_applications` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `job_ad_id` INT NOT NULL ,
  `user_id` INT NOT NULL,
  `state` VARCHAR(45),
  PRIMARY KEY (`Id`));
 
  
DROP TABLE IF EXISTS `salaries`;

CREATE TABLE `salaries` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `from_value` DECIMAL(10,2) NOT NULL ,
  `to_value` DECIMAL(10,2) NOT NULL ,
  PRIMARY KEY (`Id`));

insert into users (username, fullname)
values ('pesho', 'Peter Pan'),
('gosho', 'Georgi Manchev'),
('minka', 'Minka Dryzdeva'),
('jivka', 'Jivka Goranova'),
('gago', 'Georgi Georgiev'),
('dokata', 'Yordan Malov'),
('glavata', 'Galin Glavomanov'),
('petrohana', 'Peter Petromanov'),
('jubata', 'Jivko Jurandov'),
('dodo', 'Donko Drozev'),
('bobo', 'Bay Boris');

insert into salaries (from_value, to_value)
values (300, 500),
(400, 600),
(550, 700),
(600, 800),
(1000, 1200),
(1300, 1500),
(1500, 2000),
(2000, 3000);

insert into job_ads (title, description, author_id, salary_id)
values ('PHP Developer', NULL, (select id from users where username = 'gosho'), (select id from salaries where from_value = 300)),
('Java Developer', 'looking to hire Junior Java Developer to join a team responsible for the development and maintenance of the payment infrastructure systems', (select id from users where username = 'jivka'), (select id from salaries where from_value = 1000)),
('.NET Developer', 'net developers who are eager to develop highly innovative web and mobile products with latest versions of Microsoft .NET, ASP.NET, Web services, SQL Server and related applications.', (select id from users where username = 'dokata'), (select id from salaries where from_value = 1300)),
('JavaScript Developer', 'Excellent knowledge in JavaScript', (select id from users where username = 'minka'), (select id from salaries where from_value = 1500)),
('C++ Developer', NULL, (select id from users where username = 'bobo'), (select id from salaries where from_value = 2000)),
('Game Developer', NULL, (select id from users where username = 'jubata'), (select id from salaries where from_value = 600)),
('Unity Developer', NULL, (select id from users where username = 'petrohana'), (select id from salaries where from_value = 550));

insert into job_ad_applications(job_ad_id, user_id)
values 
	((select id from job_ads where title = 'C++ Developer'), (select id from users where username = 'gosho')),
	((select id from job_ads where title = 'Game Developer'), (select id from users where username = 'gosho')),
	((select id from job_ads where title = 'Java Developer'), (select id from users where username = 'gosho')),
	((select id from job_ads where title = '.NET Developer'), (select id from users where username = 'minka')),
	((select id from job_ads where title = 'JavaScript Developer'), (select id from users where username = 'minka')),
	((select id from job_ads where title = 'Unity Developer'), (select id from users where username = 'petrohana')),
	((select id from job_ads where title = '.NET Djob_ad_applicationseveloper'), (select id from users where username = 'jivka')),
	((select id from job_ads where title = 'Java Developer'), (select id from users where username = 'jivka'));

ALTER TABLE `job_ads` 
ADD CONSTRAINT `fk_3` FOREIGN KEY (`author_id`)  REFERENCES `users` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD  CONSTRAINT `fk_4` FOREIGN KEY (`salary_id`)  REFERENCES `salaries` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `job_ad_applications` 
ADD  CONSTRAINT `fk_2` FOREIGN KEY (`user_id`)  REFERENCES `Users` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

select u.username, u.fullname, ja.title as Job, s.from_value as `From Value`, s.to_value as `To Value`
from job_ad_applications jaa
right join users u on jaa.user_id = u.id
right join job_ads ja on ja.author_id = u.id
right join salaries s on ja.salary_id = s.id
order by u.username, ja.title

  