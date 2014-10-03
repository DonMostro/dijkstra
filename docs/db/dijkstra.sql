-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 03-10-2014 a las 14:20:44
-- Versión del servidor: 5.5.38-0ubuntu0.14.04.1
-- Versión de PHP: 5.5.9-1ubuntu4.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Base de datos: `dijkstra`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_modules`
--

DROP TABLE IF EXISTS `acl_modules`;
CREATE TABLE IF NOT EXISTS `acl_modules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `title` char(200) DEFAULT NULL,
  `module` char(200) DEFAULT NULL,
  `tree` enum('0','1') NOT NULL DEFAULT '1',
  `type` enum('xml','zend_module','legacy','iframe') NOT NULL DEFAULT 'xml',
  `approved` enum('0','1') NOT NULL,
  `refresh_on_load` enum('0','1') NOT NULL DEFAULT '0',
  `order` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `root` enum('0','1') CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `icons_id` int(11) DEFAULT NULL,
  `ownership` enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `module` (`module`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Volcado de datos para la tabla `acl_modules`
--

INSERT INTO `acl_modules` (`id`, `parent_id`, `title`, `module`, `tree`, `type`, `approved`, `refresh_on_load`, `order`, `root`, `icons_id`, `ownership`) VALUES
(9, 1, 'Configuraci&oacute;n del Sitio', 'settings.xml', '1', 'xml', '1', '0', 0, '1', 1, '0'),
(8, 1, 'Perfiles', 'roles.xml', '1', 'xml', '1', '0', 0, '1', 1, '0'),
(7, 1, 'Servidor', 'phpinfo.xml', '1', 'xml', '1', '0', 0, '1', 1, '0'),
(5, 1, 'Usuarios', 'users.xml', '1', 'xml', '1', '0', 0, '0', 6, '0'),
(4, 1, 'M&oacute;dulos', 'modules.xml', '1', 'xml', '1', '0', 7, '1', 3, '0'),
(3, NULL, 'Datos Personales', 'personal-info.xml', '0', 'xml', '1', '0', 0, '0', 6, '0'),
(2, NULL, 'Caminos', 'paths.xml', '1', 'xml', '1', '0', 0, '0', 1, '0'),
(1, NULL, 'Configuraci&oacute;n', NULL, '1', 'xml', '1', '0', 11, '0', 5, '0'),
(10, 1, '&Iacute;conos', 'icons.xml', '1', 'xml', '0', '0', 0, '1', 7, '0'),
(12, 2, 'Nodos', 'nodes.xml', '0', 'xml', '1', '0', 0, '0', 0, '0'),
(13, 2, 'Enlaces', 'links.xml', '0', 'xml', '1', '0', 0, '0', 0, '0'),
(14, NULL, 'Matriz de Adyacencia', 'adjacency-matrix', '1', 'zend_module', '1', '0', 3, '0', 8, '0'),
(15, NULL, 'Presentaci&oacute;n', '/presentation', '1', 'iframe', '1', '0', 2, '0', 8, '0');
