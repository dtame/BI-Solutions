USE [DWHumanResource];

GO

CREATE TABLE [DimDepartment](
	[DepartmentKey] INT NOT NULL PRIMARY KEY IDENTITY
	,[DepartmentID] INT NOT NULL
	,[DepartmentName] VARCHAR(50) NOT NULL
	,[ParentDepartmentKey] INT NULL
)

GO 

CREATE TABLE [DimEmployee](
[EmployeeKey] INT NOT NULL PRIMARY KEY IDENTITY
,[EmployeeID] VARCHAR(50) NOT NULL
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
,[RowStatus] BIT NOT NULL
,[ActionFlag] BIT NOT NULL DEFAULT 0
)

GO

CREATE TABLE [DimDate](
	[DateKey] INT NOT NULL PRIMARY KEY IDENTITY
	,[Date] DATETIME NOT NULL
	,[DateName] VARCHAR (50)
	,[Month] INT NOT NULL
	,[MonthName] VARCHAR (50) NOT NULL
	,[Quarter] INT NOT NULL
	,[QuarterName] VARCHAR (50) NOT NULL
	,[Year] INT NOT NULL
	,[YearName] VARCHAR (50) NOT NULL
)

GO

CREATE TABLE [FactHRSnapshot](
[EmployeeKey] INT NOT NULL 
,[DepartmentKey] INT NOT NULL
,[HiringDateKey] INT NOT NULL
CONSTRAINT [PK_FactHRSnapshop] PRIMARY KEY
( [EmployeeKey] ASC, [DepartmentKey] ASC, [HiringDateKey] ASC)
)

GO

-- Add Foreign Keys 
ALTER TABLE [DWHumanResource].[dbo].[FactHRSnapshot] WITH CHECK
ADD CONSTRAINT [FK_FactHRSnapshot_DimEmployee] 
FOREIGN KEY ([EmployeeKey]) REFERENCES [dbo].[DimEmployee] ([EmployeeKey])

GO

ALTER TABLE [DWHumanResource].[dbo].[FactHRSnapshot] WITH CHECK
ADD CONSTRAINT [FK_FactHRSnapshot_DimDepartment] 
FOREIGN KEY ([DepartmentKey]) REFERENCES [dbo].[DimDepartment] ([DepartmentKey])

GO

ALTER TABLE [DWHumanResource].[dbo].[FactHRSnapshot] WITH CHECK
ADD CONSTRAINT [FK_FactHRSnapshot_DimDate] 
FOREIGN KEY ([HiringDateKey]) REFERENCES [dbo].[DimDate] ([DateKey])

 --Add error value into DimDate tables

SET IDENTITY_INSERT [DWHumanResource].[dbo].[DimDate] On

GO

INSERT INTO [dbo].[DimDate]
	([DateKey] 
	,[Date] 
	,[DateName] 
	,[Month] 
	,[MonthName] 
	,[Quarter] 
	,[QuarterName] 
	,[Year] 
	,[YearName] 
	)
SELECT [DateKey] = -1
	,[Date] = CAST ('01/01/1990' AS nVARCHAR(50))
	,[DateName] = CAST ('Unknown Day' AS nVARCHAR(50))
	,[Month] = -1
	,[MonthName] = CAST ('Unknown Month' AS nVARCHAR(50))
	,[Quarter] =-1
	,[QuarterName] = CAST ('Unknown Quarter' AS nVARCHAR(50))
	,[Year] =-1
	,[YearName] = CAST ('Unknown Year' AS nVARCHAR(50)) 

GO

SET IDENTITY_INSERT [DWHumanResource].[dbo].[DimDate] Off

GO
-- Add Management Department first value

--SET IDENTITY_INSERT [DWHumanResource].[dbo].[DimDepartment] On
--GO
INSERT INTO [dbo].[DimDepartment]
		([DepartmentID] 
		,[DepartmentName] 
		,[ParentDepartmentKey] )
	VALUES (1,'Corporate Board' ,NULL),
		(2,'Administratif',1),
		(3,'Informatique',1),
		(4,'Service Client',1),
		(5,'Vente',1),
		(6,'Entrepôt',1),
		(7,'Nettoyage',6)
 
GO

--SET IDENTITY_INSERT [DWHumanResource].[dbo].[DimDepartment] Off
--GO



-- Since the date table has no associated source table we can fill the data
-- using a SQL script or wait until the ETL process. Either way, here is the 
-- code to use.

-- Create variables to hold the start and end date
DECLARE @StartDate datetime = '01/01/2011'
DECLARE @EndDate datetime = '01/01/2016' 

-- Use a while loop to add dates to the table
DECLARE @DateInProcess datetime
SET @DateInProcess = @StartDate

WHILE @DateInProcess <= @EndDate
 BEGIN
 --Add a row into the date dimension table for this date
 INSERT INTO [dbo].[DimDate] 
 ( [Date], [DateName], [Month], [MonthName], [Quarter], [QuarterName], [Year], [YearName] )
 VALUES ( 
  @DateInProcess -- [Date]
  , DateName( weekday, @DateInProcess )  -- [DateName]  
  , Month( @DateInProcess ) -- [Month]   
  , DateName( month, @DateInProcess ) -- [MonthName]
  , DateName( quarter, @DateInProcess ) -- [Quarter]
  , 'Q' + DateName( quarter, @DateInProcess ) + ' - ' + Cast( Year(@DateInProcess) as nVarchar(50) ) -- [QuarterName] 
  , Year( @DateInProcess )
  , Cast( Year(@DateInProcess ) as nVarchar(50) ) -- [Year] 
  )  
 -- Add a day and loop again
 SET @DateInProcess = DateAdd(d, 1, @DateInProcess)
 END

-- Check the table SELECT Top 10 * FROM DimDates