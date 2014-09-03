USE [DW_HR_Staging];

GO

CREATE TABLE [Employee](
[EmployeeID] NVARCHAR(10) NOT NULL
,[FirstName] VARCHAR(50) NOT NULL
,[LastName] VARCHAR(50) NOT NULL
,[BirthDate] DATETIME NOT NULL
,[Adress] VARCHAR(100) NULL
,[Email] VARCHAR(70) NULL
,[Phone] VARCHAR(50) NULL
,[Function] VARCHAR(50) NOT NULL
,[Gender] NCHAR(1) NOT NULL
,[DepartmentName] VARCHAR(50) NOT NULL
,[HiringDate] DATETIME NOT NULL
,[SalariedFlag] BIT NOT NULL

)

GO

CREATE TABLE [dbo].[RejectEmpRows](
	[EmployeeID] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[BirthDate] [datetime] NULL,
	[Adress] [varchar](100) NULL,
	[Email] [varchar](70) NULL,
	[Phone] [varchar](50) NULL,
	[Function] [varchar](50) NULL,
	[Gender] [nvarchar](1) NULL,
	[DepartmentName] [varchar](50) NULL,
	[HiringDate] [datetime] NULL,
	[SalariedFlag] [bit] NULL,
	[CorrectedFlag] [bit] NULL DEFAULT 0
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[ValidEmpRows](
	[EmployeeID] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[BirthDate] [datetime] NULL,
	[Adress] [varchar](100) NULL,
	[Email] [varchar](70) NULL,
	[Phone] [varchar](50) NULL,
	[Function] [varchar](50) NULL,
	[Gender] [nvarchar](1) NULL,
	[DepartmentName] [varchar](50) NULL,
	[HiringDate] [datetime] NULL,
	[SalariedFlag] [bit] NULL,
) ON [PRIMARY]