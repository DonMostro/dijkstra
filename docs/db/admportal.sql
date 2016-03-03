-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 03-03-2016 a las 01:41:42
-- Versión del servidor: 5.5.47-0ubuntu0.14.04.1
-- Versión de PHP: 5.5.9-1ubuntu4.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Base de datos: `dijkstra`
--
CREATE DATABASE IF NOT EXISTS `dijkstra` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `dijkstra`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_actions`
--

DROP TABLE IF EXISTS `acl_actions`;
CREATE TABLE IF NOT EXISTS `acl_actions` (
  `id` varchar(10) NOT NULL,
  `title` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `acl_actions`
--

INSERT INTO `acl_actions` (`id`, `title`) VALUES
('ADD', 'Agregar'),
('DELETE', 'Eliminar'),
('EDIT', 'Editar'),
('LIST', 'Listar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_groups`
--

DROP TABLE IF EXISTS `acl_groups`;
CREATE TABLE IF NOT EXISTS `acl_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(45) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  `approved` enum('0','1') DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_groups_modules_actions`
--

DROP TABLE IF EXISTS `acl_groups_modules_actions`;
CREATE TABLE IF NOT EXISTS `acl_groups_modules_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acl_modules_actions_id` int(10) NOT NULL,
  `acl_groups_id` int(11) NOT NULL,
  `acl_modules_item_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `acl_modules_actions_id` (`acl_modules_actions_id`,`acl_groups_id`,`acl_modules_item_id`),
  KEY `fk_acl_groups_modules_actions_acl_modules_actions1` (`acl_modules_actions_id`),
  KEY `fk_acl_groups_modules_actions_acl_groups1` (`acl_groups_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_modules`
--

DROP TABLE IF EXISTS `acl_modules`;
CREATE TABLE IF NOT EXISTS `acl_modules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL COMMENT 'Id de Módulo padre',
  `title` char(200) DEFAULT NULL COMMENT 'Nombre',
  `module` char(200) DEFAULT NULL COMMENT 'Url de módulo, puede ser archivo XML, URl de controlador o módulo ZF',
  `tree` enum('0','1') NOT NULL DEFAULT '1',
  `refresh_on_load` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'Define si módulo debe ser refrescado al reseleccionar la pestaña, en caso contrario mantendrá el estatus de como se dejó al abandonarla.',
  `type` enum('xml','zend_module','iframe') DEFAULT NULL,
  `approved` enum('0','1') NOT NULL DEFAULT '1',
  `order` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT 'Orden en que aparece en arbol',
  `root` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'Define si solo puede acceder perfil ROOT (en configuracion por defecto acl_roles_id = 1)',
  `ownership` enum('0','1') NOT NULL DEFAULT '0' COMMENT 'Indica si modulo usa modelo con reglas de owner, funciona con type=xml, ver Zwei_Db_Table::isOwner(item, user)',
  `icons_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `module` (`module`,`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Volcado de datos para la tabla `acl_modules`
--

