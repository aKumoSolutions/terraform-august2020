CREATE DATABASE IF NOT EXISTS `rds_users` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `rds_users`;

CREATE TABLE IF NOT EXISTS `users` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
  	`username` varchar(40) NOT NULL,
  	`password` varchar(255) NOT NULL,
	`email` varchar(100) NOT NULL,
	`stype` varchar(10) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `clients` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
  	`username` varchar(40) NOT NULL,
  	`password` varchar(255) NOT NULL,
	`email` varchar(100) NOT NULL,
	`stype` varchar(10) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;