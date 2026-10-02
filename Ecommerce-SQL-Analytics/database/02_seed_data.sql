USE ecommerce_analytics;

INSERT INTO customers
(first_name,last_name,email,phone,city,state,signup_date,status) VALUES
('Aarav','Sharma','aarav@example.com','9000000001','Mumbai','Maharashtra','2025-01-10','ACTIVE'),
('Anaya','Patel','anaya@example.com','9000000002','Pune','Maharashtra','2025-02-15','ACTIVE'),
('Rohan','Mehta','rohan@example.com','9000000003','Nashik','Maharashtra','2025-03-20','ACTIVE'),
('Isha','Kulkarni','isha@example.com','9000000004','Thane','Maharashtra','2025-04-11','ACTIVE'),
('Kabir','Joshi','kabir@example.com','9000000005','Nagpur','Maharashtra','2025-05-05','ACTIVE'),
('Myra','Shah','myra@example.com','9000000006','Mumbai','Maharashtra','2025-06-18','ACTIVE'),
('Vivaan','Desai','vivaan@example.com','9000000007','Surat','Gujarat','2025-07-01','ACTIVE'),
('Sara','Khan','sara@example.com','9000000008','Bengaluru','Karnataka','2025-07-25','ACTIVE'),
('Aditya','Patil','aditya@example.com','9000000009','Pune','Maharashtra','2025-08-09','ACTIVE'),
('Diya','Verma','diya@example.com','9000000010','Delhi','Delhi','2025-09-12','ACTIVE'),
('Neel','Singh','neel@example.com','9000000011','Mumbai','Maharashtra','2025-10-02','ACTIVE'),
('Tara','Nair','tara@example.com','9000000012','Kochi','Kerala','2025-10-18','INACTIVE');

INSERT INTO addresses
(customer_id,address_type,address_line,city,state,postal_code) VALUES
(1,'HOME','12 MG Road','Mumbai','Maharashtra','400001'),
(2,'HOME','44 FC Road','Pune','Maharashtra','411004'),
(3,'HOME','18 College Road','Nashik','Maharashtra','422005'),
(4,'HOME','9 Station Road','Thane','Maharashtra','400601'),
(5,'HOME','21 Central Avenue','Nagpur','Maharashtra','440001'),
(6,'HOME','8 Linking Road','Mumbai','Maharashtra','400052'),
(7,'HOME','77 Ring Road','Surat','Gujarat','395003'),
(8,'HOME','5 MG Road','Bengaluru','Karnataka','560001'),
(9,'HOME','31 Baner Road','Pune','Maharashtra','411045'),
(10,'HOME','10 Nehru Place','Delhi','Delhi','110019'),
(11,'HOME','19 Powai Road','Mumbai','Maharashtra','400076'),
(12,'HOME','3 Marine Drive','Kochi','Kerala','682001');

INSERT INTO categories (category_name,parent_category_id) VALUES
('Electronics',NULL),
('Computers',1),
('Audio',1),
('Accessories',NULL),
('Home & Kitchen',NULL),
('Fitness',NULL);

INSERT INTO suppliers (supplier_name,city,rating) VALUES
('TechSource India','Mumbai',4.70),
('DigitalHub','Pune',4.40),
('Prime Distributors','Delhi',4.20),
('HomeMart Supplies','Nashik',4.60),
('FitLife Wholesale','Bengaluru',4.30);

INSERT INTO products
(product_name,category_id,sku,cost_price,selling_price,stock_quantity,reorder_level,created_at) VALUES
('Wireless Mouse',4,'ACC-MOU-001',450,799,80,15,'2025-01-15'),
('Mechanical Keyboard',2,'COM-KEY-001',2200,3499,45,10,'2025-01-20'),
('Bluetooth Headphones',3,'AUD-HEA-001',1800,2999,35,8,'2025-02-02'),
('Laptop Stand',4,'ACC-STA-001',700,1299,55,12,'2025-02-15'),
('USB-C Hub',4,'ACC-HUB-001',900,1699,70,15,'2025-03-01'),
('27 Inch Monitor',2,'COM-MON-001',9500,13999,20,5,'2025-03-18'),
('Webcam Full HD',2,'COM-WEB-001',2100,3299,30,7,'2025-04-05'),
('Smart Speaker',1,'ELE-SPK-001',2400,3999,25,6,'2025-04-22'),
('Power Bank 20000mAh',1,'ELE-PBK-001',1100,1999,60,12,'2025-05-10'),
('Water Bottle',5,'HOM-BOT-001',300,599,100,20,'2025-05-25'),
('Yoga Mat',6,'FIT-YOG-001',500,999,75,15,'2025-06-01'),
('Resistance Bands',6,'FIT-RES-001',350,799,90,20,'2025-06-15');

INSERT INTO product_suppliers VALUES
(1,1,420,5),(2,1,2100,7),(3,2,1750,6),(4,4,650,5),
(5,1,850,7),(6,1,9000,10),(7,2,1950,8),(8,3,2250,9),
(9,3,1000,8),(10,4,270,4),(11,5,450,6),(12,5,300,6);