INSERT INTO `acl_modules` (`id`, `parent_id`, `title`, `module`, `tree`, `refresh_on_load`, `type`, `approved`, `order`, `root`, `ownership`, `icons_id`) VALUES
(1, NULL, 'Configuraci&oacute;n', NULL, '1', '0', 'xml', '1', 11, '0', '0', 5),
(2, NULL, 'Caminos', 'paths.xml', '1', '0', 'xml', '1', 0, '0', '0', 1),
(3, NULL, 'Datos Personales', 'personal-info.xml', '0', '0', 'xml', '1', 0, '0', '0', 6),
(4, 1, 'M&oacute;dulos', 'modules.xml', '1', '0', 'xml', '1', 7, '1', '0', 3),
(5, 1, 'Usuarios', 'users.xml', '1', '0', 'xml', '1', 0, '0', '0', 6),
(7, 1, 'Servidor', 'phpinfo.xml', '1', '0', 'xml', '1', 0, '1', '0', 1),
(8, 1, 'Perfiles', 'roles.xml', '1', '0', 'xml', '1', 0, '1', '0', 1),
(9, 1, 'Configuraci&oacute;n del Sitio', 'settings.xml', '1', '0', 'xml', '1', 0, '1', '0', 1),
(10, 1, '&Iacute;conos', 'icons.xml', '1', '0', 'xml', '1', 10, '1', '0', 7),
(12, 2, 'Nodos', 'nodes.xml', '0', '0', 'xml', '1', 0, '0', '0', 0),
(13, 2, 'Enlaces', 'links.xml', '0', '0', 'xml', '1', 0, '0', '0', 0),
(14, NULL, 'Matriz de Adyacencia', 'adjacency-matrix', '1', '0', 'zend_module', '1', 3, '0', '0', 8),
(15, NULL, 'Presentaci&oacute;n', 'presentation', '1', '0', 'iframe', '1', 2, '0', '0', 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_modules_actions`
--

DROP TABLE IF EXISTS `acl_modules_actions`;
CREATE TABLE IF NOT EXISTS `acl_modules_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `acl_modules_id` int(11) NOT NULL,
  `acl_actions_id` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `acl_modules_id` (`acl_modules_id`,`acl_actions_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=337 ;

--
-- Volcado de datos para la tabla `acl_modules_actions`
--

INSERT INTO `acl_modules_actions` (`id`, `acl_modules_id`, `acl_actions_id`) VALUES
(168, 1, 'LIST'),
(333, 2, 'ADD'),
(334, 2, 'DELETE'),
(335, 2, 'EDIT'),
(188, 2, 'LIST'),
(62, 3, 'EDIT'),
(63, 3, 'LIST'),
(172, 4, 'ADD'),
(173, 4, 'DELETE'),
(171, 4, 'EDIT'),
(174, 4, 'LIST'),
(163, 5, 'ADD'),
(164, 5, 'DELETE'),
(162, 5, 'EDIT'),
(165, 5, 'LIST'),
(187, 7, 'LIST'),
(260, 8, 'ADD'),
(261, 8, 'DELETE'),
(259, 8, 'EDIT'),
(262, 8, 'LIST'),
(301, 9, 'EDIT'),
(205, 9, 'LIST'),
(329, 10, 'ADD'),
(330, 10, 'DELETE'),
(331, 10, 'EDIT'),
(267, 10, 'LIST'),
(268, 11, 'LIST'),
(285, 12, 'ADD'),
(286, 12, 'DELETE'),
(287, 12, 'EDIT'),
(288, 12, 'LIST'),
(289, 13, 'ADD'),
(290, 13, 'DELETE'),
(291, 13, 'EDIT'),
(292, 13, 'LIST');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_roles`
--

DROP TABLE IF EXISTS `acl_roles`;
CREATE TABLE IF NOT EXISTS `acl_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` char(64) NOT NULL,
  `description` char(100) CHARACTER SET utf8 NOT NULL,
  `approved` enum('0','1') CHARACTER SET utf8 NOT NULL DEFAULT '1',
  `must_refresh` enum('0','1') CHARACTER SET utf8 NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `acl_roles`
--

INSERT INTO `acl_roles` (`id`, `role_name`, `description`, `approved`, `must_refresh`) VALUES
(1, 'Soporte', 'Perfil root.', '1', '0'),
(2, 'Administrador', 'Administrador con acceso a hacer modificaciones administrativas y manejo de usuarios.', '1', '0'),
(3, 'Consultas', 'Acceso a listados y reportes.', '1', '0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_roles_modules_actions`
--

DROP TABLE IF EXISTS `acl_roles_modules_actions`;
CREATE TABLE IF NOT EXISTS `acl_roles_modules_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `acl_roles_id` int(11) NOT NULL,
  `acl_modules_actions_id` int(11) NOT NULL,
  `permission` enum('ALLOW','DENY') CHARACTER SET utf8 NOT NULL DEFAULT 'ALLOW',
  PRIMARY KEY (`id`),
  UNIQUE KEY `acl_roles_id` (`acl_roles_id`,`acl_modules_actions_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=223 ;

--
-- Volcado de datos para la tabla `acl_roles_modules_actions`
--

INSERT INTO `acl_roles_modules_actions` (`id`, `acl_roles_id`, `acl_modules_actions_id`, `permission`) VALUES
(1, 2, 168, 'ALLOW'),
(3, 2, 188, 'ALLOW'),
(5, 2, 62, 'ALLOW'),
(6, 2, 63, 'ALLOW'),
(8, 2, 162, 'ALLOW'),
(9, 2, 163, 'ALLOW'),
(10, 2, 164, 'ALLOW'),
(11, 2, 165, 'ALLOW'),
(15, 1, 168, 'ALLOW'),
(17, 1, 188, 'ALLOW'),
(26, 1, 62, 'ALLOW'),
(27, 1, 63, 'ALLOW'),
(33, 1, 171, 'ALLOW'),
(34, 1, 172, 'ALLOW'),
(35, 1, 173, 'ALLOW'),
(36, 1, 174, 'ALLOW'),
(37, 1, 187, 'ALLOW'),
(39, 1, 205, 'ALLOW'),
(44, 1, 162, 'ALLOW'),
(45, 1, 163, 'ALLOW'),
(46, 1, 164, 'ALLOW'),
(47, 1, 165, 'ALLOW'),
(62, 3, 188, 'ALLOW'),
(67, 3, 162, 'ALLOW'),
(68, 3, 163, 'ALLOW'),
(69, 3, 164, 'ALLOW'),
(70, 3, 165, 'ALLOW'),
(74, 3, 168, 'ALLOW'),
(105, 3, 62, 'ALLOW'),
(106, 3, 63, 'ALLOW'),
(123, 1, 259, 'ALLOW'),
(124, 1, 260, 'ALLOW'),
(125, 1, 261, 'ALLOW'),
(126, 1, 262, 'ALLOW'),
(131, 1, 267, 'ALLOW'),
(132, 1, 268, 'ALLOW'),
(133, 1, 289, 'ALLOW'),
(134, 1, 290, 'ALLOW'),
(135, 1, 291, 'ALLOW'),
(136, 1, 292, 'ALLOW'),
(145, 1, 285, 'ALLOW'),
(146, 1, 286, 'ALLOW'),
(147, 1, 287, 'ALLOW'),
(148, 1, 288, 'ALLOW'),
(161, 1, 329, 'ALLOW'),
(162, 1, 330, 'ALLOW'),
(163, 1, 331, 'ALLOW'),
(164, 1, 301, 'ALLOW'),
(191, 1, 333, 'ALLOW'),
(192, 1, 334, 'ALLOW'),
(193, 1, 335, 'ALLOW');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_session`
--

DROP TABLE IF EXISTS `acl_session`;
CREATE TABLE IF NOT EXISTS `acl_session` (
  `id` char(32) NOT NULL DEFAULT '0',
  `acl_users_id` int(10) DEFAULT NULL,
  `acl_roles_id` int(10) DEFAULT NULL,
  `created` int(10) unsigned DEFAULT NULL,
  `modified` int(10) unsigned DEFAULT NULL,
  `lifetime` int(10) unsigned DEFAULT NULL,
  `data` text,
  `ip` varchar(20) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `must_refresh` enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `acl_session`
--

INSERT INTO `acl_session` (`id`, `acl_users_id`, `acl_roles_id`, `created`, `modified`, `lifetime`, `data`, `ip`, `user_agent`, `must_refresh`) VALUES
('ad1ho551rprmf8fm6jir8dr733', 1, 1, 1456979187, 1456980098, 1440, 'Zend_Auth|a:3:{s:7:"timeout";i:1456982232;s:10:"requestUri";s:80:"//components/nodes-graph/paths-dialog?paths_id=9&dojo.preventCache=1456979832559";s:7:"storage";O:8:"stdClass":11:{s:2:"id";s:1:"1";s:12:"acl_roles_id";s:1:"1";s:9:"user_name";s:8:"gamelena";s:11:"first_names";s:7:"Soporte";s:10:"last_names";s:8:"gamelena";s:5:"email";s:21:"tecnicos@gamelena.com";s:8:"approved";s:1:"1";s:4:"foto";N;s:12:"must_refresh";s:1:"0";s:16:"sessionNamespace";s:18:"dijkstra-tangerine";s:6:"groups";a:0:{}}}', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36 FirePHP/4Chrome', '0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_users`
--

DROP TABLE IF EXISTS `acl_users`;
CREATE TABLE IF NOT EXISTS `acl_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acl_roles_id` int(4) NOT NULL,
  `user_name` char(64) NOT NULL,
  `password` char(200) NOT NULL,
  `first_names` char(50) NOT NULL,
  `last_names` char(50) NOT NULL,
  `email` char(50) NOT NULL,
  `approved` enum('0','1') NOT NULL,
  `foto` varchar(256) DEFAULT NULL,
  `must_refresh` enum('0','1') CHARACTER SET utf8 NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `acl_users`
--

INSERT INTO `acl_users` (`id`, `acl_roles_id`, `user_name`, `password`, `first_names`, `last_names`, `email`, `approved`, `foto`, `must_refresh`) VALUES
(1, 1, 'gamelena', '3a62dc577a0db23fb0b5c1c9e8046c05', 'Soporte', 'gamelena', 'tecnicos@gamelena.com', '1', NULL, '0'),
(2, 2, 'invitado', 'a6ae8a143d440ab8c006d799f682d48d', 'Administrador', 'Cliente', '', '1', NULL, '0'),
(3, 3, 'consultas', '83da1fbc8f1a993de3f31cec6d7bf5b2', 'Consultas', 'Cliente', '', '1', NULL, '0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acl_users_groups`
--

DROP TABLE IF EXISTS `acl_users_groups`;
CREATE TABLE IF NOT EXISTS `acl_users_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acl_users_id` int(11) NOT NULL,
  `acl_groups_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `acl_users_id` (`acl_users_id`,`acl_groups_id`),
  KEY `fk_acl_users_groups_acl_users1` (`acl_users_id`),
  KEY `fk_acl_users_groups_acl_groups1` (`acl_groups_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_book`
--

DROP TABLE IF EXISTS `log_book`;
CREATE TABLE IF NOT EXISTS `log_book` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user` char(40) NOT NULL,
  `table` char(40) NOT NULL,
  `action` char(40) NOT NULL,
  `condition` char(200) NOT NULL,
  `acl_roles_id` int(11) NOT NULL,
  `ip` char(200) NOT NULL,
  `stamp` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `tables_logged`
--
DROP VIEW IF EXISTS `tables_logged`;
CREATE TABLE IF NOT EXISTS `tables_logged` (
`id` char(40)
,`title` char(40)
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `web_icons`
--

DROP TABLE IF EXISTS `web_icons`;
CREATE TABLE IF NOT EXISTS `web_icons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `image` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=25 ;

--
-- Volcado de datos para la tabla `web_icons`
--

INSERT INTO `web_icons` (`id`, `title`, `image`) VALUES
(1, 'Sphere Green', '23c16c7cgreen-sphere.png'),
(2, 'Sphere Blue', '0b402132step4c.png'),
(3, 'Sphere Red', 'fff2f50cred-sphere-2.png'),
(4, 'Sphere Yellow', 'c0f2aa3ayellow-sphere.png'),
(5, 'Keys', '461a6088roles.png'),
(6, 'Module', 'a523db9cblockdevice.png'),
(7, 'Roles', '136ad849social-networking-package.jpg'),
(8, 'Teams', '51197ecdsort-groups-by-128.png'),
(9, 'Online', '5b47cf39user-icon.png'),
(10, 'Chart', 'f051dc42chart-down.png'),
(11, 'Magnifier', '8a44638aleaf-grey.png'),
(12, 'Settings', '99c5d37aiphone-settings-icon.png'),
(13, 'Settings 2', '3a8b8cd1setting-icon.png'),
(14, 'Audit', 'e288f792pass-icon.png'),
(15, 'Setup', '0d7df408setup-l.png'),
(17, 'User', 'a4c40f07actions-im-user-icon.png'),
(18, 'Package', 'c244255a50px-crystal-package.png'),
(19, 'Sale', '8a6ca637activshow-icon.png'),
(20, 'Global', '9f8eb80dworld.png'),
(21, 'Setup Warning', '11e455ecsetup.png'),
(22, 'Server', '3ff898e8server-icon.png'),
(23, 'Reporte', '7612a7b7reports.png'),
(24, 'CSV', 'ad4c5a07csv.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `web_settings`
--

DROP TABLE IF EXISTS `web_settings`;
CREATE TABLE IF NOT EXISTS `web_settings` (
  `id` char(255) NOT NULL DEFAULT '',
  `list` char(255) NOT NULL,
  `value` char(255) NOT NULL DEFAULT '0',
  `type` char(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `ord` int(11) NOT NULL DEFAULT '0',
  `group` char(255) NOT NULL,
  `function` char(255) NOT NULL,
  `approved` enum('0','1') NOT NULL,
  `path` varchar(50) NOT NULL,
  `url` varchar(256) DEFAULT NULL,
  `regExp` varchar(60) NOT NULL,
  `invalidMessage` varchar(50) NOT NULL,
  `promptMessage` varchar(50) NOT NULL,
  `formatter` varchar(25) NOT NULL,
  `xml_children` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `web_settings`
--

INSERT INTO `web_settings` (`id`, `list`, `value`, `type`, `description`, `ord`, `group`, `function`, `approved`, `path`, `url`, `regExp`, `invalidMessage`, `promptMessage`, `formatter`, `xml_children`) VALUES
('credits', '', '&copy; gamelena 2015', 'dijit-form-validation-text-box', '', 2, 'Admin', '', '1', '', NULL, '', '', '', '', ''),
('query_log', '', '1', 'dijit-form-check-box', '', 1, 'Debug', '', '1', '', NULL, '', '', '', '', ''),
('titulo_adm', '', 'Dijkstra', 'dijit-form-validation-text-box', '', 1, 'Admin', '', '1', '', NULL, '', '', '', '', ''),
('transactions_log', '', '1', 'dijit-form-check-box', '', 1, 'Debug', '', '1', '', NULL, '', '', '', '', ''),
('url_logo_gamelena', '', '9446c2dbgenesis.png', 'dojox-form-uploader', '', 3, 'Admin', '', '1', '{ROOT_DIR}/public/upfiles/', '{BASE_URL}/upfiles/corporative/', '', '', '', 'formatImage', '&lt;thumb height="18" path="{ROOT_DIR}/public/upfiles/corporative/" /&gt;\r\n'),
('url_logo_oper', '', '4729223agenesis.png', 'dojox-form-uploader', '', 3, 'Admin', '', '1', '{ROOT_DIR}/public/upfiles/', '{BASE_URL}/upfiles/corporative/', '', '', '', 'formatImage', '&lt;thumb height="56" path="{ROOT_DIR}/public/upfiles/corporative/" /&gt;');

-- --------------------------------------------------------

--
-- Estructura para la vista `tables_logged`
--
DROP TABLE IF EXISTS `tables_logged`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tables_logged` AS select distinct `log_book`.`table` AS `id`,`log_book`.`table` AS `title` from `log_book` order by `log_book`.`table`;
