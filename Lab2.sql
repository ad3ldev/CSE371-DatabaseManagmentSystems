-- DDL Commands that create the tables and schema
CREATE SCHEMA LIBRARY;

CREATE TABLE PUBLISHER(Name varchar(50),Address varchar(100),Phone varchar(25),primary key (Name));

CREATE TABLE BOOK(Book_id Int,Title varchar(50),Publisher_name varchar(50),primary key (Book_id),foreign key (Publisher_name) references PUBLISHER (Name) on update cascade on delete set null);

CREATE TABLE BOOK_AUTHORS(Book_id Int,Author_name varchar(50),primary key (Book_id, Author_name),foreign key (Book_id) references BOOK (Book_id) on update cascade);

CREATE TABLE LIBRARY_BRANCH(Branch_id Int,Branch_name varchar(50),Address varchar(100),primary key (Branch_id));

CREATE TABLE BORROWER (Card_no Int,Name varchar(50),Address varchar(100),Phone varchar(25),primary key (Card_no));

CREATE TABLE BOOK_COPIES(Book_id Int,Branch_id Int,No_of_copies Int,primary key (Book_id, Branch_id),foreign key (Book_id) references BOOK (Book_id) on update cascade,foreign key (Branch_id) references LIBRARY_BRANCH (Branch_id) on update cascade);

CREATE TABLE BOOK_LOANS (Book_id Int,Branch_id Int,Card_no Int,Date_out date,Due_date date,primary key (Book_id, Branch_id, Card_id),foreign key (Book_id) references BOOK (Book_id) on update cascade,foreign key (Branch_id) references LIBRARY_BRANCH (Branch_id) on update cascade,foreign key (Card_no) references BORROWER (Card_no) on update cascade);

ALTER TABLE BORROWER ADD UNIQUE (Phone);

ALTER TABLE PUBLISHER ADD UNIQUE (Phone);

-- DML Commands to insert the data

INSERT INTO PUBLISHER VALUES
("A", "A Street", "+111"), 
("B","B Street","+222"), 
("C", "C Street", "+333"),
("D", "D Street", "+444");

INSERT INTO BOOK VALUES 
(1,"The Lost Tribe", "A"),
(2,"Harry Potter", "B"),
(3,"One Piece", "C"),
(4,"Mockingbird", "D");

INSERT INTO BOOK_AUTHORS VALUES 
(1,"Generic Author"),
(2, "JK Rolling"),
(3, "Eiichiro Oda"),
(4, "Generic Author");

INSERT INTO LIBRARY_BRANCH VALUES 
(1, "Branch 1", "Branch 1 Street"),
(2, "Branch 2", "Branch 2 Street"),
(3, "Branch 3", "Branch 3 Street"),
(4,"Branch 4", "Branch 4 Street");

INSERT INTO BORROWER VALUES 
(111, "AAA", "A Street", "+111"),
(222, "BBB", "B Street", "+222"),
(333, "CCC", "C Street", "+333"),
(444, "DDD", "A Street", "+444");

INSERT INTO BOOK_COPIES VALUES
(3, 1, 1068),
(3, 2, 1068),
(3, 3, 1068),
(3, 4, 1068),
(1, 2, 100),
(2, 3, 100),
(4, 4, 200);

INSERT INTO BOOK_LOANS VALUES 
(3,1,111,'2008-7-04', '2008-7-04'),
(3,2,222,'2008-7-04', '2008-7-04'),
(2,1,444,'2008-7-04', '2008-7-04'),
(1,2,333, '2008-7-04', '2008-7-04');

INSERT INTO LIBRARY_BRANCH VALUES 
(5, "Sharpstown", "23 Sharpstown Stree");

INSERT INTO BOOK_COPIES VALUES
(1, 1, 100),
(1, 3, 100),
(1, 4, 200);

INSERT INTO BORROWER VALUES 
(555, "EEE", "E Street", "+555");

INSERT INTO BOOK_COPIES VALUES 
(1,5,250),
(3,5,1068);

INSERT INTO BOOK_LOANS VALUES 
(3,5,111,'2008-7-04', CURDATE()),
(1,5,111,'2008-7-04', CURDATE()),
(3,5,333,'2008-7-04', CURDATE());