INSERT INTO orders
(customer_id,order_date,status,shipping_city,discount_amount,shipping_fee) VALUES
(1,'2025-06-05 10:15:00','DELIVERED','Mumbai',100,50),
(2,'2025-06-12 14:30:00','DELIVERED','Pune',0,50),
(3,'2025-07-03 09:10:00','DELIVERED','Nashik',150,0),
(1,'2025-07-20 18:20:00','DELIVERED','Mumbai',50,50),
(4,'2025-08-02 11:40:00','DELIVERED','Thane',0,40),
(5,'2025-08-15 16:00:00','DELIVERED','Nagpur',100,60),
(6,'2025-09-05 12:15:00','DELIVERED','Mumbai',0,50),
(7,'2025-09-18 19:05:00','DELIVERED','Surat',200,0),
(8,'2025-10-01 13:20:00','DELIVERED','Bengaluru',0,50),
(2,'2025-10-14 15:45:00','DELIVERED','Pune',100,50),
(9,'2025-11-03 17:30:00','DELIVERED','Pune',0,50),
(1,'2025-11-15 10:10:00','DELIVERED','Mumbai',250,0),
(10,'2025-12-01 20:00:00','SHIPPED','Delhi',0,80),
(11,'2025-12-05 12:30:00','CONFIRMED','Mumbai',0,50),
(3,'2025-12-10 09:40:00','CANCELLED','Nashik',0,50),
(4,'2026-01-05 14:10:00','DELIVERED','Thane',100,40),
(5,'2026-01-18 18:00:00','DELIVERED','Nagpur',0,60),
(6,'2026-02-02 11:25:00','DELIVERED','Mumbai',150,0),
(7,'2026-02-14 16:40:00','DELIVERED','Surat',0,50),
(8,'2026-02-28 13:00:00','DELIVERED','Bengaluru',100,50),
(9,'2026-03-10 17:15:00','DELIVERED','Pune',0,50),
(11,'2026-03-20 10:00:00','DELIVERED','Mumbai',100,0);

INSERT INTO order_items
(order_id,product_id,quantity,unit_price,unit_cost,discount) VALUES
(1,1,2,799,450,0),(1,4,1,1299,700,50),
(2,2,1,3499,2200,0),(2,5,1,1699,900,0),
(3,3,1,2999,1800,100),(3,10,2,599,300,50),
(4,6,1,13999,9500,0),
(5,7,1,3299,2100,0),(5,1,1,799,450,0),
(6,8,1,3999,2400,0),(6,9,1,1999,1100,50),
(7,3,1,2999,1800,0),(7,11,1,999,500,0),
(8,6,1,13999,9500,200),
(9,8,1,3999,2400,0),(9,12,2,799,350,0),
(10,2,1,3499,2200,100),(10,4,1,1299,700,0),
(11,6,1,13999,9500,0),(11,5,1,1699,900,0),
(12,3,2,2999,1800,200),(12,1,1,799,450,0),
(13,9,2,1999,1100,0),
(14,7,1,3299,2100,0),
(16,4,2,1299,700,0),(16,10,2,599,300,0),
(17,2,1,3499,2200,0),(17,12,2,799,350,0),
(18,6,1,13999,9500,150),(18,1,2,799,450,0),
(19,8,1,3999,2400,0),(19,11,2,999,500,50),
(20,3,1,2999,1800,0),(20,5,1,1699,900,0),
(21,6,1,13999,9500,0),(21,2,1,3499,2200,0),
(22,1,3,799,450,0),(22,12,3,799,350,100);

INSERT INTO payments
(order_id,payment_method,payment_status,amount,paid_at) VALUES
(1,'UPI','PAID',2097,'2025-06-05 10:16:00'),
(2,'CARD','PAID',5198,'2025-06-12 14:31:00'),
(3,'UPI','PAID',3947,'2025-07-03 09:11:00'),
(4,'CARD','PAID',13999,'2025-07-20 18:21:00'),
(5,'COD','PAID',4098,'2025-08-04 11:00:00'),
(6,'UPI','PAID',5848,'2025-08-15 16:01:00'),
(7,'WALLET','PAID',3998,'2025-09-05 12:16:00'),
(8,'CARD','PAID',13799,'2025-09-18 19:06:00'),
(9,'UPI','PAID',5597,'2025-10-01 13:21:00'),
(10,'CARD','PAID',4698,'2025-10-14 15:46:00'),
(11,'CARD','PAID',15648,'2025-11-03 17:31:00'),
(12,'UPI','PAID',5798,'2025-11-15 10:11:00'),
(13,'COD','PENDING',4078,NULL),
(14,'UPI','PAID',3349,'2025-12-05 12:31:00'),
(16,'CARD','PAID',3636,'2026-01-05 14:11:00'),
(17,'UPI','PAID',5097,'2026-01-18 18:01:00'),
(18,'CARD','PAID',15547,'2026-02-02 11:26:00'),
(19,'UPI','PAID',4948,'2026-02-14 16:41:00'),
(20,'WALLET','PAID',4598,'2026-02-28 13:01:00'),
(21,'CARD','PAID',17448,'2026-03-10 17:16:00'),
(22,'UPI','PAID',4697,'2026-03-20 10:01:00');

INSERT INTO reviews
(customer_id,product_id,rating,review_text,review_date) VALUES
(1,1,5,'Reliable and smooth mouse.','2025-06-15'),
(2,2,5,'Excellent keyboard for coding.','2025-06-20'),
(3,3,4,'Good audio quality.','2025-07-12'),
(4,7,4,'Clear webcam for meetings.','2025-08-15'),
(5,8,5,'Great speaker.','2025-08-25'),
(6,3,4,'Comfortable headphones.','2025-09-20'),
(7,6,5,'Excellent monitor.','2025-09-30'),
(8,8,4,'Good smart speaker.','2025-10-20'),
(2,4,5,'Very useful for laptop setup.','2025-10-25'),
(9,6,5,'Great screen for work.','2025-11-20'),
(1,3,4,'Good for the price.','2025-11-25'),
(4,10,5,'Good quality bottle.','2026-01-15'),
(5,2,5,'Keyboard feels premium.','2026-01-30'),
(6,6,4,'Good monitor but expensive.','2026-02-15'),
(7,11,5,'Comfortable mat.','2026-02-20'),
(8,3,4,'Nice sound.','2026-03-05'),
(9,6,5,'Very happy with purchase.','2026-03-15');
