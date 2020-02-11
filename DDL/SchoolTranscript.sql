/*****************
* File: SchoolTranscript.sqp
* Author Levi Warkentin
*
* CREATE DATABASE SchoolTranscript
************************* */
USE SchoolTranscript
GO


/* --- Drop Tables ---- */
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StudentCourses')
    DROP TABLE StudentCourses
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Courses')
    DROP TABLE Courses
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Students')
    DROP TABLE Students

/* ----- Create Tables ------ */
CREATE TABLE Students
(   -- Comma-seperated list of:
    -- Column-level and table-level definitions
    StudentID   int             
        CONSTRAINT PK_Students_StudentID
        PRIMARY KEY             
        IDENTITY(20200001, 1)   NOT NULL,
    GivenName   varchar(50)     NOT NULL,
-- % is a wildcard for a zero or more character (letter, digit, or other character)
--   _ is a wildcard for a single character (letter, digit, or other character)
    Surname     varchar(50)
		CONSTRAINT CK_Student_Surname
--			CHECK (Surname LIKE '_%')           -- LIKE allows us to do a "pattern-match"
			CHECK (Surname LIKE '[a-z][a-z]%')  -- two letters plus any other chars
						        NOT NULL,
    DateOfBirth datetime
		CONSTRAINT CK_Students_DateOfBirth
			CHECK (DateOfBirth < GETDATE())
						        NOT NULL,
    Enrolled    bit             
        CONSTRAINT DF_Students_Enrolled
            DEFAULT (1)         NOT NULL
)

CREATE TABLE Courses
(
    Number      varchar(10)     
        CONSTRAINT PK_Courses_Number
        PRIMARY KEY             NOT NULL,
    [Name]      varchar(50)     NOT NULL,
    Credits     Decimal(3,1) 
		CONSTRAINT CK_Courses_Credits
			CHECK (Credits > 0 AND Credits <= 12) 
			--    \          /      \           /
			--     boolean			boolean
			--		\                   /
			--				boolean
						        NOT NULL,
    [Hours]     tinyint         
		CONSTRAINT CK_Course_Hours
		--	CHECK ([Hours] >= 15 AND [Hours] <= 180)
			CHECK ([Hours] BETWEEN 15 AND 180) -- BETWEEN operator is inclusive
								NOT NULL,
    Active      bit             
         CONSTRAINT DF_Courses_Active
            DEFAULT (1)         NOT NULL,
    Cost        money
		CONSTRAINT CK_Cost
			CHECK (Cost > 0)    
							    NOT NULL
)

CREATE TABLE StudentCourses
(
    StudentID       int
        CONSTRAINT FK_StudentCourses_StudentID_Students_StudentID
            FOREIGN KEY REFERENCES Students(StudentID)
                                NOT NULL,
    CourseNumber    varchar(10) 
        CONSTRAINT FK_StudentCourses_CourseNumber_Courses_Number
            FOREIGN KEY REFERENCES Courses(Number)
                                NOT NULL,
    [Year]          tinyint     NOT NULL,
    Term            char(3)     NOT NULL,
    FinalMark       tinyint         NULL,
    [Status]        char(1)
		CONSTRAINT CK_Student_Status
			CHECK ([Status] = 'E' OR
				   [Status] = 'C' OR
				   [Status] = 'W')
--			CHECK ([Status] IN ('E', 'C', 'W'))
--		CONSTRAINT DF_StudentCourses_Status
--			DEFAULT ('E')
						       NOT NULL,
    -- Table-level definition for Composite Primary Keys 
    CONSTRAINT PK_StudentCourses_StudentID_CourseNumber
    PRIMARY KEY (StudentID, CourseNumber),
	-- Table--level constraint involving more then one column
	CONSTRAINT CK_StudentCourses_FinalMark_Status
		CHECK (([Status] = 'C' AND FinalMark IS NOT NULL)
				OR
				([Status] IN ('E', 'W') AND FinalMark IS NULL))
  
)

/* ----- Indexes ----- */
-- For all foreign keys
CREATE NONCLUSTERED INDEX IX_StudentCourses_StudentID
	ON StudentCourses (StudentID)

CREATE NONCLUSTERED INDEX IX_StudentCoursesCourseNumber
	ON StudentCourses (CourseNumber)

-- For other columns where searching/sorting might be important
CREATE NONCLUSTERED INDEX IX_Students_Surname
	ON Students (Surname)

/* -------- ALTER TABLE statements --------- */
-- 1) Add a PostalCode for a  Students table
ALTER TABLE Students
	ADD PostalCode char(6) NULL
	-- Adding this as a nullable column, because students already exist,
	-- and we don't have postal codes for those students.
	GO -- I have to break the above code as a seperate batch from the following

	-- 2) Make sure the PostalCode follows the correct pattern A#A#A#
	ALTER TABLE Students
		ADD CONSTRAINT CK_Students_PostalCode
			CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
			-- Match for T4R1H2       T    4    R    1    H    2
GO


-- 3) Add a default constraint for the Status column of StudentCourses
--    Set 'E' as the default value.
ALTER TABLE StudentCourses
	ADD CONSTRAINT DF_StudentCourses_Status
		DEFAULT ('E') FOR [Status] -- In an ALTER TABLE statement, the column myust be 
								   -- Specified for the default value
GO

/* ----------- Odds and ENDS -------------------- */
sp_help Students ----- Get the schema information for the Students table

-- In a table, we can have some columns be "calculated" or "derived" columns
-- where the value of the column is a calculation from other columns.
CREATE TABLE Invoice 
(
	InvoiceId		int		NOT NULL,
	Subtotal		money	NOT NULL,
	GST				money	NOT NULL,
	TOTAL			AS Subtotal + GST	-- This is a computed column
)
