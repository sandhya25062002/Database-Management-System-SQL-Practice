CREATE DATABASE cs;
USE cs;

CREATE TABLE customer(
customer_id INT PRIMARY KEY,
customer_name VARCHAR(50),
city  VARCHAR(90),
grade INT,
salesman_id INT
);

CREATE TABLE Salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    commission DECIMAL(10, 2)
);

INSERT INTO Salesman 
(salesman_id, name, city, commission) 
VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5007, 'Paul Adam', 'Rome', 0.13),
(5003, 'Lauson Hen', 'San Jose', 0.12);

INSERT INTO Customer (customer_id, customer_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3008, 'Julian Green', 'London', 300, 5002),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3003, 'Jozy Altidore', 'Moscow', 200, 5007),
(3001, 'Brad Guzan', 'London', NULL, 5005);


SELECT 
    c.customer_name AS Customer,
    c.city AS City,
    s.name AS Salesman,
    s.commission AS Commission
FROM 
    Customer c
JOIN 
    Salesman s
ON 
    c.salesman_id = s.salesman_id;
