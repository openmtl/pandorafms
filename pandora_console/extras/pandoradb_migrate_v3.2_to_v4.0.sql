-- Pandora FMS - the Flexible Monitoring System
-- ============================================
-- Copyright (c) 2011 Artica Soluciones Tecnológicas, http://www.artica.es
-- Please see http://pandora.sourceforge.net for full contribution list

-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation for version 2.
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

-- PLEASE NO NOT USE MULTILINE COMMENTS 
-- Because Pandora Installer don't understand them
-- and fails creating database !!!

-- -----------------------------------------------------
-- Table `tgrupo`
-- -----------------------------------------------------
ALTER TABLE `tgrupo` MODIFY `nombre` text;
ALTER TABLE `tgrupo` ADD COLUMN `id_skin` int(10) unsigned NOT NULL;

-- -----------------------------------------------------
-- Table `tnetwork_component`
-- -----------------------------------------------------
ALTER TABLE `tnetwork_component` ADD COLUMN `post_process` double(18,13) DEFAULT 0;

-- -----------------------------------------------------
-- Table `treport_content`
-- -----------------------------------------------------
ALTER TABLE `treport_content` ADD COLUMN `only_display_wrong` tinyint(1) unsigned NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `top_n` INT NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `top_n_value` INT NOT NULL DEFAULT 10;
ALTER TABLE `treport_content` ADD COLUMN `exception_condition` INT NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `exception_condition_value` DOUBLE (18,6) NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `show_resume` INT NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `order_uptodown` INT NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `show_graph` INT NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `group_by_agent` INT NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `id_group` int (10) unsigned NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `id_module_group` int (10) unsigned NOT NULL DEFAULT 0;
ALTER TABLE `treport_content` ADD COLUMN `style` TEXT NOT NULL DEFAULT '';
ALTER TABLE `treport_content` ADD COLUMN `server_name` TEXT DEFAULT '';

