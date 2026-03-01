-- 1. INTRODUCTION TO SQL
CREATE DATABASE school_db;
USE school_db;

-- Students table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    age INT,
    class VARCHAR(20),
    address VARCHAR(100)
);

-- Records insert
INSERT INTO students VALUES
(1, 'Ravi', 12, '6th', 'Ahmedabad'),
(2, 'Priya', 11, '5th', 'Surat'),
(3, 'Amit', 13, '7th', 'Vadodara'),
(4, 'Sneha', 10, '4th', 'Rajkot'),
(5, 'Karan', 14, '8th', 'Bhavnagar');

SELECT * FROM students;

-- 2. SQL SYNTAX
SELECT student_name, age FROM students;
SELECT * FROM students WHERE age > 10;

-- 3. SQL CONSTRAINTS
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(50) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

ALTER TABLE students ADD teacher_id INT;
ALTER TABLE students
ADD CONSTRAINT fk_teacher FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id);

-- 4. DDL
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    course_credits INT
);

CREATE DATABASE university_db;
USE university_db;

-- 5. ALTER COMMAND
ALTER TABLE courses ADD course_duration VARCHAR(20);
ALTER TABLE courses DROP COLUMN course_credits;

-- 6. DROP COMMAND
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS students;
SHOW TABLES;

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_duration VARCHAR(50) NOT NULL
);

-- 7. DML
INSERT INTO courses (course_id, course_name, course_duration) VALUES
(101, 'Data Structures', '6 Months'),
(102, 'Database Systems', '1 Year'),
(103, 'Operating Systems', '6 Months'),
(104, 'Computer Networks', '1 Year'),
(105, 'Artificial Intelligence', '8 Months');

UPDATE courses SET course_duration = '9 Months' WHERE course_id = 101;
DELETE FROM courses WHERE course_id = 105;

-- 8. DQL
SELECT * FROM courses;
SELECT * FROM courses ORDER BY course_duration DESC;
SELECT * FROM courses LIMIT 2;

-- 9. DCL
GRANT SELECT ON courses TO 'user_1';
REVOKE INSERT ON courses FROM 'user_1';
GRANT INSERT ON courses TO 'user_1';

-- 10. TCL
START TRANSACTION;
INSERT INTO courses VALUES (106, 'Machine Learning', '1 Year');
COMMIT;

START TRANSACTION;
INSERT INTO courses VALUES (107, 'Cyber Security', '6 Months');
ROLLBACK;

START TRANSACTION;
SAVEPOINT sp1;
UPDATE courses SET course_duration = '2 Years' WHERE course_id = 102;
ROLLBACK TO sp1;
COMMIT;

-- 11. JOINS
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

SELECT d.dept_name, e.emp_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id;

-- 12. GROUP BY
SELECT dept_id, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id;

SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id;

-- 13. STORED PROCEDURES
DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN dep INT)
BEGIN
  SELECT * FROM employees WHERE dept_id = dep;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetCourseById(IN cid INT)
BEGIN
  SELECT * FROM courses WHERE course_id = cid;
END //
DELIMITER ;

-- 14. VIEWS
CREATE OR REPLACE VIEW emp_dept AS
SELECT e.emp_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary >= 50000;

-- 15. TRIGGERS
CREATE TABLE emp_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    action VARCHAR(20),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_emp_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO emp_log(emp_id, action) VALUES (NEW.emp_id, 'INSERT');
END //
DELIMITER ;

ALTER TABLE employees ADD last_modified TIMESTAMP;

DELIMITER //
CREATE TRIGGER before_emp_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.last_modified = CURRENT_TIMESTAMP;
END //
DELIMITER ;
