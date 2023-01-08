Use Library

--1 Отобразить информацию об авторах, средний объем книг которых (в страницах) более 600 страниц. SELECT Authors.Id, Authors.FirstName, Authors.LastNameFROM Authors JOIN BooksON Authors.Id = Books.Id_AuthorGROUP BY Authors.Id, Authors.FirstName, Authors.LastNameHAVING AVG(Pages) > 600--2 Отобразить информацию об издательствах, у которых общее количество страниц выпущенных ими книг больше 700. SELECT Press.Id, Press.[Name]FROM PressJOIN BooksON Press.Id = Books.Id_PressGROUP BY Press.Id, Press.[Name]HAVING MAX(Pages) > 700--3 Отобразить всех посетителей библиотеки (и студентов и преподавателей) и книги, которые они брали. SELECT FirstName, LastName, Books.[Name]FROM Students JOIN S_CardsON Students.Id = S_Cards.Id_StudentJOIN BooksON S_Cards.Id_Book = Books.IdUNIONSELECT FirstName, LastName, Books.[Name]FROM TeachersJOIN T_CardsON Teachers.Id = T_Cards.Id_TeacherJOIN BooksON T_Cards.Id_Book = Books.Id--4 Вывести самого популярного автора(ов) среди студентов и количество книг этого автора, взятых в библиотеке. SELECT TOP(1) Authors.FirstName, Authors.LastName, COUNT(S_Cards.Id) AS Taked
FROM (Authors INNER JOIN Books 
ON Authors.Id = Books.Id_Author) 
INNER JOIN S_Cards 
ON Books.Id = S_Cards.Id_Book
GROUP BY Authors.FirstName, Authors.LastName
ORDER BY COUNT(S_Cards.Id) DESC;


--5 Вывести самого популярного автора(ов) среди преподавателей и количество книг этого автора, взятых в библиотеке. 

SELECT TOP(1) Authors.FirstName, Authors.LastName, COUNT(T_Cards.Id) AS Taked
FROM (Authors 
INNER JOIN Books
ON Authors.Id = Books.Id_Author) 
INNER JOIN T_Cards ON Books.Id = T_Cards.Id_Book
GROUP BY Authors.FirstName, Authors.LastName
ORDER BY COUNT(T_Cards.Id) DESC;


--6 Вывести самую популярную(ые) тематику(и) среди студентов и преподавателей. 
SELECT TOP(1) Themes.[Name], COUNT(T_Cards.Id) + COUNT(S_Cards.Id) AS Taked
FROM (Themes INNER JOIN Books 
ON Themes.Id = Books.Id_Themes) 
INNER JOIN T_Cards 
ON Books.Id = T_Cards.Id_Book 
INNER JOIN S_Cards
ON Books.Id = S_Cards.Id_Book
GROUP BY Themes.[Name]
ORDER BY COUNT(T_Cards.Id) + COUNT(S_Cards.Id) DESC;


--7 Отобразить количество преподавателей и студентов, посетивших библиотеку. 
SELECT COUNT(T_Cards.Id)  AS Teachers, (SELECT COUNT(*) FROM S_Cards) AS Students
FROM T_Cards


--8 Отобразить самый читающий факультет и самую читающую кафедру. 

SELECT TOP(1) Departments.[Name] AS DepartmentName, (SELECT TOP(1) Faculties.[Name] AS FaculityName
FROM Faculties JOIN Groups
ON Faculties.Id = Groups.Id_Faculty
JOIN Students
ON Groups.Id = Students.Id_Group
JOIN S_Cards
ON Students.Id = S_Cards.Id_Student
GROUP BY Faculties.[Name]
ORDER BY COUNT(S_Cards.Id) DESC) AS FaculityName
FROM Departments JOIN Teachers
ON Departments.Id = Teachers.Id_Dep
JOIN T_Cards
ON Teachers.Id = T_Cards.Id_Teacher
GROUP BY Departments.[Name]
ORDER BY COUNT(T_Cards.Id) DESC


--9 Показать автора(ов) самых популярных книг среди преподавателей и студентов. 
SELECT Authors.FirstName + Authors.LastName AS PopularAuthor
FROM Books JOIN Authors
ON Books.Id_Author = Authors.Id
JOIN T_Cards
ON Books.Id = T_Cards.Id_Book
JOIN S_Cards
ON Books.Id = S_Cards.Id_Book
GROUP BY Books.[Name], Authors.FirstName + Authors.LastName
ORDER BY COUNT(T_Cards.Id) + COUNT(S_Cards.Id) DESC

--10 Отобразить названия самых популярных книг среди преподавателей и студентов. 
SELECT Books.[Name]
FROM Books 
JOIN T_Cards
ON Books.Id = T_Cards.Id_Book
JOIN S_Cards
ON Books.Id = S_Cards.Id_Book
GROUP BY Books.[Name]
ORDER BY COUNT(T_Cards.Id) + COUNT(S_Cards.Id) DESC


--11 Показать всех студентов и преподавателей дизайнеров.
SELECT Students.FirstName + ' ' +Students.LastName AS [Name]
FROM Students JOIN Groups
ON Students.Id_Group = Groups.Id
JOIN Faculties
ON Groups.Id_Faculty = Faculties.Id
WHERE Faculties.[Name] LIKE N'%Design%' 
UNION
SELECT Teachers.FirstName + ' ' + Teachers.LastName AS [Name]
FROM Teachers JOIN Departments
ON Teachers.Id_Dep = Departments.Id
WHERE Departments.[Name] LIKE N'%Design%' 




