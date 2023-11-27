-- SETUP
DROP DATABASE IF EXISTS bookstore;
CREATE DATABASE bookstore;
USE bookstore;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS language;
DROP TABLE IF EXISTS bookstore;
DROP TABLE IF EXISTS users;
DROP VIEW IF EXISTS total_author_book_value;
DROP USER 'admin'@'localhost';
DROP USER 'web_server'@'localhost';





-- TABLES
CREATE TABLE author(
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    birth_date VARCHAR(8));

CREATE TABLE language(
    language_id INT PRIMARY KEY,
    language_name VARCHAR(100) UNIQUE);

CREATE TABLE book (
    ISBN VARCHAR(13) PRIMARY KEY,
    language varchar(100),
    title VARCHAR(255),
    price VARCHAR(255),
    publication_date VARCHAR(8),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES author(id),
    FOREIGN KEY (language) REFERENCES language(language_name));

CREATE TABLE bookstore (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    city VARCHAR(50));

CREATE TABLE inventory(
    store_id INT,
    ISBN varchar(13),
    amount INT,
    PRIMARY KEY (store_id, ISBN),
    FOREIGN KEY (store_id) REFERENCES bookstore(id),
    FOREIGN KEY (ISBN) REFERENCES book(ISBN)
);
CREATE TABLE users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE,
    password VARCHAR(255),
    access_level varchar(50)
);

INSERT INTO language (language_id, language_name)
VALUES(1,'ENGLISH');
INSERT INTO language (language_id, language_name)
VALUES (2, 'SWEDISH');
INSERT INTO author (first_name, last_name, birth_date)
VALUES ( 'JOHN', 'DOE', '20020611');

SELECT * FROM author;
INSERT INTO author ( first_name, last_name, birth_date)
VALUES ('JANE', 'SMITH', '20000909');

INSERT INTO book (ISBN, language, title, price, publication_date, author_id)
VALUES ('1234567891011', 'ENGLISH', 'HOW TO CODE', '399', '930213', 1 );

INSERT INTO book (ISBN, language, title, price, publication_date, author_id)
VALUES ('1101987654321', 'SWEDISH', 'WEBDEV', '399', '990611', 2);

INSERT INTO bookstore (name, city)
VALUES ('BOOKSNSTUFF', 'PITEÅ');

INSERT INTO bookstore (name, city)
VALUES ('STUFFNBOOKS', 'LULEÅ');

INSERT INTO inventory (store_id, ISBN, amount)
VALUES (1, '1234567891011', 5 );
INSERT INTO inventory (store_id, ISBN, amount)
VALUES (2, '1101987654321', 10);

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin123';
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE ON bookstore.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;

CREATE USER 'web_server'@'localhost' IDENTIFIED BY 'web_server123';
GRANT SELECT, INSERT,UPDATE, DELETE ON bookstore.* TO 'web_server'@'localhost';
FLUSH PRIVILEGES;



CREATE VIEW total_author_book_value AS
SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS name,
    TIMESTAMPDIFF(YEAR, STR_TO_DATE(a.birth_date, '%Y%m%d'), CURRENT_DATE) AS age,
    COUNT(DISTINCT b.title) AS book_title_count,
    SUM(CAST(b.price AS DECIMAL(10, 2)) * i.amount) AS inventory_value
FROM
    author a
        JOIN
    book b ON a.id = b.author_id
        JOIN
    inventory i ON b.ISBN = i.ISBN
GROUP BY
    a.id;
SELECT * FROM total_author_book_value LIMIT 2;
