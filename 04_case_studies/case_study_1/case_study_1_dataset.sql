/*
CASE STUDY 1
Dataset

Transactional sales data for 2025.
Each row represents one transaction.
*/

DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    transaction_id INT,
    customer_id INT,
    customer_name TEXT,
    city TEXT,
    product TEXT,
    category TEXT,
    amount NUMERIC(10,2),
    transaction_date DATE
);


INSERT INTO transactions VALUES
(1, 101, 'Anna Kowalska', 'Krakow', 'Laptop', 'Electronics', 4200, '2025-01-05'),
(2, 102, 'Jan Nowak', 'Warsaw', 'Mouse', 'Electronics', 120, '2025-01-07'),
(3, 103, 'Piotr Zielinski', 'Krakow', 'Desk', 'Furniture', 850, '2025-01-12'),
(4, 104, 'Maria Wisniewska', 'Gdansk', 'Chair', 'Furniture', 430, '2025-01-15'),
(5, 105, 'Katarzyna Lewandowska', 'Wroclaw', 'Monitor', 'Electronics', 980, '2025-01-20'),

(6, 101, 'Anna Kowalska', 'Krakow', 'Keyboard', 'Electronics', 260, '2025-02-02'),
(7, 106, 'Tomasz Kaczmarek', 'Poznan', 'Desk', 'Furniture', 920, '2025-02-05'),
(8, 107, 'Agnieszka Mazur', 'Warsaw', 'Laptop', 'Electronics', 3900, '2025-02-11'),
(9, 108, 'Pawel Piotrowski', 'Krakow', 'Lamp', 'Furniture', 210, '2025-02-18'),
(10, 102, 'Jan Nowak', 'Warsaw', 'Headphones', 'Electronics', 540, '2025-02-22'),

(11, 109, 'Karolina Dabrowska', 'Gdansk', 'Chair', 'Furniture', 470, '2025-03-01'),
(12, 103, 'Piotr Zielinski', 'Krakow', 'Monitor', 'Electronics', 1100, '2025-03-03'),
(13, 110, 'Michal Krupa', 'Wroclaw', 'Desk', 'Furniture', 880, '2025-03-10'),
(14, 105, 'Katarzyna Lewandowska', 'Wroclaw', 'Laptop', 'Electronics', 4100, '2025-03-12'),
(15, 111, 'Natalia Pawlak', 'Poznan', 'Mouse', 'Electronics', 150, '2025-03-18'),

(16, 112, 'Adam Michalski', 'Krakow', 'Chair', 'Furniture', 390, '2025-04-02'),
(17, 101, 'Anna Kowalska', 'Krakow', 'Monitor', 'Electronics', 990, '2025-04-05'),
(18, 113, 'Julia Piasecka', 'Warsaw', 'Desk', 'Furniture', 970, '2025-04-11'),
(19, 114, 'Robert Wrobel', 'Gdansk', 'Laptop', 'Electronics', 4500, '2025-04-19'),
(20, 115, 'Patrycja Ostrowska', 'Poznan', 'Lamp', 'Furniture', 240, '2025-04-21'),

(21, 108, 'Pawel Piotrowski', 'Krakow', 'Keyboard', 'Electronics', 300, '2025-05-04'),
(22, 116, 'Mateusz Baran', 'Wroclaw', 'Desk', 'Furniture', 910, '2025-05-06'),
(23, 102, 'Jan Nowak', 'Warsaw', 'Monitor', 'Electronics', 1050, '2025-05-14'),
(24, 117, 'Dominika Czarnecka', 'Gdansk', 'Chair', 'Furniture', 410, '2025-05-18'),
(25, 118, 'Lukasz Kubiak', 'Poznan', 'Laptop', 'Electronics', 4300, '2025-05-22'),

(26, 119, 'Magdalena Adamczyk', 'Krakow', 'Lamp', 'Furniture', 260, '2025-06-01'),
(27, 103, 'Piotr Zielinski', 'Krakow', 'Mouse', 'Electronics', 130, '2025-06-07'),
(28, 120, 'Grzegorz Sikora', 'Warsaw', 'Desk', 'Furniture', 940, '2025-06-15'),
(29, 105, 'Katarzyna Lewandowska', 'Wroclaw', 'Headphones', 'Electronics', 620, '2025-06-18'),
(30, 121, 'Oliwia Dudek', 'Gdansk', 'Chair', 'Furniture', 450, '2025-06-25');