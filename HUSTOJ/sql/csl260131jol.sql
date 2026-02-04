/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (aarch64)
--
-- Host: localhost    Database: jol
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0ubuntu0.24.04.1

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
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
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
  `contest_type` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `subnet` varchar(255) NOT NULL DEFAULT '',
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
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `loginlog` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(48) NOT NULL DEFAULT '',
  `password` varchar(40) DEFAULT NULL,
  `ip` varchar(46) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `user_log_index` (`user_id`,`time`),
  KEY `user_time_index` (`user_id`,`time`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loginlog`
--

LOCK TABLES `loginlog` WRITE;
/*!40000 ALTER TABLE `loginlog` DISABLE KEYS */;
INSERT INTO `loginlog` VALUES
(8,'admin','login ok','10.211.55.2','2026-02-02 23:22:23');
/*!40000 ALTER TABLE `loginlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail`
--

DROP TABLE IF EXISTS `mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=MyISAM AUTO_INCREMENT=1005 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES
(1000,'admin','공지사항 입력 예시입니다.','<span style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;text-align:center;background-color:#FFE500;\"><span style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;text-align:center;background-color:#FFE500;\"><span style=\"font-size:14px;font-family:Verdana;background-color:#FFE500;\">-- 관리자 페이지의 공지사항-등록에서 글을 등록하면,</span><br />\r\n</span></span><span style=\"text-wrap:wrap;white-space:normal;font-family:Verdana;font-size:14px;\"><span style=\"white-space:normal;font-family:Verdana;font-size:14px;\">이렇게 메인 페이지의 하단에 나타납니다.&nbsp;</span></span><span style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;text-align:center;background-color:#FFE500;\"><br style=\"white-space:normal;font-family:&quot;font-size:12px;\" />\r\n</span><span style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;text-align:center;background-color:#FFE500;\"><br style=\"white-space:normal;font-family:&quot;font-size:12px;\" />\r\n</span><span style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;text-align:center;background-color:#FFE500;\"><span style=\"white-space:normal;font-family:Verdana;font-size:14px;\">-- 기초100제 시리즈 문제들은&nbsp;</span><span style=\"white-space:normal;font-family:&quot;font-size:12px;background-color:#E53333;color:#FFFFFF;\"><span style=\"font-size:14px;font-family:Verdana;background-color:#E53333;color:#FFFFFF;\">중고등학교 정보 선생님들만 정보 교과 관련 공교육 목적으로 자유롭게 사용하실 수 있습니다.</span><br />\r\n</span></span><span style=\"text-wrap:wrap;white-space:normal;font-family:Verdana;font-size:14px;\"><span style=\"white-space:normal;font-family:Verdana;font-size:14px;\">-- 협의되지 않은 사교육, 출판, 인쇄 등 영리 목적으로 임의적 활용시에는 저작권과 관련하여 분쟁이 생길 수 있음을 알려드립니다.</span></span> <br />\r\n<p style=\"text-align:center;\">\r\n	<span style=\"text-wrap:wrap;white-space:normal;font-family:Verdana;font-size:14px;\"><span style=\"white-space:normal;font-family:Verdana;font-size:14px;\"><img src=\"/upload/image/20250208/20250208192636_18972.png\" alt=\"\" /><br />\r\n</span></span>\r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<span style=\"text-wrap:wrap;white-space:normal;font-family:Verdana;font-size:14px;\"><span style=\"white-space:normal;font-family:Verdana;font-size:14px;\"><br />\r\n</span></span>\r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<span style=\"white-space:normal;font-family:&quot;font-size:12px;\"></span> \r\n<br />','2025-02-08 19:27:42',0,0,'N'),
(1001,'admin','faqs.ko','<span style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;\"><span style=\"font-family:Verdana;font-size:14px;\">프로그래밍언어를 배우면서, 코드를 작성하고 실행시켜보기 위해서는?</span><br />\r\n</span><span style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;\"><span style=\"font-family:Verdana;font-size:14px;\">프로그램을 만드는 프로그램으로서 통합개발환경이라고 하는 IDE를 설치해야 합니다.</span><br />\r\n</span><span style=\"text-wrap:wrap;white-space:normal;font-family:Verdana;font-size:14px;\">아래 자료를 꼼꼼히 읽어보면서 따라가면, 누구나 쉽게 무료 IDE를 설치할 수 있습니다.</span> <br />\r\n<span style=\"font-family:Verdana;\"><span style=\"font-size:14px;\"><br style=\"text-wrap:wrap;white-space:normal;\" />\r\n</span></span><strong style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;\"><span style=\"font-size:14px;\"><span style=\"font-family:Verdana;font-size:14px;\">- Python</span></span></strong> <br />\r\n<span style=\"font-family:Verdana;\"><span style=\"font-size:14px;\"><b><a class=\"ke-insertfile\" href=\"/upload/file/20250208/20250208194334_67081.pdf\" target=\"_blank\">windows Python IDLE 설치하기</a></b></span></span><br />\r\n<b style=\"font-size:14px;font-family:Verdana;\"><a class=\"ke-insertfile\" href=\"/upload/file/20250208/20250208194402_66329.pdf\" target=\"_blank\">macOS Python IDLE 설치하기</a></b> <br />\r\n<br />\r\n<strong style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;\"><span style=\"font-size:14px;\"><span style=\"font-family:Verdana;font-size:14px;\">- C/C++</span></span></strong> <br />\r\n<strong style=\"text-wrap-style:auto;\"><span style=\"font-size:14px;\"><span style=\"font-family:Verdana;\"><a class=\"ke-insertfile\" href=\"/upload/file/20250208/20250208194421_73154.pdf\" target=\"_blank\">windows Code::Blocks 설치하기</a></span></span></strong> <br />\r\n<strong style=\"text-wrap-style:auto;\"><span style=\"font-size:14px;\"><span style=\"font-family:Verdana;\"><a class=\"ke-insertfile\" href=\"/upload/file/20250208/20250208194443_63873.pdf\" target=\"_blank\">macOS Xcode 설치하기</a></span></span></strong><br />','2025-03-02 20:27:18',0,0,'N'),
(1002,'admin','home.ko','<p style=\"text-align:center;\">\r\n	<img src=\"/upload/image/20250208/20250208193122_45639.png\" alt=\"\" />\r\n<br />\r\n\r\n	<p style=\"text-align:center;white-space:normal;font-family:&quot;font-size:12px;\">\r\n		<span style=\"text-wrap:wrap;background-color:#FFE500;font-family:Verdana;font-size:14px;\">관리자 페이지의 공지사항-리스트에서 home.ko를 제목으로 글을 작성하고 활성화하면,</span>\r\n	<br />\r\n	<p style=\"text-align:center;white-space:normal;font-family:&quot;font-size:12px;\">\r\n		<span style=\"font-family:Verdana;font-size:14px;\">이렇게 메인 첫 화면 상단에 배너처럼 나타납니다.</span>\r\n	<br />\r\n	\r\n		<br />\r\n	<br />\r\n<br />','2025-02-08 19:32:15',0,0,'N'),
(1003,'admin','프로그래밍 IDE 설치 방법','<span style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;\"><span style=\"font-family:Verdana;font-size:14px;\">프로그래밍언어를 배우면서, 코드를 작성하고 실행시켜보기 위해서는?</span><br />\r\n</span><span style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;\"><span style=\"font-family:Verdana;font-size:14px;\">프로그램을 만드는 프로그램으로서 통합개발환경이라고 하는 IDE를 설치해야 합니다.</span><br />\r\n</span><span style=\"text-wrap:wrap;white-space:normal;font-family:Verdana;font-size:14px;\">아래 자료를 꼼꼼히 읽어보면서 따라가면, 누구나 쉽게 무료 IDE를 설치할 수 있습니다.</span> <br />\r\n<span style=\"font-family:Verdana;\"><span style=\"font-size:14px;\"><br style=\"text-wrap:wrap;white-space:normal;\" />\r\n</span></span><strong style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;\"><span style=\"font-size:14px;\"><span style=\"font-family:Verdana;font-size:14px;\">- Python</span></span></strong> <br />\r\n<span style=\"font-family:Verdana;\"><span style=\"font-size:14px;\"><b><a class=\"ke-insertfile\" href=\"/upload/file/20250208/20250208194334_67081.pdf\" target=\"_blank\">windows Python IDLE 설치하기</a></b></span></span><br />\r\n<b style=\"font-size:14px;font-family:Verdana;\"><a class=\"ke-insertfile\" href=\"/upload/file/20250208/20250208194402_66329.pdf\" target=\"_blank\">macOS Python IDLE 설치하기</a></b> <br />\r\n<br />\r\n<strong style=\"text-wrap:wrap;white-space:normal;font-family:&quot;font-size:12px;\"><span style=\"font-size:14px;\"><span style=\"font-family:Verdana;font-size:14px;\">- C/C++</span></span></strong> <br />\r\n<strong style=\"text-wrap-style:auto;\"><span style=\"font-size:14px;\"><span style=\"font-family:Verdana;\"><a class=\"ke-insertfile\" href=\"/upload/file/20250208/20250208194421_73154.pdf\" target=\"_blank\">windows Code::Blocks 설치하기</a></span></span></strong> <br />\r\n<strong style=\"text-wrap-style:auto;\"><span style=\"font-size:14px;\"><span style=\"font-family:Verdana;\"><a class=\"ke-insertfile\" href=\"/upload/file/20250208/20250208194443_63873.pdf\" target=\"_blank\">macOS Xcode 설치하기</a></span></span></strong><br />','2025-02-08 19:45:45',0,0,'N'),
(1004,'admin','privacy.ko','<div style=\"text-align:center;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\"><span style=\"color:#E53333;\">//아래에서 빨간색 글씨 부분을 시스템에 맞추어 수정하고, 이 부분을 삭제하고 저장한 후 사용해주세요.</span><span style=\"color:#E53333;\"></span><br />\r\n</span> <span style=\"font-family:Verdana;font-size:14px;\"></span> <br />\r\n<span style=\"font-family:Verdana;font-size:14px;\"><span style=\"color:#E53333;\">CSLHUSTOJ</span> 개인정보 처리방침</span> <br />\r\n</div>\r\n<p style=\"text-align:justify;\">\r\n<br />\r\n<p style=\"text-align:justify;\">\r\n	<span style=\"text-align:left;font-family:Verdana;font-size:14px;\">&nbsp;&nbsp;</span><span style=\"text-align:left;color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"text-align:left;font-family:Verdana;font-size:14px;\">는 정보주체의 자유와 권리 보호를 위해 ｢개인정보 보호법｣ 및 관계 법령이 정한 바를 준수하여, 적법하게 개인정보를 처리하고 안전하게 관리하고 있습니다. 이에 「개인정보 보호법」 제30조에 따라 정보주체에게 개인정보의 처리와 보호에 관한 절차 및 기준을 안내하고, 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.</span> \r\n<br />\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제1조. 개인정보의 처리 목적</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp;&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\">는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 ｢개인정보 보호법｣ 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 1. 회원 가입 및 교수학습 관리</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; 회원의 가입의사 확인, 서비스 이용에 따른 본인 확인, 개인 식별 등의 목적으로 개인정보를 처리합니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 2. 교수학습 자료 개선 및 학습 활동 분석</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; 교수학습 활동 내역을 누적하여 학습 활동을 분석하고 자료 개선의 목적으로 개인정보를 처리합니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제2조. 처리하는 개인정보의 항목</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp;&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스의 개인정보 수집은 개인정보보호법 제15조(개인정보의 수집ㆍ이용) 1항 2호 (법령상 의무 준수) 및 초ㆍ중등교육법 제25조(학교생활기록) 등 관계 법령에 따라 학교의 법정 업무 수행에 필요한 최소한의 범위에서 개인정보를 동의 없이 수집, 이용할 수 있습니다.</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp;단, 법정 업무 범위를 초과하는 개인정보 처리에 대해서는 별도의 동의를 받습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp;&nbsp;</span><span style=\"font-family:Verdana;font-size:14px;\">수집ㆍ이용하는 개인정보 항목은 학습활동 운영, 평가, 지도 등 교육 목적 달성에 필요한 최소 정보로 제한하며 다음과 같습니다.</span> \r\n</div>\r\n<table style=\"width:90%;\" cellpadding=\"2\" cellspacing=\"0\" align=\"center\" border=\"1\" bordercolor=\"#000000\">\r\n	<tbody>\r\n		<tr>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">구분</span> \r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">목적</span> \r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">정보 구분</span> \r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">수집 항목</span> \r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">수집 필요성</span> \r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">법적 근거</span> \r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">서비스 운영</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">본인 식별·인증</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">필수</span> \r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">일괄 생성한 사용자ID</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">회원 식별, 로그인 ID, 의사소통 경로 확보를 위해 필수</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">개인정보보호법 제15조(개인정보의 수집ㆍ이용) 및 </span><br />\r\n<span style=\"font-family:Verdana;font-size:14px;\"> 초ㆍ중등교육법 제25조(학교생활기록) </span><br />\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">서비스 운영</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">본인 식별·인증</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">필수</span> \r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">사용자가 입력한 비밀번호</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">계정 보안 및 본인 인증을 위해 필수</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">개인정보의 안전성 확보조치 기준 제 7조(개인정보의 암호화)</span><br />\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">서비스 운영</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">본인 식별·인증</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">선택</span> \r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">소속/학교정보</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">회원 식별, 로그인 ID, 의사소통 경로 확인을 위해 필요</span><br />\r\n			</td>\r\n			<td>\r\n				<br />\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">서비스 운영</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">본인 식별·인증</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">선택</span> \r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">이메일 주소</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">회원 식별, 로그인 ID, 의사소통 경로 확인을 위해 필요</span><br />\r\n			</td>\r\n			<td>\r\n				<br />\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">서비스 접근통제</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">접속기록 확인</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">필수</span> \r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">사용자ID별 접속 IP주소</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">부정 이용 방지 및 보안 강화를 위해 필수</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">개인정보의 안전성 확보조치 기준 제 8조(접속기록의 보관 및 점검)</span><br />\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">서비스 접근통제</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">접속기록 확인</span><br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">필수</span> \r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">사용자ID별 접속 시간</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">서비스 이용 기록 관리 및 보안을 위해 필수</span><br />\r\n			</td>\r\n			<td>\r\n				<span style=\"font-family:Verdana;font-size:14px;\">개인정보의 안전성 확보조치 기준 제 8조(접속기록의 보관 및 점검)</span><br />\r\n			</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n<br />\r\n<br />\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제3조. 14세 미만 아동의 개인정보 처리에 관한 사항</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;color:#E53333;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; //고등학교에서 CSLHUSTOJ를 운영하는 경우에는 아래 내용으로 사용</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"><span style=\"font-family:Verdana;font-size:14px;\"> &nbsp;&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\">는 14세 미만 아동의 회원가입을 승인하지 않음으로써, 원칙적으로 14세 미만 아동의 개인정보를 수집·처리하지 않습니다.</span><br />\r\n<br />\r\n</span> <span style=\"font-family:Verdana;font-size:16px;color:#E53333;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; //중학교에서 CSLHUSTOJ를 운영하는 경우에는 아래 내용으로 사용</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp;&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\">는 정보교과 교수학습을 목적으로 14세 미만 아동의 회원가입을 처리할 수 있으며 개인정보를 처리하기 위하여 동의가 필요한 경우에는 해당 아동의 법정대리인으로부터 동의를 받습니다. 14세 미만 아동의 개인정보 처리에 관하여 그 법정대리인의 동의를 받을 때에는 아동에게 법정대리인의 성명, 휴대전화번호와 같이 최소한의 정보를 요구할 수 있으며, 그 동의 표시를 확인하였음을 법정대리인의 휴대전화 문자메시지로 알리는 방법으로 그 사실을 확인합니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제4조. 개인정보의 처리 및 보유 기간</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ①&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\">는 법령에 따른 개인정보 보유·이용 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용 기간 내에서 개인정보를 처리·보유합니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp;1. 서비스 운영 관리 및 서비스 접근통제 수집 항목 일체: 1년 이내</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; (당해년도 교육과정 운영일정 이내, 학년도에 생성된 데이터는 차년도 2월 28일 이내 파기)</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; &nbsp; 다만, 다음의 사유에 해당하는 경우에는 해당 사유 종료 시까지</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; &nbsp;1) 관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우에는 해당 수사·조사 종료 시까지</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; &nbsp;2) 교수학습 활동 자료가 학생의 상급학교 선발에 제공될 사유가 존재하는 경우에는 해당 선발 절차 종료 시까지</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제5조. 개인정보의 파기 절차 및 방법</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ①&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\">는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> <br />\r\n<span style=\"font-family:Verdana;font-size:14px;\"> &nbsp; ② 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다. </span><br />\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ③ 개인정보 파기의 절차 및 방법은 다음과 같습니다.</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp;1. 파기절차</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; &nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 파기 사유가 발생한 개인정보를 파기합니다.</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp;2. 파기방법</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; &nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 전자적 파일 형태로 기록·저장된 개인정보를 재생할 수 없도록 파기합니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제6조. 개인정보 처리업무의 위탁에 관한 사항</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 원활한 업무처리를 위하여 다음과 같이 업무를 위탁하고 있으며, 개인정보가 포함되어 위탁됩니다.</span> \r\n</div>\r\n</span> \r\n<table style=\"width:90%;\" cellpadding=\"2\" cellspacing=\"0\" align=\"center\" border=\"1\" bordercolor=\"#000000\">\r\n	<tbody>\r\n		<tr>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">위탁을 받는자</span> \r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"font-family:Verdana;font-size:14px;\">업무 내용</span> \r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td>\r\n				<p style=\"text-align:center;\">\r\n					<span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">Amazon Web Service Inc. 아시아 태평양(서울) 지역</span> \r\n				<br />\r\n			</td>\r\n			<td style=\"text-align:center;\">\r\n				<span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">클라우드 서비스를 이용하여 CSLHUSTOJ 정보 적재 및 처리</span><br />\r\n			</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n<br />\r\n<br />\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제7조. 개인정보의 국외 수집 및 이전에 관한 사항</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp;&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스는 </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">AWS(서울 리전)</span><span style=\"font-family:Verdana;font-size:14px;\">을 이용하여 개인정보를 국내에서 보관, 처리하며 개인정보를 국외로 이전하지 않습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제8조. 개인정보의 안전성 확보조치에 관한 사항</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp;&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 개인정보의 안정성 확보를 위해 다음과 같은 조치를 취하고 있습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 1. 회원 가입한 학생을 대상으로 정기적 사용자 교육</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 2. </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스에 접근하는 사용자를 식별하여 필수 인원만 접근 허용</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 3. 공개된 웹 경로에 접근주소(IP)를 게시하지 않음</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 4. 접근권한을 최소한의 범위로 차등 부여</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 5. 비밀번호 암호화</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 6. 접속기록의 보관 및 점검</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 7. 보안 서비스 설치 및 갱신, 서비스 취약점 점검 및 보완</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 8. 서비스 제공 서버의 접근통제</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 9. 재해·재난에 대한 안전조치</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제9조. 개인정보 자동 수집 장치의 설치·운영 및 그 거부에 관한 사항</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &lt;설치·운영하는 개인정보 자동 수집 장치&gt;</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ①&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 정보주체에게 개별적인 서비스와 편의를 제공하기 위해 이용정보를 저장하고 수시로 불로오는 ‘쿠키(cookie)’를 사용합니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ② 쿠키는 웹사이트 운영에 이용되는 서버(http)가 정보주체의 브라우저에 보내는 소량의 정보로서 정보주체의 컴퓨터 또는 모바일에 저장되며, 웹사이트 접속 시 정보주체의 브라우저에서 서버로 자동 전송됩니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ③ 정보주체는 브라우저 옵션 설정을 통해 쿠키 허용, 차단 등의 설정을 할 수 있습니다.</span> \r\n</div>\r\n</span><span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &lt; 쿠키 허용 / 차단 방법 &gt;</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ▶ 웹 브라우저에서 쿠키 허용/차단</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; ･크롬(Chrome) : 웹브라우저 오른쪽 상단 ‘⋮’ 표시 선택 &gt; 새 시크릿 창 (단축키 : Ctrl+Shift+N)</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; ･엣지(Edge) : 웹 브라우저 오른쪽 상단 ‘…’ 표시 선택 &gt; 새 InPrivate 창 (단축키 : Ctrl+Shift+N)</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ▶ 모바일 브라우저에서 쿠키 허용/차단</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; ･크롬(Chrome) : 모바일 브라우저 오른쪽 상단 ‘⋮’ 표시 선택 &gt; 새 시크릿 탭</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; ･사파리(Safari) : 모바일 기기 설정 &gt; 사파리(Safari) &gt; 고급 &gt; 모든 쿠키 차단</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &lt;행태정보의 수집·이용·제공 및 거부 등에 관한 사항&gt;</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"><span style=\"font-family:Verdana;font-size:14px;\"> &nbsp; ①&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 개인의 권리·이익이나 사생활을 침해할 우려가 있는 민감한 행태정보를 수집하지 않습니다. </span><br />\r\n<br />\r\n<span style=\"font-size:14px;font-family:Verdana;\">&nbsp; ②&nbsp;</span><span style=\"font-family:Consolas;\"><span style=\"font-family:Verdana;font-size:14px;\">정보주체는 행태정보와 관련하여 궁금한 사항과 거부권 행사, 피해 신고 접수 등은 </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자를 통해 문의할 수 있습니다.</span></span> <br />\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제10조. 정보주체와 법정대리인의 권리·의무 및 행사방법</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ① 정보주체는 </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자에 대해 언제든지 개인정보 열람·전송·정정·삭제·처리정지 및 동의 철회 등을 요구(이하 “권리 행사”라 함)할 수 있습니다.</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp;※ 14세 미만 아동의 권리 행사는 법정대리인이 직접 해야 하며, 14세 이상의 미성년자인 정보주체는 정보주체의 개인정보에 관하여 미성년자 본인이 권리를 행사하거나 법정대리인을 통하여 권리를 행사할 수 있습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ② 권리 행사는 &lt;개인정보처리자명&gt; 에 대해 「개인정보 보호법 시행령」 제41조제1항에 따라 서면, 전화, 전자우편, 팩스(FAX), 인터넷 등을 통하여 하실 수 있으며, </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 이에 대해 지체없이 조치하겠습니다.</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; &nbsp; - 정보주체는 언제든지 홈페이지 ‘등록정보’에서 개인정보를 직접 조회·수정·삭제하거나 </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자를 통해 열람을 요청할 수 있습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ③ 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수도 있습니다. 이 경우 “개인정보 처리 방법에 관한 고시” [별지 11] 서식에 따른 위임장을 제출해야 합니다.</span> \r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ④ 정보주체가 개인정보 열람 및 처리 정지를 요구할 권리는 「개인정보 보호법」 제35조제4항 및 제37조제2항에 의하여 제한될 수 있습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ⑤ 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 해당 개인정보의 삭제를 요구할 수 없습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ⑥&nbsp;</span><span style=\"font-family:Verdana;font-size:14px;color:#E53333;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 권리 행사를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.</span> \r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ⑦ 정보주체는 권리 행사를 </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자에게 할 수 있습니다. </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 정보주체로부터 권리 행사를 청구받은 날로부터 10일(전송요구의 경우 지체 없이) 이내 회신하겠습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제11조. 권익침해 구제방법</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp;정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보 분쟁조정위원회, 한국인터넷진흥원 개인정보 침해 신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 1. 개인정보 분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 2. 개인정보침해 신고센터 : (국번없이) 118 (privacy.kisa.or.kr)</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 3. 경찰청 : (국번없이) 182 (ecrm.police.go.kr)</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제12조. 추가적인 개인정보 보호노력</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ①&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 정보주체의 개인정보를 안전하게 관리하기 위하여 최선을 다하며, 개인정보 보호법에서 요구하는 안전성 확보 조치 외에도 추가적인 개인정보 보호 노력을 기울이고 있습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ②&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스 관리자는 서비스를 사용하는 사용자들에게 개인정보 및 민감정보를 </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스에 등록하거나 유지하지 않도록 정기적·비정기적 교육 및 확인을 수행하고 있으며, 서비스를 사용하지 않는 경우 시스템을 중단하거나 삭제하고, 사용한 서비스 시스템을 매년 삭제하고 새로 설치함으로써 안전한 개인정보 처리와 개인정보 보호를 위해 노력하고 있습니다.</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제13조. 개인정보 보호책임자</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ①&nbsp;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 서비스의 개인정보 처리에 관한 업무를 총괄해서 책임지고 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; ▶ </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">CSLHUSTOJ</span><span style=\"font-family:Verdana;font-size:14px;\"> 개인정보 보호책임자 </span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">OOO</span><span style=\"font-family:Verdana;font-size:14px;\"> : &lt;</span><span style=\"color:#E53333;font-family:Verdana;font-size:14px;\">이메일</span><span style=\"font-family:Verdana;font-size:14px;\">&gt;</span> \r\n</div>\r\n</span> \r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<div style=\"text-align:left;\">\r\n	<br />\r\n</div>\r\n<span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">□ 제14조. 개인정보 처리방침의 변경</span> \r\n</div>\r\n</span> <span style=\"font-family:Verdana;font-size:16px;\"> \r\n<div style=\"text-align:left;\">\r\n	<span style=\"font-family:Verdana;font-size:14px;\">&nbsp; 이 개인정보 처리방침은 2026.03.01.부터 적용됩니다.</span> \r\n</div>\r\n</span> <br />','2026-02-03 00:12:41',0,0,'N');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `online`
--

DROP TABLE IF EXISTS `online`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `online` (
  `hash` varchar(32) NOT NULL,
  `ip` varchar(46) NOT NULL DEFAULT '',
  `ua` varchar(255) NOT NULL DEFAULT '',
  `refer` varchar(4096) DEFAULT NULL,
  `lastmove` int(10) NOT NULL,
  `firsttime` int(10) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`hash`),
  UNIQUE KEY `hash` (`hash`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `online`
--

LOCK TABLES `online` WRITE;
/*!40000 ALTER TABLE `online` DISABLE KEYS */;
/*!40000 ALTER TABLE `online` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openai_task_queue`
--

DROP TABLE IF EXISTS `openai_task_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `openai_task_queue` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` varchar(40) NOT NULL DEFAULT '',
  `task_type` varchar(24) NOT NULL DEFAULT '',
  `solution_id` bigint(20) DEFAULT 0,
  `problem_id` bigint(20) NOT NULL DEFAULT 0,
  `request_body` mediumtext NOT NULL COMMENT '请求参数(JSON格式字符串)',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态：0:待处理, 1:处理中, 2:已完成, 3:失败',
  `response_body` mediumtext DEFAULT NULL COMMENT '返回结果',
  `error_message` text DEFAULT NULL COMMENT '错误信息',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_date` datetime NOT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status_create` (`status`,`create_date`),
  KEY `idx_user_status` (`user_id`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='异步任务队列-MyISAM版';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openai_task_queue`
--

LOCK TABLES `openai_task_queue` WRITE;
/*!40000 ALTER TABLE `openai_task_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `openai_task_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `printer`
--

DROP TABLE IF EXISTS `printer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
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
INSERT INTO `privilege` VALUES
('admin','administrator','true','N'),
('admin','source_browser','true','N'),
('admin','p1000','true','N');
/*!40000 ALTER TABLE `privilege` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem`
--

DROP TABLE IF EXISTS `problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `problem` (
  `problem_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL DEFAULT '',
  `description` mediumtext DEFAULT NULL,
  `input` mediumtext DEFAULT NULL,
  `output` mediumtext DEFAULT NULL,
  `sample_input` text DEFAULT NULL,
  `sample_output` text DEFAULT NULL,
  `spj` char(1) NOT NULL DEFAULT '0',
  `hint` mediumtext DEFAULT NULL,
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
INSERT INTO `problem` VALUES
(1000,'[빈 번호] (not use)','<p>\r\n	<span style=\"font-family:Verdana;font-size:14px;\">(not use)</span>\r\n</p>','<p>\r\n	<span style=\"font-family:Verdana;font-size:14px;white-space:normal;\">(not use)</span>\r\n</p>','<p>\r\n	<span style=\"font-family:Verdana;font-size:14px;white-space:normal;\">(not use)</span>\r\n</p>','(not use)','(not use)','0','<span class=\"md\"> </span>','','2025-02-08 19:59:44',1.000,128,'Y',0,0,0,NULL,NULL,'','','','(not use)');
/*!40000 ALTER TABLE `problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reply`
--

DROP TABLE IF EXISTS `reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_code` (
  `share_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(48) DEFAULT NULL,
  `title` varchar(32) DEFAULT NULL,
  `share_code` text DEFAULT NULL,
  `language` varchar(32) DEFAULT NULL,
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
/*!40101 SET character_set_client = utf8mb4 */;
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

--
-- Table structure for table `solution`
--

DROP TABLE IF EXISTS `solution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
-- Table structure for table `solution_ai_answer`
--

DROP TABLE IF EXISTS `solution_ai_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `solution_ai_answer` (
  `solution_id` int(11) NOT NULL DEFAULT 0,
  `answer` mediumtext DEFAULT NULL,
  PRIMARY KEY (`solution_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solution_ai_answer`
--

LOCK TABLES `solution_ai_answer` WRITE;
/*!40000 ALTER TABLE `solution_ai_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `solution_ai_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `source_code`
--

DROP TABLE IF EXISTS `source_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = utf8mb4 */;
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
  `expiry_date` date NOT NULL DEFAULT '2099-01-01',
  `nick` varchar(20) NOT NULL DEFAULT '',
  `school` varchar(20) NOT NULL DEFAULT '',
  `group_name` varchar(16) NOT NULL DEFAULT '',
  `activecode` varchar(16) NOT NULL DEFAULT '',
  `starred` int(11) NOT NULL DEFAULT 0,
  `privacy_check` char(1) NOT NULL DEFAULT 'N',
  `privacy_check_date` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
('admin','admin@admin.kr',0,0,'N','10.211.55.2','2026-02-02 23:22:23',1,1,'/tfWFK511+JGtcVOXByjF8p81Vs2OTE5','2025-02-09 07:10:58','2099-01-01','admin','admin','','',0,'',NULL);
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

-- Dump completed on 2026-02-05  7:33:05