-- -----------------------------------------------------
-- Table `treport_content_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `treport_content_item` (
  `id` INTEGER UNSIGNED NOT NULL auto_increment, 
  `id_report_content` INTEGER UNSIGNED NOT NULL, 
  `id_agent_module` int(10) unsigned NOT NULL,
  `server_name` TEXT DEFAULT '',
  PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Table `tusuario`
-- -----------------------------------------------------
ALTER TABLE `tusuario` ADD COLUMN `block_size` int(4) NOT NULL DEFAULT 20;
ALTER TABLE `tusuario` ADD COLUMN `flash_chart` int(4) NOT NULL DEFAULT 1;
ALTER TABLE `tusuario` ADD COLUMN `id_skin` int(10) unsigned NOT NULL;

-- -----------------------------------------------------
-- Table `talert_actions`
-- -----------------------------------------------------
ALTER TABLE `talert_actions` ADD COLUMN `action_threshold` int(10) NOT NULL DEFAULT '0';

-- -----------------------------------------------------
-- Table `talert_template_module_actions`
-- -----------------------------------------------------
ALTER TABLE `talert_template_module_actions` ADD COLUMN `module_action_threshold` int(10) NOT NULL DEFAULT '0';
ALTER TABLE `talert_template_module_actions` ADD COLUMN `last_execution` bigint(20) NOT NULL DEFAULT '0';

-- -----------------------------------------------------
-- Table `treport_content_sla_combined`
-- -----------------------------------------------------
ALTER TABLE `treport_content_sla_combined` ADD COLUMN `server_name` TEXT DEFAULT '';
ALTER TABLE `treport_content_sla_combined` DROP FOREIGN KEY treport_content_sla_combined_ibfk_2;

-- -----------------------------------------------------
-- Table `tperfil`
-- -----------------------------------------------------
ALTER TABLE `tperfil` MODIFY `name` TEXT NOT NULL DEFAULT '';

-- -----------------------------------------------------
-- Table `tsesion`
-- -----------------------------------------------------

ALTER TABLE `tsesion` CHANGE `ID_sesion` `id_sesion` bigint(20) unsigned NOT NULL auto_increment;
ALTER TABLE `tsesion` CHANGE `ID_usuario` `id_usuario` varchar(60) NOT NULL default '0';
ALTER TABLE `tsesion` CHANGE `IP_origen` `ip_origen` varchar(100) NOT NULL default '';

-- -----------------------------------------------------
-- Table `ttrap`
-- -----------------------------------------------------
ALTER TABLE ttrap ADD `text` varchar(255) default '';
ALTER TABLE ttrap ADD `description` varchar(255) default '';
ALTER TABLE ttrap ADD `severity` tinyint(4) unsigned NOT NULL default '2';

-- -----------------------------------------------------
-- Table `tusuario_perfil`
-- -----------------------------------------------------

ALTER TABLE tusuario_perfil ADD `id_policy` int(10) unsigned NOT NULL default 0;

-- -----------------------------------------------------
-- Change the value "0000-00-00 00:00:00" that Pandora use as zero or null date value
-- for the value "01-01-1970 00:00:00".
-- -----------------------------------------------------
UPDATE `tagente` SET `ultimo_contacto` = "01-01-1970 00:00:00" WHERE `ultimo_contacto` = "0000-00-00 00:00:00";
UPDATE `tagente` SET `ultimo_contacto_remoto` = "01-01-1970 00:00:00" WHERE `ultimo_contacto_remoto` = "0000-00-00 00:00:00";
UPDATE `tagente_estado` SET `timestamp` = "01-01-1970 00:00:00" WHERE `timestamp` = "0000-00-00 00:00:00";
UPDATE `tagente_estado` SET `last_try` = "01-01-1970 00:00:00" WHERE `last_try` = "0000-00-00 00:00:00";
UPDATE `talert_snmp` SET `last_fired` = "01-01-1970 00:00:00" WHERE `last_fired` = "0000-00-00 00:00:00";
UPDATE `tevento` SET `timestamp` = "01-01-1970 00:00:00" WHERE `timestamp` = "0000-00-00 00:00:00";
UPDATE `tincidencia` SET `inicio` = "01-01-1970 00:00:00" WHERE `inicio` = "0000-00-00 00:00:00";
UPDATE `tincidencia` SET `cierre` = "01-01-1970 00:00:00" WHERE `cierre` = "0000-00-00 00:00:00";
UPDATE `tserver` SET `laststart` = "01-01-1970 00:00:00" WHERE `laststart` = "0000-00-00 00:00:00";
UPDATE `tserver` SET `keepalive` = "01-01-1970 00:00:00" WHERE `keepalive` = "0000-00-00 00:00:00";
UPDATE `ttrap` SET `timestamp` = "01-01-1970 00:00:00" WHERE `timestamp` = "0000-00-00 00:00:00";
UPDATE `tnews` SET `timestamp` = "01-01-1970 00:00:00" WHERE `timestamp` = "0000-00-00 00:00:00";
UPDATE `tserver_export` SET `timestamp` = "01-01-1970 00:00:00" WHERE `timestamp` = "0000-00-00 00:00:00";

-- -----------------------------------------------------
-- Table `ttag`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `ttag` ( 
 `id_tag` integer(10) unsigned NOT NULL auto_increment, 
 `name` varchar(100) NOT NULL default '', 
 `description` text NOT NULL default '', 
 `url` mediumtext NOT NULL default '', 
 PRIMARY KEY  (`id_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

-- -----------------------------------------------------
-- Table `ttag_module`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `ttag_module` ( 
 `id_tag` int(10) NOT NULL, 
 `id_agente_modulo` int(10) NOT NULL DEFAULT 0, 
   PRIMARY KEY  (id_tag, id_agente_modulo),
   KEY `idx_id_agente_modulo` (`id_agente_modulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

-- -----------------------------------------------------
-- Table `ttag_policy_module`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `ttag_policy_module` ( 
 `id_tag` int(10) NOT NULL, 
 `id_policy_module` int(10) NOT NULL DEFAULT 0, 
   PRIMARY KEY  (id_tag, id_policy_module),
   KEY `idx_id_policy_module` (`id_policy_module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

-- -----------------------------------------------------
-- Table `ttag_event`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `ttag_event` ( 
 `id_tag` int(10) NOT NULL, 
 `id_evento` bigint(20) NOT NULL DEFAULT 0, 
   PRIMARY KEY  (id_tag, id_evento),
   KEY `idx_id_evento` (`id_evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

-- -----------------------------------------------------
-- Table `tagente_modulo`
-- -----------------------------------------------------

ALTER TABLE `tagente_modulo` ADD COLUMN (`unit` text DEFAULT '');

-- -----------------------------------------------------
-- Table `tevento`
-- -----------------------------------------------------

ALTER TABLE `tevento` ADD COLUMN (`tags` text NOT NULL);
