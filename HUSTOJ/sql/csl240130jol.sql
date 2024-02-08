-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- 생성 시간: 24-02-09 01:40
-- 서버 버전: 10.6.16-MariaDB-0ubuntu0.22.04.1
-- PHP 버전: 8.1.2-1ubuntu2.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 데이터베이스: `jol`
--
CREATE DATABASE IF NOT EXISTS `jol` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `jol`;

DELIMITER $$
--
-- 프로시저
--
DROP PROCEDURE IF EXISTS `DEFAULT_ADMINISTRATOR`$$
$$

DELIMITER ;

-- --------------------------------------------------------

--
-- 테이블 구조 `balloon`
--

DROP TABLE IF EXISTS `balloon`;
CREATE TABLE `balloon` (
  `balloon_id` int(11) NOT NULL,
  `user_id` char(48) NOT NULL,
  `sid` int(11) NOT NULL,
  `cid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `status` smallint(6) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `compileinfo`
--

DROP TABLE IF EXISTS `compileinfo`;
CREATE TABLE `compileinfo` (
  `solution_id` int(11) NOT NULL DEFAULT 0,
  `error` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `contest`
--

DROP TABLE IF EXISTS `contest`;
CREATE TABLE `contest` (
  `contest_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `defunct` char(1) NOT NULL DEFAULT 'N',
  `description` text DEFAULT NULL,
  `private` tinyint(4) NOT NULL DEFAULT 0,
  `langmask` int(11) NOT NULL DEFAULT 0 COMMENT 'bits for LANG to mask',
  `password` char(16) NOT NULL DEFAULT '',
  `user_id` varchar(48) NOT NULL DEFAULT 'admin'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `contest_problem`
--

DROP TABLE IF EXISTS `contest_problem`;
CREATE TABLE `contest_problem` (
  `problem_id` int(11) NOT NULL DEFAULT 0,
  `contest_id` int(11) DEFAULT NULL,
  `title` char(200) NOT NULL DEFAULT '',
  `num` int(11) NOT NULL DEFAULT 0,
  `c_accepted` int(11) NOT NULL DEFAULT 0,
  `c_submit` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `custominput`
--

DROP TABLE IF EXISTS `custominput`;
CREATE TABLE `custominput` (
  `solution_id` int(11) NOT NULL DEFAULT 0,
  `input_text` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `loginlog`
--

DROP TABLE IF EXISTS `loginlog`;
CREATE TABLE `loginlog` (
  `user_id` varchar(48) NOT NULL DEFAULT '',
  `password` varchar(40) DEFAULT NULL,
  `ip` varchar(46) DEFAULT NULL,
  `time` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 테이블의 덤프 데이터 `loginlog`
--

INSERT INTO `loginlog` (`user_id`, `password`, `ip`, `time`) VALUES
('admin', 'no save', '10.211.55.2', '2024-02-08 23:23:42'),
('admin', 'login ok', '10.211.55.2', '2024-02-09 00:56:51'),
('admin', 'login ok', '10.211.55.2', '2024-02-09 01:34:24');

-- --------------------------------------------------------

--
-- 테이블 구조 `mail`
--

DROP TABLE IF EXISTS `mail`;
CREATE TABLE `mail` (
  `mail_id` int(11) NOT NULL,
  `to_user` varchar(48) NOT NULL DEFAULT '',
  `from_user` varchar(48) NOT NULL DEFAULT '',
  `title` varchar(200) NOT NULL DEFAULT '',
  `content` text DEFAULT NULL,
  `new_mail` tinyint(1) NOT NULL DEFAULT 1,
  `reply` tinyint(4) DEFAULT 0,
  `in_date` datetime DEFAULT NULL,
  `defunct` char(1) NOT NULL DEFAULT 'N'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `news`
--

DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `news_id` int(11) NOT NULL,
  `user_id` varchar(48) NOT NULL DEFAULT '',
  `title` varchar(200) NOT NULL DEFAULT '',
  `content` mediumtext NOT NULL,
  `time` datetime NOT NULL DEFAULT '2016-05-13 19:24:00',
  `importance` tinyint(4) NOT NULL DEFAULT 0,
  `menu` int(11) NOT NULL DEFAULT 0,
  `defunct` char(1) NOT NULL DEFAULT 'N'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 테이블의 덤프 데이터 `news`
--

INSERT INTO `news` (`news_id`, `user_id`, `title`, `content`, `time`, `importance`, `menu`, `defunct`) VALUES
(1000, 'admin', '공지사항 입력 예시입니다.', '\r\n	<span style=\"text-align:center;text-wrap:wrap;background-color:#FFE500;\">-- 관리자 페이지의 공지사항-등록에서 글을 등록하면&#44;</span>\r\n<br />\r\n\r\n	이렇게 메인 페이지의 하단에 나타납니다.\r\n<br />\r\n\r\n	<br />\r\n<br />\r\n\r\n	-- 기초100제 시리즈 문제들은 <span style=\"background-color:#E53333;color:#FFFFFF;\">중고등학교 정보 선생님들만 정보 교과 관련 공교육 목적으로 자유롭게 사용하실 수 있습니다.</span>\r\n<br />\r\n-- 협의되지 않은 사교육&#44; 출판&#44; 인쇄 등 영리 목적으로 임의적 활용시에는 저작권과 관련하여 분쟁이 생길 수 있음을 알려드립니다. <br />\r\n<br />\r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<img src=\"/upload/image/20240208/20240208235939_90918.png\" alt=\"\" /> \r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<br />\r\n<br />', '2024-02-09 00:12:54', 0, 0, 'N'),
(1004, 'admin', 'faqs.ko', '<span style=\"background-color:#FFE500;\">관리자 페이지의 공지사항-리스트에서 faqs.ko 제목의 글을 활성화하면&#44;</span> <br />\r\n이렇게 자주묻는질문 페이지의 화면으로 나타납니다. <br />\r\n<br />\r\n<br />', '2024-02-09 00:10:29', 0, 0, 'N'),
(1005, 'admin', 'home.ko', '<p style=\"text-align:center;\">\r\n	<br />\r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<img src=\"/upload/image/20240209/20240209000318_86606.png\" alt=\"\" /> \r\n<br />\r\n<p style=\"text-align:center;\">\r\n	<span style=\"text-wrap:wrap;background-color:#FFE500;\">관리자 페이지의 공지사항-리스트에서 home.ko 제목의 글을 수정해서 상단 배너 이미지나 글을 넣으면&#44;</span> \r\n<br />\r\n<p style=\"text-align:center;\">\r\n	이렇게 메인 첫 화면 상단에 배너처럼 나타납니다.\r\n<br />', '2024-02-09 00:13:45', 0, 0, 'N'),
(1006, 'admin', '각종 프로그래밍 IDE 설치 방법', '<span style=\"text-wrap:wrap;\">프로그래밍언어를 배우면서&#44; 코드를 작성하고 실행시켜보기 위해서는?</span><br style=\"text-wrap:wrap;\" />\r\n<span style=\"text-wrap:wrap;\">프로그램을 만드는 프로그램으로서 통합개발환경이라고 하는 IDE를 설치해야 합니다.</span><br style=\"text-wrap:wrap;\" />\r\n<span style=\"text-wrap:wrap;\">아래 자료를 꼼꼼히 읽어보면서 따라가면&#44; 누구나 쉽게 무료 IDE를 설치할 수 있습니다.</span><br style=\"text-wrap:wrap;\" />\r\n<br style=\"text-wrap:wrap;\" />\r\n<strong style=\"text-wrap:wrap;\"><span style=\"font-size:14px;\"><strong style=\"text-wrap:wrap;\"><span style=\"font-size:14px;\">- Python IDLE</span></strong></span></strong><br />\r\n<strong style=\"text-wrap:wrap;\"><span style=\"font-size:14px;\"><a class=\"ke-insertfile\" href=\"/upload/file/20240209/20240209001926_64249.pdf\" target=\"_blank\" style=\"text-wrap:wrap;\"><u><span style=\"font-size:12px;\">Windows Python IDLE 설치하기(초보 추천!)</span></u></a><br />\r\n</span></strong><br />\r\n<strong style=\"text-wrap:wrap;\"><span style=\"font-size:14px;\">- C/C++ IDE</span></strong> <br />\r\n<a class=\"ke-insertfile\" href=\"/upload/file/20240209/20240209002054_35947.pdf\" target=\"_blank\"><strong>Windows Dev C++ 설치하기(초보 추천!)</strong></a> <br />\r\n<a class=\"ke-insertfile\" href=\"/upload/file/20240209/20240209002115_69058.pdf\" target=\"_blank\"><strong>Windows CodeBlocks 설치하기</strong></a> <br />\r\n<a class=\"ke-insertfile\" href=\"/upload/file/20240209/20240209002138_64314.pdf\" target=\"_blank\"><strong>macOS Xcode 설치하기(맥북 추천!)</strong></a> <br />\r\n\r\n	<br />\r\n<br />', '2024-02-09 00:24:21', 0, 0, 'N');

-- --------------------------------------------------------

--
-- 테이블 구조 `online`
--

DROP TABLE IF EXISTS `online`;
CREATE TABLE `online` (
  `hash` varchar(32) NOT NULL,
  `ip` varchar(46) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `ua` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `refer` varchar(255) DEFAULT NULL,
  `lastmove` int(10) NOT NULL,
  `firsttime` int(10) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `printer`
--

DROP TABLE IF EXISTS `printer`;
CREATE TABLE `printer` (
  `printer_id` int(11) NOT NULL,
  `user_id` char(48) NOT NULL,
  `in_date` datetime NOT NULL DEFAULT '2018-03-13 19:38:00',
  `status` smallint(6) NOT NULL DEFAULT 0,
  `worktime` timestamp NULL DEFAULT current_timestamp(),
  `printer` char(16) NOT NULL DEFAULT 'LOCAL',
  `content` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `privilege`
--

DROP TABLE IF EXISTS `privilege`;
CREATE TABLE `privilege` (
  `user_id` char(48) NOT NULL DEFAULT '',
  `rightstr` char(30) NOT NULL DEFAULT '',
  `valuestr` char(11) NOT NULL DEFAULT 'true',
  `defunct` char(1) NOT NULL DEFAULT 'N'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 테이블의 덤프 데이터 `privilege`
--

INSERT INTO `privilege` (`user_id`, `rightstr`, `valuestr`, `defunct`) VALUES
('admin', 'administrator', 'true', 'N'),
('admin', 'source_browser', 'true', 'N'),
('admin', 'p', 'true', 'N');

-- --------------------------------------------------------

--
-- 테이블 구조 `problem`
--

DROP TABLE IF EXISTS `problem`;
CREATE TABLE `problem` (
  `problem_id` int(11) NOT NULL,
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
  `credits` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 테이블의 덤프 데이터 `problem`
--

INSERT INTO `problem` (`problem_id`, `title`, `description`, `input`, `output`, `sample_input`, `sample_output`, `spj`, `hint`, `source`, `in_date`, `time_limit`, `memory_limit`, `defunct`, `accepted`, `submit`, `solved`, `remote_oj`, `remote_id`, `front`, `rear`, `bann`, `credits`) VALUES
(1000, '[빈 번호] (not use)', '(not use)\r\n', '(not use)\r\n', '(not use)\r\n', '(not use)\r\n', '(not use)\r\n', '0', '', '', '2024-02-08 23:45:23', '1.000', 128, 'Y', 0, 0, 0, '', '', '', '', '', '(not use)');

-- --------------------------------------------------------

--
-- 테이블 구조 `reply`
--

DROP TABLE IF EXISTS `reply`;
CREATE TABLE `reply` (
  `rid` int(11) NOT NULL,
  `author_id` varchar(48) NOT NULL,
  `time` datetime NOT NULL DEFAULT '2016-05-13 19:24:00',
  `content` text NOT NULL,
  `topic_id` int(11) NOT NULL,
  `status` int(2) NOT NULL DEFAULT 0,
  `ip` varchar(46) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `runtimeinfo`
--

DROP TABLE IF EXISTS `runtimeinfo`;
CREATE TABLE `runtimeinfo` (
  `solution_id` int(11) NOT NULL DEFAULT 0,
  `error` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `share_code`
--

DROP TABLE IF EXISTS `share_code`;
CREATE TABLE `share_code` (
  `share_id` int(11) NOT NULL,
  `user_id` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `share_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `language` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `share_time` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `sim`
--

DROP TABLE IF EXISTS `sim`;
CREATE TABLE `sim` (
  `s_id` int(11) NOT NULL,
  `sim_s_id` int(11) DEFAULT NULL,
  `sim` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 트리거 `sim`
--
DROP TRIGGER IF EXISTS `simfilter`;
DELIMITER $$
CREATE TRIGGER `simfilter` BEFORE INSERT ON `sim` FOR EACH ROW begin
 declare new_user_id varchar(64);
 declare old_user_id varchar(64);
 select user_id from solution where solution_id=new.s_id into new_user_id;
 select user_id from solution where solution_id=new.sim_s_id into old_user_id;
 if old_user_id=new_user_id then
	set new.s_id=0;
 end if;
 
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 테이블 구조 `solution`
--

DROP TABLE IF EXISTS `solution`;
CREATE TABLE `solution` (
  `solution_id` int(11) UNSIGNED NOT NULL,
  `problem_id` int(11) NOT NULL DEFAULT 0,
  `user_id` char(48) NOT NULL,
  `nick` char(20) NOT NULL DEFAULT '',
  `time` int(11) NOT NULL DEFAULT 0,
  `memory` int(11) NOT NULL DEFAULT 0,
  `in_date` datetime NOT NULL DEFAULT '2016-05-13 19:24:00',
  `result` smallint(6) NOT NULL DEFAULT 0,
  `language` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `ip` char(46) NOT NULL,
  `contest_id` int(11) DEFAULT 0,
  `valid` tinyint(4) NOT NULL DEFAULT 1,
  `num` tinyint(4) NOT NULL DEFAULT -1,
  `code_length` int(11) NOT NULL DEFAULT 0,
  `judgetime` timestamp NULL DEFAULT current_timestamp(),
  `pass_rate` decimal(4,3) UNSIGNED NOT NULL DEFAULT 0.000,
  `lint_error` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `judger` char(16) NOT NULL DEFAULT 'LOCAL',
  `remote_oj` char(16) NOT NULL DEFAULT '',
  `remote_id` char(32) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `source_code`
--

DROP TABLE IF EXISTS `source_code`;
CREATE TABLE `source_code` (
  `solution_id` int(11) NOT NULL,
  `source` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `source_code_user`
--

DROP TABLE IF EXISTS `source_code_user`;
CREATE TABLE `source_code_user` (
  `solution_id` int(11) NOT NULL,
  `source` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `topic`
--

DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic` (
  `tid` int(11) NOT NULL,
  `title` varbinary(60) NOT NULL,
  `status` int(2) NOT NULL DEFAULT 0,
  `top_level` int(2) NOT NULL DEFAULT 0,
  `cid` int(11) DEFAULT NULL,
  `pid` int(11) NOT NULL,
  `author_id` varchar(48) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 테이블 구조 `users`
--

DROP TABLE IF EXISTS `users`;
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
  `activecode` varchar(16) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 테이블의 덤프 데이터 `users`
--

INSERT INTO `users` (`user_id`, `email`, `submit`, `solved`, `defunct`, `ip`, `accesstime`, `volume`, `language`, `password`, `reg_time`, `nick`, `school`, `activecode`) VALUES
('admin', 'admin@admin.kr', 0, 0, 'N', '10.211.55.2', '2024-02-09 01:34:24', 1, 1, 'tZtJAkEUNTedhcAqVpgVGZ5IaPk0MTQ1', '2024-02-08 23:23:42', 'admin', 'admin', '');

--
-- 덤프된 테이블의 인덱스
--

--
-- 테이블의 인덱스 `balloon`
--
ALTER TABLE `balloon`
  ADD PRIMARY KEY (`balloon_id`);

--
-- 테이블의 인덱스 `compileinfo`
--
ALTER TABLE `compileinfo`
  ADD PRIMARY KEY (`solution_id`);

--
-- 테이블의 인덱스 `contest`
--
ALTER TABLE `contest`
  ADD PRIMARY KEY (`contest_id`);

--
-- 테이블의 인덱스 `contest_problem`
--
ALTER TABLE `contest_problem`
  ADD KEY `Index_contest_id` (`contest_id`);

--
-- 테이블의 인덱스 `custominput`
--
ALTER TABLE `custominput`
  ADD PRIMARY KEY (`solution_id`);

--
-- 테이블의 인덱스 `loginlog`
--
ALTER TABLE `loginlog`
  ADD KEY `user_log_index` (`user_id`,`time`);

--
-- 테이블의 인덱스 `mail`
--
ALTER TABLE `mail`
  ADD PRIMARY KEY (`mail_id`),
  ADD KEY `uid` (`to_user`);

--
-- 테이블의 인덱스 `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`news_id`);

--
-- 테이블의 인덱스 `online`
--
ALTER TABLE `online`
  ADD PRIMARY KEY (`hash`),
  ADD UNIQUE KEY `hash` (`hash`);

--
-- 테이블의 인덱스 `printer`
--
ALTER TABLE `printer`
  ADD PRIMARY KEY (`printer_id`);

--
-- 테이블의 인덱스 `privilege`
--
ALTER TABLE `privilege`
  ADD KEY `user_id_index` (`user_id`);

--
-- 테이블의 인덱스 `problem`
--
ALTER TABLE `problem`
  ADD PRIMARY KEY (`problem_id`);

--
-- 테이블의 인덱스 `reply`
--
ALTER TABLE `reply`
  ADD PRIMARY KEY (`rid`),
  ADD KEY `author_id` (`author_id`);

--
-- 테이블의 인덱스 `runtimeinfo`
--
ALTER TABLE `runtimeinfo`
  ADD PRIMARY KEY (`solution_id`);

--
-- 테이블의 인덱스 `share_code`
--
ALTER TABLE `share_code`
  ADD PRIMARY KEY (`share_id`);

--
-- 테이블의 인덱스 `sim`
--
ALTER TABLE `sim`
  ADD PRIMARY KEY (`s_id`);

--
-- 테이블의 인덱스 `solution`
--
ALTER TABLE `solution`
  ADD PRIMARY KEY (`solution_id`),
  ADD KEY `uid` (`user_id`),
  ADD KEY `pid` (`problem_id`),
  ADD KEY `res` (`result`),
  ADD KEY `cid` (`contest_id`);

--
-- 테이블의 인덱스 `source_code`
--
ALTER TABLE `source_code`
  ADD PRIMARY KEY (`solution_id`);

--
-- 테이블의 인덱스 `source_code_user`
--
ALTER TABLE `source_code_user`
  ADD PRIMARY KEY (`solution_id`);

--
-- 테이블의 인덱스 `topic`
--
ALTER TABLE `topic`
  ADD PRIMARY KEY (`tid`),
  ADD KEY `cid` (`cid`,`pid`);

--
-- 테이블의 인덱스 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- 덤프된 테이블의 AUTO_INCREMENT
--

--
-- 테이블의 AUTO_INCREMENT `balloon`
--
ALTER TABLE `balloon`
  MODIFY `balloon_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 테이블의 AUTO_INCREMENT `contest`
--
ALTER TABLE `contest`
  MODIFY `contest_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1000;

--
-- 테이블의 AUTO_INCREMENT `mail`
--
ALTER TABLE `mail`
  MODIFY `mail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1013;

--
-- 테이블의 AUTO_INCREMENT `news`
--
ALTER TABLE `news`
  MODIFY `news_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1007;

--
-- 테이블의 AUTO_INCREMENT `printer`
--
ALTER TABLE `printer`
  MODIFY `printer_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 테이블의 AUTO_INCREMENT `problem`
--
ALTER TABLE `problem`
  MODIFY `problem_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;

--
-- 테이블의 AUTO_INCREMENT `reply`
--
ALTER TABLE `reply`
  MODIFY `rid` int(11) NOT NULL AUTO_INCREMENT;

--
-- 테이블의 AUTO_INCREMENT `share_code`
--
ALTER TABLE `share_code`
  MODIFY `share_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1000;

--
-- 테이블의 AUTO_INCREMENT `solution`
--
ALTER TABLE `solution`
  MODIFY `solution_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;

--
-- 테이블의 AUTO_INCREMENT `topic`
--
ALTER TABLE `topic`
  MODIFY `tid` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
