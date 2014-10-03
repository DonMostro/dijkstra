CREATE DATABASE IF NOT EXISTS `dijkstra`;

USE `dijkstra`;

GRANT ALL ON dijkstra.* to dijkstrauser identified by 'dijkstrapass';
GRANT ALL ON dijkstra.* to dijkstrauser@localhost identified by 'dijkstrapass';