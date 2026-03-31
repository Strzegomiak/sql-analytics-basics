-- ============================================
-- CASE STUDY 2 DATASET
-- ============================================

DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- ============================================
-- TABLES
-- ============================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name TEXT,
    city TEXT,
    signup_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    category TEXT,
    amount NUMERIC(10,2),
    status TEXT
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    return_date DATE,
    return_amount NUMERIC(10,2)
);

-- ============================================
-- CUSTOMERS
-- ============================================

INSERT INTO customers VALUES
(1,'Anna Kowalska','Warsaw','2024-01-15'),
(2,'Piotr Nowak','Krakow','2024-02-10'),
(3,'Maria Wisniewska','Gdansk','2024-03-05'),
(4,'Jan Wojcik','Wroclaw','2024-03-18'),
(5,'Katarzyna Kaminska','Poznan','2024-04-02'),
(6,'Tomasz Lewandowski','Warsaw','2024-04-20'),
(7,'Agnieszka Zielinska','Krakow','2024-05-11'),
(8,'Michal Szymanski','Gdansk','2024-05-25'),
(9,'Barbara Dabrowska','Wroclaw','2024-06-07'),
(10,'Pawel Kozlowski','Poznan','2024-06-19'),
(11,'Karolina Jankowska','Warsaw','2024-07-02'),
(12,'Mateusz Mazur','Krakow','2024-07-15'),
(13,'Magdalena Kaczmarek','Gdansk','2024-08-01'),
(14,'Krzysztof Piotrowski','Wroclaw','2024-08-14'),
(15,'Monika Grabowska','Poznan','2024-09-03'),
(16,'Adam Pawlak','Warsaw','2024-09-21'),
(17,'Natalia Michalak','Krakow','2024-10-05'),
(18,'Marcin Krol','Gdansk','2024-10-22'),
(19,'Joanna Wieczorek','Wroclaw','2024-11-04'),
(20,'Rafal Dudek','Poznan','2024-11-20'),
(21,'Julia Ostrowska','Warsaw','2025-01-05'),
(22,'Kamil Tomaszewski','Krakow','2025-01-17'),
(23,'Patrycja Piasecka','Gdansk','2025-02-03'),
(24,'Daniel Zalewski','Wroclaw','2025-02-18'),
(25,'Ewa Sikora','Poznan','2025-03-01'),
(26,'Jakub Baran','Warsaw','2025-03-15'),
(27,'Weronika Gorska','Krakow','2025-04-02'),
(28,'Sebastian Nowicki','Gdansk','2025-04-18'),
(29,'Aleksandra Lis','Wroclaw','2025-05-06'),
(30,'Grzegorz Czerwinski','Poznan','2025-05-20');

-- ============================================
-- ORDERS
-- ============================================

INSERT INTO orders VALUES
(1,1,'2025-01-03','electronics',1200,'completed'),
(2,2,'2025-01-05','fashion',240,'completed'),
(3,3,'2025-01-07','home',340,'completed'),
(4,4,'2025-01-10','electronics',980,'completed'),
(5,5,'2025-01-15','beauty',120,'completed'),
(6,6,'2025-01-20','home',560,'completed'),
(7,7,'2025-01-22','fashion',300,'completed'),
(8,8,'2025-02-01','electronics',1500,'completed'),
(9,1,'2025-02-03','fashion',220,'completed'),
(10,2,'2025-02-07','beauty',90,'completed'),
(11,9,'2025-02-09','home',400,'completed'),
(12,10,'2025-02-14','electronics',2100,'completed'),
(13,11,'2025-02-18','fashion',310,'completed'),
(14,12,'2025-02-22','home',650,'completed'),
(15,3,'2025-03-02','electronics',1700,'completed'),
(16,13,'2025-03-05','beauty',140,'completed'),
(17,14,'2025-03-10','fashion',280,'completed'),
(18,15,'2025-03-14','home',720,'completed'),
(19,16,'2025-03-18','electronics',2000,'completed'),
(20,4,'2025-03-22','fashion',260,'completed'),
(21,17,'2025-04-01','electronics',1300,'completed'),
(22,18,'2025-04-04','home',500,'completed'),
(23,19,'2025-04-07','beauty',110,'completed'),
(24,20,'2025-04-11','fashion',330,'completed'),
(25,21,'2025-04-15','electronics',2200,'completed'),
(26,22,'2025-04-18','home',450,'completed'),
(27,23,'2025-05-02','fashion',310,'completed'),
(28,24,'2025-05-05','electronics',1900,'completed'),
(29,25,'2025-05-08','beauty',160,'completed'),
(30,26,'2025-05-12','home',540,'completed'),
(31,27,'2025-05-16','fashion',280,'completed'),
(32,28,'2025-05-20','electronics',2500,'completed'),
(33,29,'2025-06-01','home',610,'completed'),
(34,30,'2025-06-04','beauty',150,'completed'),
(35,1,'2025-06-08','electronics',1400,'completed'),
(36,2,'2025-06-10','fashion',270,'completed'),
(37,3,'2025-06-12','home',480,'completed'),
(38,4,'2025-06-15','electronics',1600,'completed'),
(39,5,'2025-07-01','beauty',130,'completed'),
(40,6,'2025-07-03','fashion',320,'completed'),
(41,7,'2025-07-06','home',690,'completed'),
(42,8,'2025-07-09','electronics',2300,'completed'),
(43,9,'2025-07-13','fashion',260,'completed'),
(44,10,'2025-07-17','home',530,'completed'),
(45,11,'2025-08-01','electronics',1750,'completed'),
(46,12,'2025-08-05','beauty',140,'completed'),
(47,13,'2025-08-08','fashion',350,'completed'),
(48,14,'2025-08-11','home',710,'completed'),
(49,15,'2025-08-15','electronics',2600,'completed'),
(50,16,'2025-09-01','home',640,'completed'),
(51,17,'2025-09-04','fashion',300,'completed'),
(52,18,'2025-09-08','electronics',2100,'completed'),
(53,19,'2025-09-12','beauty',120,'completed'),
(54,20,'2025-09-16','home',580,'completed'),
(55,21,'2025-10-01','electronics',2400,'completed'),
(56,22,'2025-10-04','fashion',330,'completed'),
(57,23,'2025-10-08','home',520,'completed'),
(58,24,'2025-10-12','electronics',2000,'completed'),
(59,25,'2025-10-16','beauty',170,'completed'),
(60,26,'2025-11-02','fashion',310,'completed'),
(61,27,'2025-11-06','electronics',2800,'completed'),
(62,28,'2025-11-10','home',760,'completed'),
(63,29,'2025-11-15','beauty',150,'completed'),
(64,30,'2025-11-18','fashion',340,'completed'),
(65,1,'2025-12-01','electronics',3000,'completed'),
(66,2,'2025-12-04','home',620,'completed'),
(67,3,'2025-12-08','fashion',290,'completed'),
(68,4,'2025-12-12','beauty',180,'completed');

-- ============================================
-- RETURNS
-- ============================================

INSERT INTO returns VALUES
(1,10,'2025-02-20',90),
(2,23,'2025-04-20',110),
(3,34,'2025-06-20',150),
(4,46,'2025-08-20',140),
(5,59,'2025-10-25',170);