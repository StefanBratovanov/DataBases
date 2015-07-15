DROP DATABASE IF EXISTS `orders`;

CREATE DATABASE `orders` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;

USE `orders`;

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `price`DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`Id`));
  
  DROP TABLE IF EXISTS `customers`;
  
  CREATE TABLE `customers` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `Name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`Id`)  );

  DROP TABLE IF EXISTS `orders`;

  CREATE TABLE `orders` (
  `Id` INT NOT NULL AUTO_INCREMENT ,
  `Date` datetime NOT NULL,
  PRIMARY KEY (`Id`)  );
  
  CREATE TABLE `order_items` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `orderId` INT NOT NULL ,
  `productId` INT NOT NULL,
  `quantity` DECIMAL(10,2) NOT NULL ,
  PRIMARY KEY (`Id`)  );
  
  
ALTER TABLE `order_items` 
ADD CONSTRAINT `fk_order_items_orders` FOREIGN KEY (`orderId`)  REFERENCES `orders`.`orders` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_order_items_products` FOREIGN KEY (`productId`) REFERENCES `orders`.`products` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
  
INSERT INTO `products` VALUES (1,'beer',1.20), (2,'cheese',9.50), (3,'rakiya',12.40), (4,'salami',6.33), (5,'tomatos',2.50), (6,'cucumbers',1.35), (7,'water',0.85), (8,'apples',0.75);
INSERT INTO `customers` VALUES (1,'Peter'), (2,'Maria'), (3,'Nakov'), (4,'Vlado');
INSERT INTO `orders` VALUES (1,'2015-02-13 13:47:04'), (2,'2015-02-14 22:03:44'), (3,'2015-02-18 09:22:01'), (4,'2015-02-11 20:17:18');
INSERT INTO `order_items` VALUES (12,4,6,2.00), (13,3,2,4.00), (14,3,5,1.50), (15,2,1,6.00), (16,2,3,1.20), (17,1,2,1.00), (18,1,3,1.00), (19,1,4,2.00), (20,1,5,1.00), (21,3,1,4.00), (22,1,1,3.00);

SELECT
p.Name  AS product_name,
COUNT(oi.productId) AS num_orders, 
IFNULL(SUM(oi.quantity), 0) AS quantity,
p.price,
IFNULL(SUM(oi.quantity) * p.price, 0) AS total_price

FROM products p 
LEFT JOIN order_items oi ON p.id = oi.productId
LEFT JOIN orders o ON oi.orderId = o.id
GROUP BY p.id 
ORDER BY p.Name
  
  
  
  
  
  
  