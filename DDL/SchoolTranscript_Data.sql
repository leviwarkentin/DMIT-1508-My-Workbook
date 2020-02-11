USE SchoolTranscript
GO

INSERT INTO Students(GivenName, Surname, DateOfBirth)
VALUES ('Levi', 'Warkentin', '20000921 10:34:00 PM'),
       ('John', 'White', '19970521 08:15:00 AM'),
	   ('Jshn', 'White', '19970521 08:15:00 AM'),
	   ('Jofn', 'White', '19970521 08:15:00 AM'),
	   ('John', 'White', '19970521 08:15:00 AM'),
	   ('Jfhn', 'White', '19970521 08:15:00 AM')

INSERT INTO Students(GivenName, Surname, DateOfBirth)
VALUES ('Sevi', 'Farkentin', '20000421 10:44:44 PM')

INSERT INTO Courses(Number, [Name], Credits, [Hours], Cost)
VALUES		('DJIT-1508', 'Database Fundamentals', 3.0, 60, 750),
			('DMIT-1505', 'Web Design', 3.0, 60, 750)

SELECT * FROM Students