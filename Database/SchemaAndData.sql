SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE [master];
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'School')
    DROP DATABASE School;
GO

-- Create the School database.
CREATE DATABASE School;
GO

-- Specify a simple recovery model 
-- to keep the log growth to a minimum.
ALTER DATABASE School 
    SET RECOVERY SIMPLE;
GO

USE School;
GO

-- Create the Product table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[Product]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE Product (
	ProductId INT IDENTITY (1, 1) ,
	[Name] NVARCHAR (255) NOT NULL,
	ModelYear SMALLINT NOT NULL,
	ListPrice DECIMAL (10, 2) NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
    [ProductId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Create the Order table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[Order]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE [Order] (
	OrderId INT IDENTITY (1, 1) ,
	[Status] tinyint NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	OrderDate DATE NOT NULL,
	RequiredDate DATE NOT NULL,
	ShippedDate DATE,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
    [OrderId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END
GO

-- Create the OrderItem table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[OrderItem]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE OrderItem (
	OrderId INT,
	OrderItemId INT IDENTITY (1, 1) ,
	ProductId INT NOT NULL,
	Quantity INT NOT NULL,
	ListPrice DECIMAL (10, 2) NOT NULL,
	Discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	CONSTRAINT [PK_OrderItem] PRIMARY KEY (OrderId, OrderItemId),
	CONSTRAINT [FK_OrderItem_REF_Order] FOREIGN KEY (OrderId) REFERENCES [Order] (OrderId) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_OrderItem_REF_Product] FOREIGN KEY (ProductId) REFERENCES Product (ProductId) ON DELETE CASCADE ON UPDATE CASCADE);
END
GO

-- Create the Department table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[Department]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Department](
    [DepartmentID] [int] NOT NULL,
    [Name] [nvarchar](50) NOT NULL,
    [Budget] [money] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [Administrator] [int] NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
    [DepartmentID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Create the Person table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[Person]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Person](
    [PersonID] [int] IDENTITY(1,1) NOT NULL,
    [LastName] [nvarchar](50) NOT NULL,
    [FirstName] [nvarchar](50) NOT NULL,
    [HireDate] [datetime] NULL,
    [EnrollmentDate] [datetime] NULL,
 CONSTRAINT [PK_School.Student] PRIMARY KEY CLUSTERED 
(
    [PersonID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Create the OnsiteCourse table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[OnsiteCourse]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OnsiteCourse](
    [CourseID] [int] NOT NULL,
    [Location] [nvarchar](50) NOT NULL,
    [Days] [nvarchar](50) NOT NULL,
    [Time] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_OnsiteCourse] PRIMARY KEY CLUSTERED 
(
    [CourseID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Create the Outline table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[Outline]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Outline](
    [OutlineID] [int] IDENTITY(1,1) NOT NULL,
    [CourseID] [int] NOT NULL,
    [Title] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Outline] PRIMARY KEY CLUSTERED 
(
    [OutlineID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

--Create the StudentGrade table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[StudentGrade]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StudentGrade](
    [EnrollmentID] [int] IDENTITY(1,1) NOT NULL,
    [CourseID] [int] NOT NULL,
    [StudentID] [int] NOT NULL,
    [Grade] [decimal](3, 2) NULL,
 CONSTRAINT [PK_StudentGrade] PRIMARY KEY CLUSTERED 
(
    [EnrollmentID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Create the CourseInstructor table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[CourseInstructor]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CourseInstructor](
    [CourseID] [int] NOT NULL,
    [PersonID] [int] NOT NULL,
 CONSTRAINT [PK_CourseInstructor] PRIMARY KEY CLUSTERED 
(
    [CourseID] ASC,
    [PersonID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Create the Course table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[Course]') 
        AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Course](
    [CourseID] [int] NOT NULL,
    [Title] [nvarchar](100) NOT NULL,
    [Credits] [int] NOT NULL,
    [DepartmentID] [int] NOT NULL,
 CONSTRAINT [PK_School.Course] PRIMARY KEY CLUSTERED 
(
    [CourseID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Create the OfficeAssignment table.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[OfficeAssignment]')
        AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OfficeAssignment](
    [InstructorID] [int] NOT NULL,
    [Location] [nvarchar](50) NOT NULL,
    [Timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_OfficeAssignment] PRIMARY KEY CLUSTERED 
(
    [InstructorID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Define the relationship between OnsiteCourse and Course.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
       WHERE object_id = OBJECT_ID(N'[dbo].[FK_OnsiteCourse_Course]')
       AND parent_object_id = OBJECT_ID(N'[dbo].[OnsiteCourse]'))
ALTER TABLE [dbo].[OnsiteCourse]  WITH CHECK ADD  
       CONSTRAINT [FK_OnsiteCourse_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[OnsiteCourse] CHECK 
       CONSTRAINT [FK_OnsiteCourse_Course]
GO

-- Define the relationship between Outline and Course.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
       WHERE object_id = OBJECT_ID(N'[dbo].[FK_Outline_Course]')
       AND parent_object_id = OBJECT_ID(N'[dbo].[Outline]'))
ALTER TABLE [dbo].[Outline]  WITH CHECK ADD  
       CONSTRAINT [FK_Outline_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[Outline] CHECK 
       CONSTRAINT [FK_Outline_Course]
GO

-- Define the relationship between StudentGrade and Course.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
       WHERE object_id = OBJECT_ID(N'[dbo].[FK_StudentGrade_Course]')
       AND parent_object_id = OBJECT_ID(N'[dbo].[StudentGrade]'))
ALTER TABLE [dbo].[StudentGrade]  WITH CHECK ADD  
       CONSTRAINT [FK_StudentGrade_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[StudentGrade] CHECK 
       CONSTRAINT [FK_StudentGrade_Course]
GO

--Define the relationship between StudentGrade and Student.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
       WHERE object_id = OBJECT_ID(N'[dbo].[FK_StudentGrade_Student]')
       AND parent_object_id = OBJECT_ID(N'[dbo].[StudentGrade]'))
ALTER TABLE [dbo].[StudentGrade]  WITH CHECK ADD  
       CONSTRAINT [FK_StudentGrade_Student] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[StudentGrade] CHECK 
       CONSTRAINT [FK_StudentGrade_Student]
GO

-- Define the relationship between CourseInstructor and Course.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'[dbo].[FK_CourseInstructor_Course]')
   AND parent_object_id = OBJECT_ID(N'[dbo].[CourseInstructor]'))
ALTER TABLE [dbo].[CourseInstructor]  WITH CHECK ADD  
   CONSTRAINT [FK_CourseInstructor_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[CourseInstructor] CHECK 
   CONSTRAINT [FK_CourseInstructor_Course]
GO

-- Define the relationship between CourseInstructor and Person.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'[dbo].[FK_CourseInstructor_Person]')
   AND parent_object_id = OBJECT_ID(N'[dbo].[CourseInstructor]'))
ALTER TABLE [dbo].[CourseInstructor]  WITH CHECK ADD  
   CONSTRAINT [FK_CourseInstructor_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[CourseInstructor] CHECK 
   CONSTRAINT [FK_CourseInstructor_Person]
GO

-- Define the relationship between Course and Department.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
       WHERE object_id = OBJECT_ID(N'[dbo].[FK_Course_Department]')
       AND parent_object_id = OBJECT_ID(N'[dbo].[Course]'))
ALTER TABLE [dbo].[Course]  WITH CHECK ADD  
       CONSTRAINT [FK_Course_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [FK_Course_Department]
GO

--Define the relationship between OfficeAssignment and Person.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'[dbo].[FK_OfficeAssignment_Person]')
   AND parent_object_id = OBJECT_ID(N'[dbo].[OfficeAssignment]'))
ALTER TABLE [dbo].[OfficeAssignment]  WITH CHECK ADD  
   CONSTRAINT [FK_OfficeAssignment_Person] FOREIGN KEY([InstructorID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[OfficeAssignment] CHECK 
   CONSTRAINT [FK_OfficeAssignment_Person]
GO

-- Create InsertOfficeAssignment stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[InsertOfficeAssignment]') 
        AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[InsertOfficeAssignment]
        @InstructorID int,
        @Location nvarchar(50)
        AS
        INSERT INTO dbo.OfficeAssignment (InstructorID, Location)
        VALUES (@InstructorID, @Location);
        IF @@ROWCOUNT > 0
        BEGIN
            SELECT [Timestamp] FROM OfficeAssignment 
                WHERE InstructorID=@InstructorID;
        END
' 
END
GO

--Create the UpdateOfficeAssignment stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[UpdateOfficeAssignment]') 
        AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdateOfficeAssignment]
        @InstructorID int,
        @Location nvarchar(50),
        @OrigTimestamp timestamp
        AS
        UPDATE OfficeAssignment SET Location=@Location 
        WHERE InstructorID=@InstructorID AND [Timestamp]=@OrigTimestamp;
        IF @@ROWCOUNT > 0
        BEGIN
            SELECT [Timestamp] FROM OfficeAssignment 
                WHERE InstructorID=@InstructorID;
        END
' 
END
GO

-- Create the DeleteOfficeAssignment stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[DeleteOfficeAssignment]') 
        AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[DeleteOfficeAssignment]
        @InstructorID int
        AS
        DELETE FROM OfficeAssignment
        WHERE InstructorID=@InstructorID;
' 
END
GO

-- Create the DeletePerson stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[DeletePerson]') 
        AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[DeletePerson]
        @PersonID int
        AS
        DELETE FROM Person WHERE PersonID = @PersonID;
' 
END
GO

-- Create the UpdatePerson stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePerson]') 
        AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdatePerson]
        @PersonID int,
        @LastName nvarchar(50),
        @FirstName nvarchar(50),
        @HireDate datetime,
        @EnrollmentDate datetime
        AS
        UPDATE Person SET LastName=@LastName, 
                FirstName=@FirstName,
                HireDate=@HireDate,
                EnrollmentDate=@EnrollmentDate
        WHERE PersonID=@PersonID;
' 
END
GO

-- Create the InsertPerson stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects 
        WHERE object_id = OBJECT_ID(N'[dbo].[InsertPerson]') 
        AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[InsertPerson]
        @LastName nvarchar(50),
        @FirstName nvarchar(50),
        @HireDate datetime,
        @EnrollmentDate datetime
        AS
        INSERT INTO dbo.Person (LastName, 
                    FirstName, 
                    HireDate, 
                    EnrollmentDate)
        VALUES (@LastName, 
            @FirstName, 
            @HireDate, 
            @EnrollmentDate);
        SELECT SCOPE_IDENTITY() as NewPersonID;
' 
END
GO

-- Create GetStudentGrades stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects 
            WHERE object_id = OBJECT_ID(N'[dbo].[GetStudentGrades]') 
            AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetStudentGrades]
            @StudentID int
            AS
            SELECT EnrollmentID, Grade, CourseID, StudentID FROM dbo.StudentGrade
            WHERE StudentID = @StudentID
' 
END
GO

-- Create GetDepartmentName stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects 
            WHERE object_id = OBJECT_ID(N'[dbo].[GetDepartmentName]') 
            AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetDepartmentName]
      @ID int,
      @Name nvarchar(50) OUTPUT
      AS
      SELECT @Name = Name FROM Department
      WHERE DepartmentID = @ID
'
END
GO

-- Insert data into the Person table.
USE School
GO
SET IDENTITY_INSERT dbo.Person ON
GO
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (1, 'Abercrombie', 'Kim', '1995-03-11', null);
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (2, 'Barzdukas', 'Gytis', null, '2005-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (3, 'Justice', 'Peggy', null, '2001-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (4, 'Fakhouri', 'Fadi', '2002-08-06', null);
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (5, 'Harui', 'Roger', '1998-07-01', null);
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (6, 'Li', 'Yan', null, '2002-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (7, 'Norman', 'Laura', null, '2003-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (8, 'Olivotto', 'Nino', null, '2005-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (9, 'Tang', 'Wayne', null, '2005-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (10, 'Alonso', 'Meredith', null, '2002-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (11, 'Lopez', 'Sophia', null, '2004-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (12, 'Browning', 'Meredith', null, '2000-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (13, 'Anand', 'Arturo', null, '2003-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (14, 'Walker', 'Alexandra', null, '2000-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (15, 'Powell', 'Carson', null, '2004-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (16, 'Jai', 'Damien', null, '2001-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (17, 'Carlson', 'Robyn', null, '2005-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (18, 'Zheng', 'Roger', '2004-02-12', null);
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (19, 'Bryant', 'Carson', null, '2001-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (20, 'Suarez', 'Robyn', null, '2004-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (21, 'Holt', 'Roger', null, '2004-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (22, 'Alexander', 'Carson', null, '2005-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (23, 'Morgan', 'Isaiah', null, '2001-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (24, 'Martin', 'Randall', null, '2005-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (25, 'Kapoor', 'Candace', '2001-01-15', null);
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (26, 'Rogers', 'Cody', null, '2002-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (27, 'Serrano', 'Stacy', '1999-06-01', null);
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (28, 'White', 'Anthony', null, '2001-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (29, 'Griffin', 'Rachel', null, '2004-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (30, 'Shan', 'Alicia', null, '2003-09-01');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (31, 'Stewart', 'Jasmine', '1997-10-12', null);
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (32, 'Xu', 'Kristen', '2001-7-23', null);
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (33, 'Gao', 'Erica', null, '2003-01-30');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate)
VALUES (34, 'Van Houten', 'Roger', '2000-12-07', null);
GO
SET IDENTITY_INSERT dbo.Person OFF
GO

-- Insert data into the Department table.
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (1, 'Engineering', 350000.00, '2007-09-01', 2);
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (2, 'English', 120000.00, '2007-09-01', 6);
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (4, 'Economics', 200000.00, '2007-09-01', 4);
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (7, 'Mathematics', 250000.00, '2007-09-01', 3);
GO


-- Insert data into the Course table.
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (1050, 'Chemistry', 4, 1);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (1061, 'Physics', 4, 1);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (1045, 'Calculus', 4, 7);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (2030, 'Poetry', 2, 2);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (2021, 'Composition', 3, 2);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (2042, 'Literature', 4, 2);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (4022, 'Microeconomics', 3, 4);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (4041, 'Macroeconomics', 3, 4);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (4061, 'Quantitative', 2, 4);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (3141, 'Trigonometry', 4, 7);
GO

-- Insert data into the Outline table.
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (2030, 'http://www.fineartschool.net/Poetry1');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (2030, 'http://www.fineartschool.net/Poetry2');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (2030, 'http://www.fineartschool.net/Poetry3');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (2021, 'http://www.fineartschool.net/Composition1');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (2021, 'http://www.fineartschool.net/Composition2');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (2021, 'http://www.fineartschool.net/Composition3');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (2021, 'http://www.fineartschool.net/Composition4');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (2021, 'http://www.fineartschool.net/Composition5');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (4041, 'http://www.fineartschool.net/Macroeconomics1');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (4041, 'http://www.fineartschool.net/Macroeconomics2');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (4041, 'http://www.fineartschool.net/Macroeconomics3');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (4041, 'http://www.fineartschool.net/Macroeconomics4');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (3141, 'http://www.fineartschool.net/Trigonometry1');
INSERT INTO dbo.Outline (CourseID, Title)
VALUES (3141, 'http://www.fineartschool.net/Trigonometry2');

--Insert data into OnsiteCourse table.
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (1050, '123 Smith', 'MTWH', '11:30');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (1061, '234 Smith', 'TWHF', '13:15');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (1045, '121 Smith','MWHF', '15:30');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (4061, '22 Williams', 'TH', '11:15');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (2042, '225 Adams', 'MTWH', '11:00');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (4022, '23 Williams', 'MWF', '9:00');

-- Insert data into the CourseInstructor table.
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (1050, 1);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (1061, 31);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (1045, 5);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (2030, 4);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (2021, 27);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (2042, 25);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (4022, 18);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (4041, 32);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (4061, 34);
GO

--Insert data into the OfficeAssignment table.
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (1, '17 Smith');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (4, '29 Adams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (5, '37 Williams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (18, '143 Smith');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (25, '57 Adams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (27, '271 Williams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (31, '131 Smith');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (32, '203 Williams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (34, '213 Smith');

-- Insert data into the StudentGrade table.
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 2, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2030, 2, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 3, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2030, 3, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 6, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2042, 6, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 7, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2042, 7, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 8, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2042, 8, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 9, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 10, null);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 11, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 12, null);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 12, null);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 14, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 13, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 13, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 14, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 15, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 16, 2);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 17, null);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 19, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 20, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 21, 2);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 22, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 22, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 22, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 23, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1045, 23, 1.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 24, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 25, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1050, 26, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 26, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 27, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1045, 28, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1050, 28, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 29, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1050, 30, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 30, 4);
GO