INSERT INTO BOOK VALUES
(5, "IT", "A"),
(6, "The Shining","B"),
(7, "Fairy Tale", "C"),
(8, "Carrie", "D"),
(9, "The Stand", "A");

Insert INTO BOOK_AUTHORS VALUES 
(5,"Stephen King"),
(6,"Stephen King"),
(7,"Stephen King"),
(8,"Stephen King"),
(9,"Stephen King");

INSERT INTO BOOK_LOANS VALUES
(5,5,111,'2008-7-04', CURDATE()), 
(6,5,111,'2008-7-04', CURDATE()),
(7,5,333,'2008-7-04', CURDATE()),
(8,5,333,'2008-7-04', CURDATE()),
(9,1,333,'2008-7-04', CURDATE()),
(3,1,333,'2008-7-04', CURDATE()),
(3,2,333,'2008-7-04', CURDATE());

INSERT INTO BOOK_LOANS VALUES 
(7,4,111,'2008-7-04', CURDATE()),
(8,4,111,'2008-7-04', CURDATE()),
(9,4,111,'2008-7-04', CURDATE()),
(8,5,111,'2008-7-04', CURDATE()),
(9,5,111,'2008-7-04', CURDATE());

INSERT INTO LIBRARY_BRANCH VALUES 
(6, "Central", "Central Street");

INSERT INTO BOOK_COPIES VALUES 
(5, 5, 123),
(7, 6, 213),
(8, 6, 1327),
(9, 6, 305);

-- SELECT statements that are required

SELECT No_Of_Copies 
FROM BOOK, BOOK_COPIES, LIBRARY_BRANCH
WHERE BOOK.Book_id = BOOK_COPIES.Book_id 
AND LIBRARY_BRANCH.Branch_id = BOOK_COPIES.Branch_id
AND Title="The Lost Tribe" AND Branch_name='Sharpstown';

SELECT LIBRARY_BRANCH.Branch_name, No_Of_Copies
FROM BOOK, BOOK_COPIES, LIBRARY_BRANCH
WHERE BOOK.Book_id = BOOK_COPIES.Book_id 
AND LIBRARY_BRANCH.Branch_id = BOOK_COPIES.Branch_id
AND Title="The Lost Tribe"

SELECT Name 
FROM BORROWER 
WHERE Card_no NOT IN (SELECT Card_no FROM BOOK_LOANS);

SELECT BOOK.Title, BORROWER.Name, BORROWER.Address
FROM BOOK, BORROWER, BOOK_LOANS, LIBRARY_BRANCH
WHERE BORROWER.Card_no = BOOK_LOANS.Card_no
AND BOOK_LOANS.Book_id = BOOK.Book_id
AND LIBRARY_BRANCH.Branch_id = BOOK_LOANS.Branch_id
AND BOOK_LOANS.Due_date = CURDATE() AND Branch_name = "Sharpstown"

SELECT LIBRARY_BRANCH.Branch_name, COUNT(BOOK_LOANS.Book_id)
FROM BOOK_LOANS, LIBRARY_BRANCH
WHERE LIBRARY_BRANCH.Branch_id = BOOK_LOANS.Branch_id
GROUP BY LIBRARY_BRANCH.Branch_name

SELECT BORROWER.name, BORROWER.Address, count(BOOK_LOANS.card_no)
FROM BORROWER, BOOK_LOANS
WHERE BORROWER.card_no = BOOK_LOANS.card_no
Group by (Borrower.CARD_No)
Having count(BOOK_LOANS.Card_no) > 5;

SELECT BOOK.Title, BOOK_COPIES.No_of_copies
FROM BOOK, LIBRARY_BRANCH, BOOK_COPIES, BOOK_AUTHORS
WHERE BOOK_AUTHORS.Author_name = "Stephen King"
AND LIBRARY_BRANCH.Branch_name = "Central"
AND BOOK_AUTHORS.Book_id = BOOK.Book_id
AND BOOK_COPIES.Book_id = BOOK.Book_id
AND BOOK_COPIES.Branch_id = LIBRARY_BRANCH.Branch_id
