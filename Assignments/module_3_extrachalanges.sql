
-- 1. Create Database
CREATE DATABASE library_db;
USE library_db;

-- Table: books
CREATE TABLE books (
  book_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100),
  author VARCHAR(100),
  publisher VARCHAR(100),
  year_of_publication YEAR,
  price DECIMAL(8,2)
);

-- Insert 5 records into books
INSERT INTO books (title, author, publisher, year_of_publication, price) VALUES
('Book A','Author X','Publisher P',2010,50),
('Book B','Author Y','Publisher Q',2015,120),
('Book C','Author Z','Publisher R',2020,80),
('Book D','Author X','Publisher Q',2018,60),
('Book E','Author W','Publisher P',2012,40);

-- Table: members
CREATE TABLE members (
  member_id INT PRIMARY KEY AUTO_INCREMENT,
  member_name VARCHAR(100),
  date_of_membership DATE,
  email VARCHAR(50)
);

-- Insert 5 records into members
INSERT INTO members (member_name, date_of_membership, email) VALUES
('Jeel','2019-05-10','jeel@mail.com'),
('Rahul','2021-07-15','rahul@mail.com'),
('Priya','2023-01-01','priya@mail.com'),
('Aman','2018-09-20','aman@mail.com'),
('Sneha','2022-04-05','sneha@mail.com');


-- Retrieve members who joined before 2022
SELECT * FROM members
WHERE YEAR(date_of_membership) < 2022
ORDER BY date_of_membership;


-- Titles of books by specific author (Author X), sorted by year desc
SELECT title, year_of_publication FROM books
WHERE author = 'Author X'
ORDER BY year_of_publication DESC;


-- Add CHECK for price > 0
ALTER TABLE books
ADD CONSTRAINT chk_price CHECK (price > 0);


-- Add UNIQUE on email
ALTER TABLE members
MODIFY email VARCHAR(100) UNIQUE;


-- Create authors table
CREATE TABLE authors (
  author_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  country VARCHAR(50)
);


-- ========== LAB 4 DDL ==========
-- Create publishers table
CREATE TABLE publishers (
  publisher_id INT PRIMARY KEY AUTO_INCREMENT,
  publisher_name VARCHAR(100),
  contact_number VARCHAR(20) UNIQUE,
  address VARCHAR(150)
);


-- Add genre column
ALTER TABLE books ADD genre VARCHAR(50);
-- Update genre
UPDATE books SET genre='Fiction' WHERE book_id IN (1,2,3);
UPDATE books SET genre='Science' WHERE book_id IN (4,5);


ALTER TABLE members MODIFY email VARCHAR(100);


DESCRIBE publishers;
DROP TABLE publishers;


CREATE TABLE members_backup AS SELECT * FROM members;
DROP TABLE members;


INSERT INTO authors (first_name,last_name,country) VALUES
('Chetan','Bhagat','India'),
('Arundhati','Roy','India'),
('Dan','Brown','USA');

-- Update last name of one author
UPDATE authors SET last_name='Brownie' WHERE first_name='Dan';


DELETE FROM books WHERE price > 100;


UPDATE books SET year_of_publication=2016 WHERE book_id=1;


UPDATE books SET price = price*1.1 WHERE year_of_publication < 2015;


DELETE FROM members WHERE YEAR(date_of_membership) < 2020;


DELETE FROM books WHERE author IS NULL;


SELECT * FROM books WHERE price BETWEEN 50 AND 100;


SELECT * FROM books ORDER BY author ASC LIMIT 3;


GRANT SELECT ON books TO 'user_1';


GRANT INSERT, UPDATE ON members TO 'user_1';


REVOKE INSERT ON books FROM 'user_1';


REVOKE PRIVILEGES ON members FROM 'user_1';


START TRANSACTION;
INSERT INTO books (title,author,publisher,year_of_publication,price,genre)
VALUES ('Book F','Author Test','Publisher S',2017,90,'History'),
('Book G','Author K','Publisher T',2019,70,'Novel');
COMMIT;

INSERT INTO books (title,author,publisher,year_of_publication,price,genre)
VALUES ('Book H','Author L','Publisher U',2015,55,'Drama');
ROLLBACK;


START TRANSACTION;
SAVEPOINT before_update;
UPDATE members_backup SET member_name='Updated Name' WHERE member_id=1;
ROLLBACK TO before_update;


SELECT b.title, a.first_name, a.last_name
FROM books b
INNER JOIN authors a ON b.author = CONCAT(a.first_name,' ',a.last_name);


-- FULL OUTER JOIN simulation in MySQL using UNION
SELECT b.title, a.first_name, a.last_name
FROM books b
LEFT JOIN authors a ON b.author = CONCAT(a.first_name,' ',a.last_name)
UNION
SELECT b.title, a.first_name, a.last_name
FROM books b
RIGHT JOIN authors a ON b.author = CONCAT(a.first_name,' ',a.last_name);


SELECT genre, COUNT(*) AS total_books
FROM books GROUP BY genre;


SELECT YEAR(date_of_membership) AS join_year, COUNT(*) AS total_members
FROM members_backup
GROUP BY join_year;


DELIMITER //
CREATE PROCEDURE GetBooksByAuthor(IN auth_name VARCHAR(100))
BEGIN
  SELECT * FROM books WHERE author=auth_name;
END //
DELIMITER ;

-- CALL GetBooksByAuthor('Author X');


DELIMITER //
CREATE PROCEDURE GetBookPrice(IN b_id INT)
BEGIN
  SELECT price FROM books WHERE book_id=b_id;
END //
DELIMITER ;

-- CALL GetBookPrice(2);


CREATE VIEW view_books AS
SELECT title, author, price FROM books;


CREATE VIEW view_members_before2020 AS
SELECT * FROM members_backup
WHERE YEAR(date_of_membership)<2020;


ALTER TABLE books ADD COLUMN last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

CREATE TRIGGER trg_update_books
BEFORE UPDATE ON books
FOR EACH ROW
SET NEW.last_modified = NOW();


CREATE TABLE log_changes (
  log_id INT PRIMARY KEY AUTO_INCREMENT,
  action VARCHAR(50),
  book_id INT,
  deleted_at TIMESTAMP
);

CREATE TRIGGER trg_delete_books
AFTER DELETE ON books
FOR EACH ROW
INSERT INTO log_changes(action,book_id,deleted_at)
VALUES('DELETE', OLD.book_id, NOW());

