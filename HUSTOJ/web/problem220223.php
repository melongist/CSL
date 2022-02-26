<?php
$cache_time = 10;
$OJ_CACHE_SHARE = false;

require_once('./include/cache_start.php');
require_once('./include/db_info.inc.php');
require_once('./include/const.inc.php');
require_once('./include/my_func.inc.php');
require_once('./include/setlang.php');
if(isset($OJ_LANG)){
	require_once("./lang/$OJ_LANG.php");
}

$now = strftime("%Y-%m-%d %H:%M",time());

if (isset($_GET['cid']))
	$ucid = "&cid=".intval($_GET['cid']);
else
	$ucid = "";

$pr_flag = false;
$co_flag = false;

if (isset($_GET['id'])) {
	//practice
	$id = intval($_GET['id']);
	//require("oj-header.php");
	
	//* by CSL
	$sql="SELECT c.contest_id,c.title FROM contest c INNER JOIN contest_problem cp ON c.contest_id=cp.contest_id AND cp.problem_id=?  WHERE ( '$now'<c.`end_time` AND c.defunct='N' )";
	$used_in_contests=pdo_query($sql,$id);

	if (isset($_SESSION[$OJ_NAME.'_'.'administrator']) || isset($_SESSION[$OJ_NAME.'_'.'contest_creator']) || isset($_SESSION[$OJ_NAME.'_'.'problem_editor']))
		$sql = "SELECT * FROM `problem` WHERE `problem_id`=?";
	else if ($OJ_FREE_PRACTICE)
                $sql = "SELECT * FROM `problem` WHERE defunct='N' and `problem_id`=?";
	else //* by CSL
		$sql = "SELECT * FROM `problem` WHERE `problem_id`=? AND `defunct`='N' AND `problem_id` NOT IN (
				SELECT `problem_id` FROM `contest_problem` WHERE `contest_id` IN (
					SELECT `contest_id` FROM `contest` WHERE ( '$now'<`end_time` AND defunct='N' )
				)
			)";
		
	$pr_flag = true;
	$result = pdo_query($sql,$id);
}
else if (isset($_GET['cid']) && isset($_GET['pid'])) {
	//contest
	$cid = intval($_GET['cid']);
	$pid = intval($_GET['pid']);

	if (isset($_SESSION[$OJ_NAME.'_'.'administrator']) || isset($_SESSION[$OJ_NAME.'_'.'contest_creator']) || isset($_SESSION[$OJ_NAME.'_'.'problem_editor']))
		$sql = "SELECT langmask,private,defunct FROM `contest` WHERE `defunct`='N' AND `contest_id`=?";
	else
		$sql = "SELECT langmask,private,defunct FROM `contest` WHERE `defunct`='N' AND `contest_id`=? AND (`start_time`<='$now' AND '$now'<`end_time`)";

	$result = pdo_query($sql,$cid);
	$rows_cnt = count($result);
	if ($rows_cnt==0) {
		$view_errors = "<title>$MSG_CONTEST</title><h2>No such Contest!</h2>";
		require("template/".$OJ_TEMPLATE."/error.php");
		exit(0);
	}

	$row = ($result[0]);
	$contest_ok = true;

	if ($row[1] && !isset($_SESSION[$OJ_NAME.'_'.'c'.$cid]))
		$contest_ok = false;

	if ($row[2]=='Y')
		$contest_ok = false;

	if (isset($_SESSION[$OJ_NAME.'_'.'administrator']) || isset($_SESSION[$OJ_NAME.'_'.'contest_creator']) || isset($_SESSION[$OJ_NAME.'_'.'problem_editor']))
		$contest_ok = true;
	
	$ok_cnt = $rows_cnt==1;              
	$langmask = $row[0];

	if ($ok_cnt!=1) {
		//not started
		$view_errors = "No such Contest!";
		require("template/".$OJ_TEMPLATE."/error.php");
		exit(0);
	}
	else {
		//started
//	$sql = "SELECT * FROM `problem` WHERE `defunct`='N' AND `problem_id`=(  // <- defunct problem not in list
//	$sql = "SELECT * FROM `problem` WHERE `problem_id`=(    // <-- defunct problem in list for contest but, not in list for practice
		$sql = "SELECT * FROM `problem` WHERE `problem_id`=(
			SELECT `problem_id` FROM `contest_problem` WHERE `contest_id`=? AND `num`=?
		)";
		
		$result = pdo_query($sql,$cid,$pid);
		$id = $result[0]['problem_id'];
	}

	//public
	if (!$contest_ok) {
		$view_errors = "Not Invited!";
		require("template/".$OJ_TEMPLATE."/error.php");
		exit(0);
	}

	$co_flag = true;
}
else {
	$view_errors="<title>$MSG_NO_SUCH_PROBLEM</title><h2>$MSG_NO_SUCH_PROBLEM</h2>";
	require("template/".$OJ_TEMPLATE."/error.php");
	exit(0);
}

if (count($result)!=1) {
	$view_errors = "";

	if (isset($_GET['id'])) {
		$id = intval($_GET['id']);

	      	if(count($used_in_contests)>0){

	      		if (!(isset($OJ_EXAM_CONTEST_ID)||isset($OJ_ON_SITE_CONTEST_ID))) {
					$view_errors.= "<hr><br>$MSG_PROBLEM_USED_IN:";
					foreach($used_in_contests as $contests){
						$view_errors.= "<a class='label label-warning' href='contest.php?cid=". $contests[0]."'>".$contests[1]." </a><br>";	
					
					}
					//echo "</div>";
			}

		}
		else {
			$view_title = "<title>$MSG_NO_SUCH_PROBLEM!</title>";
			$view_errors .= "<h2>$MSG_NO_SUCH_PROBLEM!</h2>";
		}
	}
	else {
		$view_title = "<title>$MSG_NO_SUCH_PROBLEM!</title>";
		$view_errors .= "<h2>$MSG_NO_SUCH_PROBLEM!</h2>";
	}

	require("template/".$OJ_TEMPLATE."/error.php");
	exit(0);
}
else {
	$row = $result[0];
	$view_title = $row['title'];     
}
if( isset($OJ_NOIP_KEYWORD) && $OJ_NOIP_KEYWORD ){
	//检查当前题目是不是在NOIP模式比赛中，如果是则不显示AC数量 2020.7.11 by ivan_zhou
	$now = strftime("%Y-%m-%d %H:%M",time());
	$sql = "select 1 from `contest_problem` where (`problem_id`= ? ) and `contest_id` IN (select `contest_id` from `contest` where `start_time` < ? and `end_time` > ? and `title` like ?)";
	$rrs = pdo_query($sql, $id ,$now , $now , "%$OJ_NOIP_KEYWORD%");
	$flag = count($rrs) > 0 ;
	if($flag)
	{	
		$row[ 'accepted' ] = '<font color="red"> ? </font>';
		$row[ 'hint' ] = $MSG_NOIP_NOHINT;
	}
}
/////////////////////////Template
require("template/".$OJ_TEMPLATE."/problem.php");
/////////////////////////Common foot
if(file_exists('./include/cache_end.php'))
	require_once('./include/cache_end.php');
?>
