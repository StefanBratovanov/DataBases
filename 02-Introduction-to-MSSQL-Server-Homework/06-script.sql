USE [master]
GO
/****** Object:  Database [School]    Script Date: 6/22/2015 14:38:31 ******/
CREATE DATABASE [School]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'School', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\School.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'School_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\School_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [School] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [School].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [School] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [School] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [School] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [School] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [School] SET ARITHABORT OFF 
GO
ALTER DATABASE [School] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [School] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [School] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [School] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [School] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [School] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [School] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [School] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [School] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [School] SET  DISABLE_BROKER 
GO
ALTER DATABASE [School] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [School] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [School] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [School] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [School] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [School] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [School] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [School] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [School] SET  MULTI_USER 
GO
ALTER DATABASE [School] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [School] SET DB_CHAINING OFF 
GO
ALTER DATABASE [School] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [School] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [School] SET DELAYED_DURABILITY = DISABLED 
GO
USE [School]
GO
/****** Object:  User [stefoo33]    Script Date: 6/22/2015 14:38:31 ******/
CREATE USER [stefoo33] FOR LOGIN [stefoo33] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [stefoo33]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [stefoo33]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [stefoo33]
GO
ALTER ROLE [db_datareader] ADD MEMBER [stefoo33]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [stefoo33]
GO
/****** Object:  Table [dbo].[Classes]    Script Date: 6/22/2015 14:38:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Classes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[MaxStudents] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Classes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Students]    Script Date: 6/22/2015 14:38:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Age] [int] NOT NULL,
	[PhoneNumber] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Students_Classes]    Script Date: 6/22/2015 14:38:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students_Classes](
	[StudentID] [int] NOT NULL,
	[ClassesID] [int] NOT NULL
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Classes] ON 

INSERT [dbo].[Classes] ([Id], [Name], [MaxStudents]) VALUES (1, N'C#', N'30')
INSERT [dbo].[Classes] ([Id], [Name], [MaxStudents]) VALUES (2, N'Java', N'50')
INSERT [dbo].[Classes] ([Id], [Name], [MaxStudents]) VALUES (3, N'Databases', N'100')
INSERT [dbo].[Classes] ([Id], [Name], [MaxStudents]) VALUES (4, N'JavaScript', N'100')
SET IDENTITY_INSERT [dbo].[Classes] OFF
SET IDENTITY_INSERT [dbo].[Students] ON 

INSERT [dbo].[Students] ([Id], [Name], [Age], [PhoneNumber]) VALUES (1, N'Stefan', 33, N'35988')
INSERT [dbo].[Students] ([Id], [Name], [Age], [PhoneNumber]) VALUES (4, N'Petyr', 31, N'888')
INSERT [dbo].[Students] ([Id], [Name], [Age], [PhoneNumber]) VALUES (5, N'Misho', 35, N'6666')
INSERT [dbo].[Students] ([Id], [Name], [Age], [PhoneNumber]) VALUES (6, N'Gergana', 35, N'11111')
INSERT [dbo].[Students] ([Id], [Name], [Age], [PhoneNumber]) VALUES (7, N'Iskra', 36, N'22222')
SET IDENTITY_INSERT [dbo].[Students] OFF
ALTER TABLE [dbo].[Students_Classes]  WITH CHECK ADD  CONSTRAINT [FK_Students_Classes_Classes] FOREIGN KEY([ClassesID])
REFERENCES [dbo].[Classes] ([Id])
GO
ALTER TABLE [dbo].[Students_Classes] CHECK CONSTRAINT [FK_Students_Classes_Classes]
GO
ALTER TABLE [dbo].[Students_Classes]  WITH CHECK ADD  CONSTRAINT [FK_Students_Classes_Students] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Students] ([Id])
GO
ALTER TABLE [dbo].[Students_Classes] CHECK CONSTRAINT [FK_Students_Classes_Students]
GO
USE [master]
GO
ALTER DATABASE [School] SET  READ_WRITE 
GO
