-- MariaDB dump 10.19  Distrib 10.6.16-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: jol
-- ------------------------------------------------------
-- Server version	10.6.16-MariaDB-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `balloon`
--

DROP TABLE IF EXISTS `balloon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `balloon` (
  `balloon_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` char(48) NOT NULL,
  `sid` int(11) NOT NULL,
  `cid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `status` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`balloon_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `balloon`
--

LOCK TABLES `balloon` WRITE;
/*!40000 ALTER TABLE `balloon` DISABLE KEYS */;
/*!40000 ALTER TABLE `balloon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compileinfo`
--

DROP TABLE IF EXISTS `compileinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `compileinfo` (
  `solution_id` int(11) NOT NULL DEFAULT 0,
  `error` text DEFAULT NULL,
  PRIMARY KEY (`solution_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compileinfo`
--

LOCK TABLES `compileinfo` WRITE;
/*!40000 ALTER TABLE `compileinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `compileinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contest`
--

DROP TABLE IF EXISTS `contest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contest` (
  `contest_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `defunct` char(1) NOT NULL DEFAULT 'N',
  `description` text DEFAULT NULL,
  `private` tinyint(4) NOT NULL DEFAULT 0,
  `langmask` int(11) NOT NULL DEFAULT 0 COMMENT 'bits for LANG to mask',
  `password` char(16) NOT NULL DEFAULT '',
  `user_id` varchar(48) NOT NULL DEFAULT 'admin',
  PRIMARY KEY (`contest_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contest`
--

LOCK TABLES `contest` WRITE;
/*!40000 ALTER TABLE `contest` DISABLE KEYS */;
/*!40000 ALTER TABLE `contest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contest_problem`
--

DROP TABLE IF EXISTS `contest_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contest_problem` (
  `problem_id` int(11) NOT NULL DEFAULT 0,
  `contest_id` int(11) DEFAULT NULL,
  `title` char(200) NOT NULL DEFAULT '',
  `num` int(11) NOT NULL DEFAULT 0,
  `c_accepted` int(11) NOT NULL DEFAULT 0,
  `c_submit` int(11) NOT NULL DEFAULT 0,
  KEY `Index_contest_id` (`contest_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contest_problem`
--

LOCK TABLES `contest_problem` WRITE;
/*!40000 ALTER TABLE `contest_problem` DISABLE KEYS */;
/*!40000 ALTER TABLE `contest_problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custominput`
--

DROP TABLE IF EXISTS `custominput`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custominput` (
  `solution_id` int(11) NOT NULL DEFAULT 0,
  `input_text` text DEFAULT NULL,
  PRIMARY KEY (`solution_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custominput`
--

LOCK TABLES `custominput` WRITE;
/*!40000 ALTER TABLE `custominput` DISABLE KEYS */;
/*!40000 ALTER TABLE `custominput` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loginlog`
--

DROP TABLE IF EXISTS `loginlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loginlog` (
  `user_id` varchar(48) NOT NULL DEFAULT '',
  `password` varchar(40) DEFAULT NULL,
  `ip` varchar(46) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  KEY `user_log_index` (`user_id`,`time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loginlog`
--

LOCK TABLES `loginlog` WRITE;
/*!40000 ALTER TABLE `loginlog` DISABLE KEYS */;
INSERT INTO `loginlog` VALUES ('admin','no save','10.211.55.2','2024-02-08 23:23:42');
/*!40000 ALTER TABLE `loginlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail`
--

DROP TABLE IF EXISTS `mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail` (
  `mail_id` int(11) NOT NULL AUTO_INCREMENT,
  `to_user` varchar(48) NOT NULL DEFAULT '',
  `from_user` varchar(48) NOT NULL DEFAULT '',
  `title` varchar(200) NOT NULL DEFAULT '',
  `content` text DEFAULT NULL,
  `new_mail` tinyint(1) NOT NULL DEFAULT 1,
  `reply` tinyint(4) DEFAULT 0,
  `in_date` datetime DEFAULT NULL,
  `defunct` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`mail_id`),
  KEY `uid` (`to_user`)
) ENGINE=MyISAM AUTO_INCREMENT=1013 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail`
--

LOCK TABLES `mail` WRITE;
/*!40000 ALTER TABLE `mail` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `news_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(48) NOT NULL DEFAULT '',
  `title` varchar(200) NOT NULL DEFAULT '',
  `content` mediumtext NOT NULL,
  `time` datetime NOT NULL DEFAULT '2016-05-13 19:24:00',
  `importance` tinyint(4) NOT NULL DEFAULT 0,
  `menu` int(11) NOT NULL DEFAULT 0,
  `defunct` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`news_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1007 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (1000,'admin','공지사항 입력 예시입니다.','\r\n	<span style=\"text-align:center;text-wrap:wrap;background-color:#FFE500;\">-- 관리자 페이지의 공지사항-등록에서 글을 등록하면&#44;</span>\r\n<br />\r\n\r\n	이렇게 메인 페이지의 하단에 나타납니다.\r\n<br />\r\n\r\n	<br />\r\n<br />\r\n\r\n	-- 기초100제 시리즈 문제들은 <span style=\"background-color:#E53333;color:#FFFFFF;\">중고등학교 정보 선생님들만 정보 교과 관련 공교육 목적으로 자유롭게 사용하실 수 있습니다.</span>\r\n<br />\r\n-- 협의되지 않은 사교육&#44; 출판&#44; 인쇄 등 영리 목적으로 임의적 활용시에는 저작권과 관련하여 분쟁이 생길 수 있음을 알려드립니다. <br />\r\n<br />\r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<img src=\"/upload/image/20240208/20240208235939_90918.png\" alt=\"\" /> \r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<br />\r\n<br />','2024-02-09 00:12:54',0,0,'N'),(1004,'admin','faqs.ko','<span style=\"background-color:#FFE500;\">관리자 페이지의 공지사항-리스트에서 faqs.ko 제목의 글을 활성화하면&#44;</span> <br />\r\n이렇게 자주묻는질문 페이지의 화면으로 나타납니다. <br />\r\n<br />\r\n<br />','2024-02-09 00:10:29',0,0,'N'),(1005,'admin','home.ko','<p style=\"text-align:center;\">\r\n	<br />\r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<img src=\"/upload/image/20240209/20240209000318_86606.png\" alt=\"\" /> \r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<span style=\"text-wrap:wrap;background-color:#FFE500;\">관리자 페이지의 공지사항-리스트에서 home.ko 제목의 글을 수정해서 상단 배너 이미지나 글을 넣으면&#44;</span> \r\n<br />\r\n<p style=\"text-align:center;\">\r\n	이렇게 메인 첫 화면 상단에 배너처럼 나타납니다.\r\n<br />','2024-02-09 00:13:45',0,0,'N'),(1006,'admin','각종 프로그래밍 IDE 설치 방법','<span style=\"text-wrap:wrap;\">프로그래밍언어를 배우면서&#44; 코드를 작성하고 실행시켜보기 위해서는?</span><br style=\"text-wrap:wrap;\" />\r\n<span style=\"text-wrap:wrap;\">프로그램을 만드는 프로그램으로서 통합개발환경이라고 하는 IDE를 설치해야 합니다.</span><br style=\"text-wrap:wrap;\" />\r\n<span style=\"text-wrap:wrap;\">아래 자료를 꼼꼼히 읽어보면서 따라가면&#44; 누구나 쉽게 무료 IDE를 설치할 수 있습니다.</span><br style=\"text-wrap:wrap;\" />\r\n<br style=\"text-wrap:wrap;\" />\r\n<strong style=\"text-wrap:wrap;\"><span style=\"font-size:14px;\"><strong style=\"text-wrap:wrap;\"><span style=\"font-size:14px;\">- Python IDLE</span></strong></span></strong><br />\r\n<strong style=\"text-wrap:wrap;\"><span style=\"font-size:14px;\"><a class=\"ke-insertfile\" href=\"/upload/file/20240209/20240209001926_64249.pdf\" target=\"_blank\" style=\"text-wrap:wrap;\"><u><span style=\"font-size:12px;\">Windows Python IDLE 설치하기(초보 추천!)</span></u></a><br />\r\n</span></strong><br />\r\n<strong style=\"text-wrap:wrap;\"><span style=\"font-size:14px;\">- C/C++ IDE</span></strong> <br />\r\n<a class=\"ke-insertfile\" href=\"/upload/file/20240209/20240209002054_35947.pdf\" target=\"_blank\"><strong>Windows Dev C++ 설치하기(초보 추천!)</strong></a> <br />\r\n<a class=\"ke-insertfile\" href=\"/upload/file/20240209/20240209002115_69058.pdf\" target=\"_blank\"><strong>Windows CodeBlocks 설치하기</strong></a> <br />\r\n<a class=\"ke-insertfile\" href=\"/upload/file/20240209/20240209002138_64314.pdf\" target=\"_blank\"><strong>macOS Xcode 설치하기(맥북 추천!)</strong></a> <br />\r\n\r\n	<br />\r\n<br />','2024-02-09 00:24:21',0,0,'N');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `online`
--

DROP TABLE IF EXISTS `online`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `online` (
  `hash` varchar(32) NOT NULL,
  `ip` varchar(46) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `ua` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `refer` varchar(255) DEFAULT NULL,
  `lastmove` int(10) NOT NULL,
  `firsttime` int(10) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`hash`),
  UNIQUE KEY `hash` (`hash`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `online`
--

LOCK TABLES `online` WRITE;
/*!40000 ALTER TABLE `online` DISABLE KEYS */;
/*!40000 ALTER TABLE `online` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `printer`
--

DROP TABLE IF EXISTS `printer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `printer` (
  `printer_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` char(48) NOT NULL,
  `in_date` datetime NOT NULL DEFAULT '2018-03-13 19:38:00',
  `status` smallint(6) NOT NULL DEFAULT 0,
  `worktime` timestamp NULL DEFAULT current_timestamp(),
  `printer` char(16) NOT NULL DEFAULT 'LOCAL',
  `content` text NOT NULL,
  PRIMARY KEY (`printer_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `printer`
--

LOCK TABLES `printer` WRITE;
/*!40000 ALTER TABLE `printer` DISABLE KEYS */;
/*!40000 ALTER TABLE `printer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `privilege`
--

DROP TABLE IF EXISTS `privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `privilege` (
  `user_id` char(48) NOT NULL DEFAULT '',
  `rightstr` char(30) NOT NULL DEFAULT '',
  `valuestr` char(11) NOT NULL DEFAULT 'true',
  `defunct` char(1) NOT NULL DEFAULT 'N',
  KEY `user_id_index` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `privilege`
--

LOCK TABLES `privilege` WRITE;
/*!40000 ALTER TABLE `privilege` DISABLE KEYS */;
INSERT INTO `privilege` VALUES ('admin','administrator','true','N'),('admin','source_browser','true','N'),('admin','p','true','N');
/*!40000 ALTER TABLE `privilege` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem`
--

DROP TABLE IF EXISTS `problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem` (
  `problem_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL DEFAULT '',
  `description` mediumtext DEFAULT NULL,
  `input` mediumtext DEFAULT NULL,
  `output` mediumtext DEFAULT NULL,
  `sample_input` text DEFAULT NULL,
  `sample_output` text DEFAULT NULL,
  `spj` char(1) NOT NULL DEFAULT '0',
  `hint` text DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL,
  `in_date` datetime DEFAULT NULL,
  `time_limit` decimal(10,3) NOT NULL DEFAULT 0.000,
  `memory_limit` int(11) NOT NULL DEFAULT 0,
  `defunct` char(1) NOT NULL DEFAULT 'N',
  `accepted` int(11) DEFAULT 0,
  `submit` int(11) DEFAULT 0,
  `solved` int(11) DEFAULT 0,
  `remote_oj` varchar(16) DEFAULT NULL,
  `remote_id` varchar(32) DEFAULT NULL,
  `front` text DEFAULT NULL,
  `rear` text DEFAULT NULL,
  `bann` varchar(30) DEFAULT NULL,
  `credits` text DEFAULT NULL,
  PRIMARY KEY (`problem_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem`
--

LOCK TABLES `problem` WRITE;
/*!40000 ALTER TABLE `problem` DISABLE KEYS */;
INSERT INTO `problem` VALUES (1000,'[빈 번호] (not use)','(not use)\r\n','(not use)\r\n','(not use)\r\n','(not use)\r\n','(not use)\r\n','0','','','2024-02-08 23:45:23',1.000,128,'Y',0,0,0,'','','','','','(not use)');
/*!40000 ALTER TABLE `problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reply`
--

DROP TABLE IF EXISTS `reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reply` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` varchar(48) NOT NULL,
  `time` datetime NOT NULL DEFAULT '2016-05-13 19:24:00',
  `content` text NOT NULL,
  `topic_id` int(11) NOT NULL,
  `status` int(2) NOT NULL DEFAULT 0,
  `ip` varchar(46) NOT NULL,
  PRIMARY KEY (`rid`),
  KEY `author_id` (`author_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reply`
--

LOCK TABLES `reply` WRITE;
/*!40000 ALTER TABLE `reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `runtimeinfo`
--

DROP TABLE IF EXISTS `runtimeinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `runtimeinfo` (
  `solution_id` int(11) NOT NULL DEFAULT 0,
  `error` text DEFAULT NULL,
  PRIMARY KEY (`solution_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `runtimeinfo`
--

LOCK TABLES `runtimeinfo` WRITE;
/*!40000 ALTER TABLE `runtimeinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtimeinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `share_code`
--

DROP TABLE IF EXISTS `share_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `share_code` (
  `share_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `share_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `language` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `share_time` datetime DEFAULT NULL,
  PRIMARY KEY (`share_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `share_code`
--

LOCK TABLES `share_code` WRITE;
/*!40000 ALTER TABLE `share_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `share_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sim`
--

DROP TABLE IF EXISTS `sim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sim` (
  `s_id` int(11) NOT NULL,
  `sim_s_id` int(11) DEFAULT NULL,
  `sim` int(11) DEFAULT NULL,
  PRIMARY KEY (`s_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sim`
--

LOCK TABLES `sim` WRITE;
/*!40000 ALTER TABLE `sim` DISABLE KEYS */;
/*!40000 ALTER TABLE `sim` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger simfilter
before insert on sim
for each row
begin
 declare new_user_id varchar(64);
 declare old_user_id varchar(64);
 select user_id from solution where solution_id=new.s_id into new_user_id;
 select user_id from solution where solution_id=new.sim_s_id into old_user_id;
 if old_user_id=new_user_id then
	set new.s_id=0;
 end if;
 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `solution`
--

DROP TABLE IF EXISTS `solution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `solution` (
  `solution_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `problem_id` int(11) NOT NULL DEFAULT 0,
  `user_id` char(48) NOT NULL,
  `nick` char(20) NOT NULL DEFAULT '',
  `time` int(11) NOT NULL DEFAULT 0,
  `memory` int(11) NOT NULL DEFAULT 0,
  `in_date` datetime NOT NULL DEFAULT '2016-05-13 19:24:00',
  `result` smallint(6) NOT NULL DEFAULT 0,
  `language` int(10) unsigned NOT NULL DEFAULT 0,
  `ip` char(46) NOT NULL,
  `contest_id` int(11) DEFAULT 0,
  `valid` tinyint(4) NOT NULL DEFAULT 1,
  `num` tinyint(4) NOT NULL DEFAULT -1,
  `code_length` int(11) NOT NULL DEFAULT 0,
  `judgetime` timestamp NULL DEFAULT current_timestamp(),
  `pass_rate` decimal(4,3) unsigned NOT NULL DEFAULT 0.000,
  `lint_error` int(10) unsigned NOT NULL DEFAULT 0,
  `judger` char(16) NOT NULL DEFAULT 'LOCAL',
  `remote_oj` char(16) NOT NULL DEFAULT '',
  `remote_id` char(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`solution_id`),
  KEY `uid` (`user_id`),
  KEY `pid` (`problem_id`),
  KEY `res` (`result`),
  KEY `cid` (`contest_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solution`
--

LOCK TABLES `solution` WRITE;
/*!40000 ALTER TABLE `solution` DISABLE KEYS */;
/*!40000 ALTER TABLE `solution` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `source_code`
--

DROP TABLE IF EXISTS `source_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `source_code` (
  `solution_id` int(11) NOT NULL,
  `source` text NOT NULL,
  PRIMARY KEY (`solution_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `source_code`
--

LOCK TABLES `source_code` WRITE;
/*!40000 ALTER TABLE `source_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `source_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `source_code_user`
--

DROP TABLE IF EXISTS `source_code_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `source_code_user` (
  `solution_id` int(11) NOT NULL,
  `source` text NOT NULL,
  PRIMARY KEY (`solution_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `source_code_user`
--

LOCK TABLES `source_code_user` WRITE;
/*!40000 ALTER TABLE `source_code_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `source_code_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic` (
  `tid` int(11) NOT NULL AUTO_INCREMENT,
  `title` varbinary(60) NOT NULL,
  `status` int(2) NOT NULL DEFAULT 0,
  `top_level` int(2) NOT NULL DEFAULT 0,
  `cid` int(11) DEFAULT NULL,
  `pid` int(11) NOT NULL,
  `author_id` varchar(48) NOT NULL,
  PRIMARY KEY (`tid`),
  KEY `cid` (`cid`,`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` varchar(48) NOT NULL DEFAULT '',
  `email` varchar(100) DEFAULT NULL,
  `submit` int(11) DEFAULT 0,
  `solved` int(11) DEFAULT 0,
  `defunct` char(1) NOT NULL DEFAULT 'N',
  `ip` varchar(46) NOT NULL DEFAULT '',
  `accesstime` datetime DEFAULT NULL,
  `volume` int(11) NOT NULL DEFAULT 1,
  `language` int(11) NOT NULL DEFAULT 1,
  `password` varchar(32) DEFAULT NULL,
  `reg_time` datetime DEFAULT NULL,
  `nick` varchar(20) NOT NULL DEFAULT '',
  `school` varchar(20) NOT NULL DEFAULT '',
  `activecode` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('admin','admin@admin.kr',0,0,'N','10.211.55.2','2024-02-08 23:23:42',1,1,'tZtJAkEUNTedhcAqVpgVGZ5IaPk0MTQ1','2024-02-08 23:23:42','admin','admin','');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-09  0:39:03
