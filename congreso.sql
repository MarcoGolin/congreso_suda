/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 8.0.25 : Database - saas_congreso
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`saas_congreso` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `saas_congreso`;

/*Table structure for table `aud_plataform` */

DROP TABLE IF EXISTS `aud_plataform`;

CREATE TABLE `aud_plataform` (
  `ID_AUD_PLATFORM` int NOT NULL AUTO_INCREMENT,
  `DT_ULTIMO_LOGIN` datetime NOT NULL,
  `ID_USUARIO` int NOT NULL,
  PRIMARY KEY (`ID_AUD_PLATFORM`),
  KEY `FK_AUD_USUARIO` (`ID_USUARIO`),
  CONSTRAINT `FK_AUD_USUARIO` FOREIGN KEY (`ID_USUARIO`) REFERENCES `sys_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=3229 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `aud_sorteo` */

DROP TABLE IF EXISTS `aud_sorteo`;

CREATE TABLE `aud_sorteo` (
  `ID_SORTEO` int NOT NULL AUTO_INCREMENT,
  `FC_SORTEO` datetime NOT NULL,
  `ID_USUARIO` int NOT NULL,
  `AUSPICIANTE` varchar(100) NOT NULL,
  PRIMARY KEY (`ID_SORTEO`),
  KEY `FK_SORTEO_USU` (`ID_USUARIO`),
  CONSTRAINT `FK_SORTEO_USU` FOREIGN KEY (`ID_USUARIO`) REFERENCES `sys_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `aus_auspiciantes` */

DROP TABLE IF EXISTS `aus_auspiciantes`;

CREATE TABLE `aus_auspiciantes` (
  `ID_AUSPICIANTE` bigint NOT NULL AUTO_INCREMENT,
  `DESCRIPCION` varchar(100) NOT NULL,
  `FLAYER_PATH` varchar(200) NOT NULL,
  PRIMARY KEY (`ID_AUSPICIANTE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `ev_checkin` */

DROP TABLE IF EXISTS `ev_checkin`;

CREATE TABLE `ev_checkin` (
  `ID_CHECKIN` bigint NOT NULL AUTO_INCREMENT,
  `FC_REGISTRO` datetime(6) NOT NULL,
  `ID_USUARIO` int NOT NULL,
  `TIPO` enum('CONGRESO_ASISTENCIA','KIT_ENTREGADO','LIGA_ASISTENCIA','COFFEE_BREAK_ENTREGADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ID_TALLER` int DEFAULT NULL,
  `REFRI_SLOT` enum('MATUTINO','VESPERTINO','NOCTURNO') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ID_USUARIO_OPERADOR` int DEFAULT NULL,
  `DIA` date GENERATED ALWAYS AS (cast(`FC_REGISTRO` as date)) STORED,
  `KIT_USUARIO_UNQ` bigint GENERATED ALWAYS AS ((case when (`TIPO` = _utf8mb4'KIT_ENTREGADO') then `ID_USUARIO` else NULL end)) STORED,
  `COFFEE_FLAG` tinyint GENERATED ALWAYS AS ((case when (`TIPO` = _utf8mb4'COFFEE_BREAK_ENTREGADO') then 1 else NULL end)) STORED,
  PRIMARY KEY (`ID_CHECKIN`),
  UNIQUE KEY `UQ_KIT_ONCE` (`KIT_USUARIO_UNQ`),
  UNIQUE KEY `UQ_COFFEE_PER_DAY` (`ID_USUARIO`,`DIA`,`REFRI_SLOT`,`COFFEE_FLAG`),
  KEY `FK_CHK_OPERADOR` (`ID_USUARIO_OPERADOR`),
  KEY `IDX_CHK_USUARIO_FC` (`ID_USUARIO`,`FC_REGISTRO`),
  KEY `IDX_CHK_TIPO` (`TIPO`),
  KEY `IDX_CHK_TALLER` (`ID_TALLER`),
  KEY `IDX_CHK_REFRI` (`REFRI_SLOT`),
  CONSTRAINT `FK_CHK_OPERADOR` FOREIGN KEY (`ID_USUARIO_OPERADOR`) REFERENCES `sys_usuario` (`ID_USUARIO`),
  CONSTRAINT `FK_CHK_TALLER` FOREIGN KEY (`ID_TALLER`) REFERENCES `tr_taller` (`ID_TALLER`),
  CONSTRAINT `FK_CHK_USUARIO` FOREIGN KEY (`ID_USUARIO`) REFERENCES `sys_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `fin_habilitacion_pagos` */

DROP TABLE IF EXISTS `fin_habilitacion_pagos`;

CREATE TABLE `fin_habilitacion_pagos` (
  `ID_HABILITACION` int NOT NULL AUTO_INCREMENT,
  `FC_REGISTRO` datetime NOT NULL,
  `ID_USUARIO` int NOT NULL,
  `INICIO` datetime NOT NULL,
  `FIN` datetime NOT NULL,
  `OBSERVACION` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ID_USUARIO_REGISTRO` int NOT NULL,
  PRIMARY KEY (`ID_HABILITACION`),
  KEY `FK_HAB_USU` (`ID_USUARIO`),
  KEY `FK_HAB_USU_REG` (`ID_USUARIO_REGISTRO`),
  CONSTRAINT `FK_HAB_USU` FOREIGN KEY (`ID_USUARIO`) REFERENCES `sys_usuario` (`ID_USUARIO`),
  CONSTRAINT `FK_HAB_USU_REG` FOREIGN KEY (`ID_USUARIO_REGISTRO`) REFERENCES `sys_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=189 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `org_organizadores` */

DROP TABLE IF EXISTS `org_organizadores`;

CREATE TABLE `org_organizadores` (
  `ID_ORGANIZADOR` int NOT NULL AUTO_INCREMENT,
  `FOTO` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `NOMBRE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CARGO` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `BO_DESTACAR` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID_ORGANIZADOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `sys_parametro` */

DROP TABLE IF EXISTS `sys_parametro`;

CREATE TABLE `sys_parametro` (
  `ID_PARAMETRO` int NOT NULL AUTO_INCREMENT,
  `VL_INSRIPCION_ACTUAL` decimal(20,3) NOT NULL,
  `BO_MOSTRAR_COMITE` tinyint(1) NOT NULL DEFAULT '0',
  `BO_MOSTRAR_TALLERES` tinyint(1) NOT NULL DEFAULT '0',
  `BO_MOSTRAR_AUSPICIANTES` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID_PARAMETRO`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

/*Table structure for table `sys_usuario` */

DROP TABLE IF EXISTS `sys_usuario`;

CREATE TABLE `sys_usuario` (
  `ID_USUARIO` int NOT NULL AUTO_INCREMENT,
  `FC_REGISTRO` datetime NOT NULL,
  `NOMBRE_COMPLETO` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `EMAIL` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `SENHA` varchar(100) NOT NULL,
  `TELEFONO` varchar(100) DEFAULT NULL,
  `INSTITUCION` varchar(100) DEFAULT NULL,
  `REGISTRO_ACADEMICO` varchar(100) DEFAULT NULL,
  `SEMESTRE` varchar(100) DEFAULT NULL,
  `SECCION` varchar(100) DEFAULT NULL,
  `PAIS` varchar(100) DEFAULT NULL,
  `FC_ACTIVACION` datetime DEFAULT NULL,
  `BO_ACTIVADO` tinyint(1) DEFAULT '0',
  `BO_IS_PAGO` tinyint(1) DEFAULT '0',
  `FC_PAGO` datetime DEFAULT NULL,
  `VL_PAGO` decimal(20,3) DEFAULT NULL,
  `NR_COMPROBANTE` varchar(10) DEFAULT NULL,
  `USUARIO_PAGO` varchar(200) DEFAULT NULL,
  `BO_EXONERADO` tinyint(1) NOT NULL DEFAULT '0',
  `OBS_ANULACION_PAGO` varchar(200) DEFAULT NULL,
  `UUID` varchar(200) DEFAULT NULL,
  `BO_ADMIN` tinyint(1) NOT NULL DEFAULT '0',
  `BO_FINANCIERO` tinyint(1) NOT NULL DEFAULT '0',
  `BO_STAFF` tinyint(1) NOT NULL DEFAULT '0',
  `BO_CONGRESISTA` tinyint(1) NOT NULL DEFAULT '1',
  `BO_INVITADO` tinyint(1) DEFAULT '0',
  `BO_DISERTANTE` tinyint(1) DEFAULT '0',
  `BO_ENVIADO_EMAIL_INSCRIPCION` tinyint(1) DEFAULT '0',
  `BO_AUDIOVISUAL` tinyint(1) DEFAULT '0',
  `UUID_BIN` binary(16) DEFAULT NULL,
  PRIMARY KEY (`ID_USUARIO`),
  UNIQUE KEY `UQ_SYS_USUARIO_UUID_STR` (`UUID`),
  UNIQUE KEY `UQ_SYS_USUARIO_UUID_BIN` (`UUID_BIN`),
  KEY `FK_USU_CONGRESISTA` (`INSTITUCION`)
) ENGINE=InnoDB AUTO_INCREMENT=921 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `sys_versao` */

DROP TABLE IF EXISTS `sys_versao`;

CREATE TABLE `sys_versao` (
  `ID_VERSAO` int NOT NULL AUTO_INCREMENT,
  `DT_VERSAO` datetime NOT NULL,
  `NR_VERSAO` varchar(60) NOT NULL,
  `NR_BUILD` int NOT NULL,
  `BO_FORCE_UPDATE` tinyint(1) NOT NULL,
  `KEY_MASTER` varchar(200) NOT NULL,
  PRIMARY KEY (`ID_VERSAO`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Table structure for table `tc_coautor` */

DROP TABLE IF EXISTS `tc_coautor`;

CREATE TABLE `tc_coautor` (
  `ID_COAUTOR` bigint NOT NULL AUTO_INCREMENT,
  `NOMBRE` varchar(255) NOT NULL,
  `EMAIL` varchar(255) NOT NULL,
  `FILIACION` varchar(255) DEFAULT NULL,
  `FILIACION_OTRO` varchar(255) DEFAULT NULL,
  `ID_TRABAJO_CIENTIFICO` bigint NOT NULL,
  PRIMARY KEY (`ID_COAUTOR`),
  KEY `FK_TC_COAUTOR_TRABAJO_CIENTIFICO` (`ID_TRABAJO_CIENTIFICO`),
  CONSTRAINT `FK_TC_COAUTOR_TRABAJO_CIENTIFICO` FOREIGN KEY (`ID_TRABAJO_CIENTIFICO`) REFERENCES `tc_trabajo_cientifico` (`ID_TRABAJO_CIENTIFICO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=248 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `tc_trabajo_cientifico` */

DROP TABLE IF EXISTS `tc_trabajo_cientifico`;

CREATE TABLE `tc_trabajo_cientifico` (
  `ID_TRABAJO_CIENTIFICO` bigint NOT NULL AUTO_INCREMENT,
  `FC_REGISTRO` datetime(6) NOT NULL,
  `AUTOR_NOMBRE` varchar(255) NOT NULL,
  `AUTOR_EMAIL` varchar(255) NOT NULL,
  `AUTOR_TELEFONO` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `AUTOR_FILIACION` varchar(200) DEFAULT NULL,
  `TITULO` varchar(500) NOT NULL,
  `MODALIDAD` varchar(255) NOT NULL,
  `AREA_TEMATICA` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `AREA_DE_LA_MEDICINA` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `RESUMEN` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ARCHIVO_WORD_URI` varchar(1024) NOT NULL,
  `ARCHIVO_PDF_URI` varchar(1024) DEFAULT NULL,
  `ACEPTO_DECLARACION` tinyint(1) NOT NULL DEFAULT '1',
  `ID_USUARIO` int NOT NULL,
  `CAMPO_PARA_BLOQUEO` tinyint(1) NOT NULL,
  `BO_CANCELADO` tinyint(1) DEFAULT '0',
  `FC_CANCELADO` datetime DEFAULT NULL,
  `ESTADO` enum('Recibido','En revisión','Observado','Aceptado','Rechazado') DEFAULT 'Recibido',
  PRIMARY KEY (`ID_TRABAJO_CIENTIFICO`),
  KEY `FK_TC_USUARIO` (`ID_USUARIO`),
  CONSTRAINT `FK_TC_USUARIO` FOREIGN KEY (`ID_USUARIO`) REFERENCES `sys_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `tr_taller` */

DROP TABLE IF EXISTS `tr_taller`;

CREATE TABLE `tr_taller` (
  `ID_TALLER` int NOT NULL AUTO_INCREMENT,
  `TITULO` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DESCRIPCION` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ORGANIZADOR` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `FECHA_HORA` datetime NOT NULL,
  `SALA` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `COSTO` decimal(20,3) NOT NULL,
  `FLAYER` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `BO_ACTIVO` tinyint(1) NOT NULL DEFAULT '1',
  `CONTACTO` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `RESPONSABLE` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`ID_TALLER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `tr_taller_inscripto` */

DROP TABLE IF EXISTS `tr_taller_inscripto`;

CREATE TABLE `tr_taller_inscripto` (
  `ID_TALLER_INSCR` int NOT NULL AUTO_INCREMENT,
  `FECHA` datetime NOT NULL,
  `ID_TALLER` int NOT NULL,
  `ID_USUARIO` int NOT NULL,
  `FC_PAGO` datetime DEFAULT NULL,
  `VL_PAGO` decimal(20,3) DEFAULT '0.000',
  `NR_COMPROBANTE` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `USUARIO_PAGO` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `BO_EXONERADO` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID_TALLER_INSCR`),
  KEY `FK_INSC_TALLER` (`ID_TALLER`),
  KEY `FK_INSC_TALLER_USUARIO` (`ID_USUARIO`),
  CONSTRAINT `FK_INSC_TALLER` FOREIGN KEY (`ID_TALLER`) REFERENCES `tr_taller` (`ID_TALLER`),
  CONSTRAINT `FK_INSC_TALLER_USUARIO` FOREIGN KEY (`ID_USUARIO`) REFERENCES `sys_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* Trigger structure for table `sys_usuario` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `trg_sys_usuario_bi` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `trg_sys_usuario_bi` BEFORE INSERT ON `sys_usuario` FOR EACH ROW BEGIN
  -- Validación UUID (36 chars con guiones)
  IF NEW.UUID IS NULL OR NEW.UUID NOT REGEXP '^[0-9a-fA-F-]{8}-[0-9a-fA-F-]{4}-[0-9a-fA-F-]{4}-[0-9a-fA-F-]{4}-[0-9a-fA-F-]{12}$' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UUID inválido (NULL o formato incorrecto)';
  END IF;
  -- Siempre calcular UUID_BIN desde UUID
  SET NEW.UUID_BIN = UNHEX(REPLACE(NEW.UUID, '-', ''));
END */$$


DELIMITER ;

/* Trigger structure for table `sys_usuario` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `trg_sys_usuario_bu` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `trg_sys_usuario_bu` BEFORE UPDATE ON `sys_usuario` FOR EACH ROW BEGIN
  -- Validación UUID
  IF NEW.UUID IS NULL OR NEW.UUID NOT REGEXP '^[0-9a-fA-F-]{8}-[0-9a-fA-F-]{4}-[0-9a-fA-F-]{4}-[0-9a-fA-F-]{4}-[0-9a-fA-F-]{12}$' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UUID inválido (NULL o formato incorrecto)';
  END IF;
  -- Recalcular si cambió el UUID (colación puede ser case-insensitive)
  IF (BINARY NEW.UUID <> BINARY OLD.UUID) OR NEW.UUID_BIN IS NULL THEN
    SET NEW.UUID_BIN = UNHEX(REPLACE(NEW.UUID, '-', ''));
  END IF;
END */$$


DELIMITER ;

/* Procedure structure for procedure `insert_usuarios` */

/*!50003 DROP PROCEDURE IF EXISTS  `insert_usuarios` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_usuarios`()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO saas_congreso.sys_usuario (
      ID_USUARIO, FC_REGISTRO, NOMBRE_COMPLETO, EMAIL, SENHA, TELEFONO,
      INSTITUCION, REGISTRO_ACADEMICO, SEMESTRE, SECCION, PAIS,
      FC_ACTIVACION, BO_ACTIVADO, BO_IS_PAGO, FC_PAGO, VL_PAGO,
      UUID, BO_ADMIN, BO_FINANCIERO, BO_STAFF, BO_CONGRESISTA
    ) VALUES (
      NULL,
      NOW(),
      CONCAT('Usuario ', i),
      CONCAT('usuario', i, '@example.com'),
      MD5('123456'),
      CONCAT('0981111', LPAD(i, 3, '0')),
      'Universidad Nacional',
      1000 + i,
      FLOOR(1 + (RAND() * 10)),
      ELT(1 + FLOOR(RAND()*4), 'A', 'B', 'C', 'D'),
      'Paraguay',
      NOW(),
      1,
      0,
      NULL,
      0,
      UUID(),
      0,
      0,
      0,
      1
    );
    SET i = i + 1;
  END WHILE;
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
