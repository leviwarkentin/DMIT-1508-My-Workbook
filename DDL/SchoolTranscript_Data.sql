USE SchoolTranscript
GO

INSERT INTO Students(GivenName, Surname, DateOfBirth, Enrolled)
VALUES ('Levi', 'Warkentin', '20000921 10:34:00 PM', 1),
       ('John', 'White', '19970521 08:15:00 AM', 1)

INSERT INTO Students(GivenName, Surname, DateOfBirth)
VALUES ('Sevi', 'Farkentin', '24400421 10:44:44 PM')

SELECT * FROM Students