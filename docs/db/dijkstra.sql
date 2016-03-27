-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 27-03-2016 a las 19:04:43
-- Versión del servidor: 5.5.47-0ubuntu0.14.04.1
-- Versión de PHP: 5.5.9-1ubuntu4.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Base de datos: `dijkstra`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `links`
--

DROP TABLE IF EXISTS `links`;
CREATE TABLE IF NOT EXISTS `links` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `paths_id` int(11) NOT NULL,
  `nodes_id_from` int(10) DEFAULT NULL,
  `nodes_id_to` int(10) DEFAULT NULL,
  `cost` int(10) DEFAULT '0',
  `title` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Volcado de datos para la tabla `links`
--

INSERT INTO `links` (`id`, `paths_id`, `nodes_id_from`, `nodes_id_to`, `cost`, `title`, `create_date`) VALUES
(9, 9, 9, 10, 1, '', '2016-03-03 04:36:56'),
(10, 9, 10, 9, 1, '', '2016-03-27 03:55:43');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

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
(8, 1, 'V7', 1335, 759),
(9, 9, 'FUU', 514, 102),
(10, 9, 'BAR', 413, 289),
(11, 9, 'BAR', 178, 170);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paths`
--

DROP TABLE IF EXISTS `paths`;
CREATE TABLE IF NOT EXISTS `paths` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Volcado de datos para la tabla `paths`
--

INSERT INTO `paths` (`id`, `title`, `create_date`) VALUES
(9, 'FUU', '2016-03-03 04:26:33');
