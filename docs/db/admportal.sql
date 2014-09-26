-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 24-06-2013 a las 12:15:10
-- Versión del servidor: 5.5.31
-- Versión de PHP: 5.4.6-1ubuntu1.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Base de datos: `dijkstra`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nodes`
--

DROP TABLE IF EXISTS `nodes`;
CREATE TABLE IF NOT EXISTS `nodes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `paths_id` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `x` int(11) NOT NULL DEFAULT '200',
  `y` int(11) NOT NULL DEFAULT '200',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Volcado de datos para la tabla `nodes`
--

INSERT INTO `nodes` (`id`, `paths_id`, `title`, `x`, `y`) VALUES
(1, 1, 'V0', 1048, 372),
(2, 1, 'V1', 351, 460),
(3, 1, 'V2', 507, 565),
(4, 1, 'V3', 777, 129),
(5, 1, 'V4', 782, 549),
(6, 1, 'V5', 621, 489),
(7, 1, 'V6', 1363, 402),
(8, 1, 'V7', 1335, 759);
