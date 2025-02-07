<?php 
@ini_set("display_errors", "Off");
@session_start();
require_once "include/db_info.inc.php";
require_once "include/my_func.inc.php";
require_once "include/email.class.php";
require_once "include/base64.php";

if(isset($OJ_CSRF) && $OJ_CSRF && $OJ_TEMPLATE=="bs3" && !isset($_SESSION[$OJ_NAME.'_'.'http_judge']))
  require_once(dirname(__FILE__)."/include/csrf_check.php");

if (!isset($_SESSION[$OJ_NAME . '_' . 'user_id'])) {
 
	$view_errors = "<a href=loginpage.php>$MSG_Login</a>";
	require("template/".$OJ_TEMPLATE."/error.php");
	exit(0);
}

require_once "include/memcache.php";
require_once "include/const.inc.php";

$now = strftime("%Y-%m-%d %H:%M", time());
$user_id = $_SESSION[$OJ_NAME.'_'.'user_id'];
$language = intval($_POST['language']);

if (!$OJ_BENCHMARK_MODE) {
  $sql = "select count(1) cnt FROM `solution` WHERE result<4";
  $result = mysql_query_cache($sql);
  $row = $result[0];
  if ($row['cnt'] > 50) {
    $OJ_VCODE = true;
  }

  if ($OJ_VCODE) {
    $vcode = $_POST["vcode"];
  }

  $err_str = "";
  $err_cnt = 0;

  if ($OJ_VCODE && ($_SESSION[$OJ_NAME.'_'."vcode"]==null || $vcode!=$_SESSION[$OJ_NAME.'_'."vcode"] || $vcode=="" || $vcode==null)) {
    $_SESSION[$OJ_NAME.'_'."vcode"] = null;
    $err_str = $err_str.$MSG_VCODE_WRONG."\n";
    $err_cnt++;
    $view_errors = $err_str;
    $_SESSION[ $OJ_NAME . '_' . "vfail" ]=true;
    require "template/".$OJ_TEMPLATE."/error.php";
    exit(0);
  }else{
          $_SESSION[ $OJ_NAME . '_' . "vfail" ]=false;
  }

}

$test_run = false;
if (isset($_POST['cid'])) {
  $pid = intval($_POST['pid']);
  $cid = intval($_POST['cid']);
  $test_run = $cid<0;
  if($test_run) $cid =-$cid ;
  $_GET['cid']=$cid;
  require_once("contest-check.php");
  $sql = "select `problem_id`,'N' defunct  FROM `contest_problem` WHERE `num`='$pid' AND contest_id=$cid";

}
else {
  $id = intval($_POST['id']);
  $test_run = $id<=0;
  $sql = "select `problem_id`,defunct FROM `problem` WHERE `problem_id`='$id' ";
    
  if(!($test_run||isset($_SESSION[$OJ_NAME.'_'.'administrator'])))
    $sql .= " and defunct='N'";
}

//echo $sql;
if(!$test_run){
	$res = mysql_query_cache($sql);
	if (isset($res) && count($res)<1 && !isset($_SESSION[$OJ_NAME.'_'.'administrator']) && !((isset($cid)&&$cid<=0) || (isset($id)&&$id<=0))) {
	  $view_errors = $MSG_LINK_ERROR."<br>";
	  require "template/".$OJ_TEMPLATE."/error.php";
	  exit(0);
	}
}
if ((!empty($res) ) && $res[0]['defunct']!='N' && !($test_run||isset($_SESSION[$OJ_NAME.'_'.'administrator']))) {
   // echo "res:$res,count:".count($res);
   //  echo "$sql";
  $view_errors = $MSG_PROBLEM_RESERVED."<br>";

  if (isset($_POST['ajax'])) {
    echo $view_errors.$res[0][1];
    exit(0);
  }
  else {
    require "template/".$OJ_TEMPLATE."/error.php";
  }
  exit(0);
}

$title = "";

if (isset($_POST['id'])) {
  $id = intval($_POST['id']);
  if($id<=0) $id=-$id;
  $langmask = $OJ_LANGMASK;
}
else if (isset($_POST['pid']) && isset($_POST['cid']) && $_POST['cid']!=0) {

  //check user if private
  $sql = "select `private`,langmask,title FROM `contest` WHERE `contest_id`=? AND `start_time`<=? AND `end_time`>? ";
  //"SELECT `private`,langmask FROM `contest` WHERE `contest_id`=? AND `start_time`<=? AND `end_time`>?";
  //$result = pdo_query($sql, $cid, $now, $now);

  $result = mysql_query_cache($sql, $cid, $now, $now);
  

  if (empty($result)) {
    $view_errors .= $MSG_NOT_IN_CONTEST;
    require "template/" . $OJ_TEMPLATE . "/error.php";
    exit(0);
  }
  else {
    $row = $result[0];
    $isprivate = intval($row['private']);
    $langmask = $row['langmask'];
    $title = $row['title'];


    if ($isprivate==1 && !isset($_SESSION[$OJ_NAME.'_'.'c'.$cid])) {
      $sql = "SELECT count(*) FROM `privilege` WHERE `user_id`=? AND `rightstr`=?";
      $result = pdo_query($sql, $user_id, "c$cid");

      $row = $result[0];
      $ccnt = intval($row[0]);

      if ($ccnt==0 && !isset($_SESSION[$OJ_NAME.'_'.'administrator'])) {
        $view_errors = $MSG_NOT_INVITED."\n";
        require "template/" . $OJ_TEMPLATE . "/error.php";
        exit(0);
      }
    }
  }

  $sql = "SELECT `problem_id` FROM `contest_problem` WHERE `contest_id`=? AND `num`=?";
  $result = pdo_query($sql, $cid, $pid);

  if (empty($result)) {
    $view_errors = $MSG_NO_PROBLEM."\n";
    require "template/".$OJ_TEMPLATE."/error.php";
    exit(0);
  }else {
    $row = $result[0];
    $id = intval($row['problem_id']);
    
    if ($test_run) {
      $id = -$id;
    }
  }
  
}
else {
  $id = 0;
  /*
  $view_errors= "No Such Problem!\n";
  require("template/".$OJ_TEMPLATE."/error.php");
  exit(0);
  */
  $langmask = $OJ_LANGMASK;
  $test_run = true;
}

if ($language > count($language_name) || $language < 0) {
  $language = 0;
}

$language = strval($language);

if ($langmask&(1<<$language)) {
  $view_errors = $MSG_NO_PLS."\n[$language][$langmask][".($langmask&(1<<$language))."]";
  require "template/".$OJ_TEMPLATE."/error.php";
  exit(0);
}

$source = $_POST['source'];
$input_text = "";

if (isset($_POST['input_text'])) {
  $input_text = $_POST['input_text'];
}


//+ by CSL
//함수 제출형, 코드 제한형 문제 처리
$sql = "SELECT `front`, `rear`, `bann` FROM `problem` WHERE `problem_id`='$id' ";
$res = mysql_query_cache($sql);

$prow = $res[0];
$front = $prow['front'];
$rear = $prow['rear'];

$bann = $prow['bann'];
if($bann){
  $banned_words = explode('/', $bann);
  $bann_cnt = count($banned_words);
  for($i=0; $i<$bann_cnt; $i++){
    if( strpos($_POST['source'], $banned_words[$i]) !== false) {
        $view_errors = "해당 문제에서 사용이 제한된 코드가 포함되어있습니다!";
        require("template/".$OJ_TEMPLATE."/error.php");
        exit(0);
    }
  }
}

if($front || $rear)
   $source = $front.$source.$rear; //front코드+제출코드+rear코드 결합
//+ by CSL
//함수 제출형, 코드 제한형 문제 처리 여기까지 코드 삽입


if (isset($_POST['encoded_submit'])) {

  $source = decode64($source);
}

$input_text = preg_replace("(\r\n)", "\n", $input_text);

if ($test_run) {
  $id = -$id;
}

if(!empty($_FILES)){
        $tempfile = $_FILES ["answer"] ["tmp_name"];
        $len=$_FILES['answer']['size'];
        $origin_name=trim($_FILES ["answer"]['name']);
}else{
        $origin_name="not upload";
}
if(isset($tempfile)&&$tempfile!=""){
	if($language!=23){
		if ($len > 65536) {
			  $view_errors = $MSG_TOO_LONG."<br>";
			  require "template/" . $OJ_TEMPLATE . "/error.php";
			  exit(0);
		}
		$source=file_get_contents($tempfile);
		$len = strlen($source);
		unlink($tempfile);
	}else{
		$source="Main.sb3";
	}
}
$solution_file = "$OJ_DATA/$id/solution.name";
if(file_exists($solution_file)){
        $solution_name=trim(file_get_contents($solution_file));
        if($origin_name!=$solution_name){
                $source="uploaded file name [$origin_name] is not [$solution_name] ";
        }
}

$source_user = $source;

//use append Main code
$prepend_file = "$OJ_DATA/$id/prepend.".$language_ext[$language];

if (isset($OJ_APPENDCODE) && $OJ_APPENDCODE && file_exists($prepend_file)) {
  $source = file_get_contents($prepend_file)."\n".$source;
}

$append_file = "$OJ_DATA/$id/append.".$language_ext[$language];
//echo $append_file;

if (isset($OJ_APPENDCODE) && $OJ_APPENDCODE && file_exists($append_file)) {
  $source .= "\n".file_get_contents($append_file);
//echo "$source";
}
//end of append

$spj=pdo_query("select spj from problem where problem_id=?",$id);
if(count($spj)>0) $spj=$spj[0][0];

if ($language == 6 && $spj!= 2) {
  $source = "# coding=utf-8\n".$source;
}

if ($test_run) {
  $id = 0;
}

if($language!=23) $len = strlen($source); else $len = $_FILES['answer']['size'];
if ($len < 2) {
  $view_errors = $MSG_TOO_SHORT.$tempfile."<br>";
  require "template/".$OJ_TEMPLATE."/error.php";
  exit(0);
}
if ($len > 65536) {
  $view_errors = $MSG_TOO_LONG."<br>";
  require "template/" . $OJ_TEMPLATE . "/error.php";
  exit(0);
}


setcookie('lastlang', $language, time()+360000);

$ip = $_SERVER['REMOTE_ADDR'];

if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
  $REMOTE_ADDR = $_SERVER['HTTP_X_FORWARDED_FOR'];
  $tmp_ip = explode(',', $REMOTE_ADDR);
  $ip = htmlentities($tmp_ip[0], ENT_QUOTES, "UTF-8");
}



if (!$OJ_BENCHMARK_MODE) {
  // last submit
  if(!isset($OJ_SUBMIT_COOLDOWN_TIME))  $OJ_SUBMIT_COOLDOWN_TIME = 5;
  $now = strftime("%Y-%m-%d %X", time()-$OJ_SUBMIT_COOLDOWN_TIME);
  $sql = "SELECT `in_date`,solution_id FROM `solution` WHERE `user_id`=? AND in_date>? ORDER BY `in_date` DESC LIMIT 1";
  $res = pdo_query($sql, $user_id, $now);

  if (!empty($res)) {
    /*
    $view_errors = $MSG_BREAK_TIME."<br>";
    require "template/".$OJ_TEMPLATE."/error.php";
    exit(0);
       // 预防WAF抽风
    */
        if(isset($_GET['ajax'])){
                echo -1;
        }else{
                $statusURI = "status.php?user_id=".$_SESSION[$OJ_NAME.'_'.'user_id'];
                if (isset($cid)) {
                        if(isset($_GET['spa'])) $statusURI .="&spa";
                        $statusURI .= "&cid=$cid&fixed=";
                }
                if (!$test_run) {
                        header("Location: $statusURI");
                } else {
                        echo $res[0][1];
                }
        }
        exit();

   }

}

if (~$OJ_LANGMASK&(1<<$language)) {
  $sql = "select nick FROM users WHERE user_id=?";
  $nick = pdo_query($sql, $user_id);
	
  if (!empty($nick)) {
    $nick = $nick[0]['nick'];
  }else{
    $nick = "Guest";
  }
  if(empty($nick)) $nick=$user_id;


  if (!isset($pid)) {
    $sql = "INSERT INTO solution(problem_id,user_id,nick,in_date,language,ip,code_length,result) VALUES(?,?,?,NOW(),?,?,?,14)";
    $insert_id = pdo_query($sql, $id, $user_id, $nick, $language, $ip, $len);
  }
  else {
    $sql = "INSERT INTO solution(problem_id,user_id,nick,in_date,language,ip,code_length,contest_id,num,result) VALUES(?,?,?,NOW(),?,?,?,?,?,14)";

    if ((stripos($title,$OJ_NOIP_KEYWORD)!==false) && isset($OJ_OI_1_SOLUTION_ONLY) && $OJ_OI_1_SOLUTION_ONLY) {
      $delete = pdo_query("DELETE FROM solution WHERE contest_id=? AND user_id=? AND num=?", $cid, $user_id, $pid);

      if ($delete>0) {
        $sql_fix = "UPDATE problem p INNER JOIN (SELECT problem_id pid ,count(1) ac FROM solution WHERE problem_id=? AND result=4) s ON p.problem_id=s.pid SET p.accepted=s.ac;";        
        $fixed = pdo_query($sql_fix,$id);
        $sql_fix = "UPDATE problem p INNER JOIN (SELECT problem_id pid ,count(1) submit FROM solution WHERE problem_id=?) s ON p.problem_id=s.pid SET p.submit=s.submit;";
        $fixed = pdo_query($sql_fix,$id);
      }
    }

    $insert_id = pdo_query($sql, $id, $user_id, $nick, $language, $ip, $len, $cid, $pid);
  }
  if($language==23){
  	mkdir($OJ_DATA."/$id/sb3");
	copy($tempfile,$OJ_DATA."/$id/sb3/$insert_id.sb3");
  }
  $sql = "INSERT INTO `source_code_user`(`solution_id`,`source`) VALUES(?,?)";
  pdo_query($sql, $insert_id, $source_user);

  $sql = "INSERT INTO `source_code`(`solution_id`,`source`) VALUES(?,?)";
  pdo_query($sql, $insert_id, $source);

  if ($test_run) {
    $sql = "INSERT INTO `custominput`(`solution_id`,`input_text`) VALUES(?,?)";
    pdo_query($sql, $insert_id, $input_text);
  }
  else {
    $sql = "UPDATE problem SET submit=submit+1 WHERE problem_id=?";
    pdo_query($sql,$id);

    if (isset($cid) && $cid>0) {
      $sql = "UPDATE contest_problem SET c_submit=c_submit+1 WHERE contest_id=? AND num=?";
      pdo_query($sql,$cid,$pid);
    }
  }


 ////remote oj
  $result=0;
  $sql="select remote_oj from problem where problem_id=?";
  $remote_oj=pdo_query($sql,$id);
  if(isset($remote_oj[0])){
          $remote_oj=$remote_oj[0][0];
          if($remote_oj!=""){
                $result=16;
                $sql="update solution set result=16,remote_oj=? where solution_id=?";
                pdo_query($sql,$remote_oj,$insert_id);
          }
  }
  
  ////poison robot account,give system resources to the REAL people
  if(isset($OJ_POISON_BOT_COUNT) && $OJ_POISON_BOT_COUNT >0 &&
          !(isset($_SESSION[$OJ_NAME."_administrator"])||
            isset($_SESSION[$OJ_NAME."_source_browser"])||
            isset($_SESSION[$OJ_NAME."_contest_creator"])||
            isset($_SESSION[$OJ_NAME."_problem_editor"])||
	    $id==0
           )
    ){
        $sql="select count(1) from solution where user_id=? and result=4 and problem_id=?";
        $count=pdo_query($sql,$user_id,$id);
        if($count) $count=$count[0][0];
        if($count>=$OJ_POISON_BOT_COUNT || strpos($UA,"91.0.4472.77") !== false){
                $result=rand(5,11);
                $memory=rand(100,2000);
                $time=rand(100,2000);
                $sql="update solution set memory=?,time=?,judger='poisoner' where solution_id=?";
                pdo_query($sql,$memory,$time,$insert_id);
                if( $OJ_ADMIN != "root@localhost" ){
                         email($OJ_ADMIN,$MSG_SYS_WARN,"$DOMAIN $MSG_USER $user_id $MSG_IS_ROBOT");
                }
        }
        /*   //prepare system ready for even worse robots
        $now = strftime("%Y-%m-%d %X", time()-$OJ_SUBMIT_COOLDOWN_TIME * 6 );
        $sql="select count(1) from solution where user_id=? and in_date > ?";
        $count=pdo_query($sql,$user_id,$now);
        if($count>=$OJ_POISON_BOT_COUNT){
                $sql="update users set defunct='Y' where user_id=?";
                pdo_query($sql,$_SESSION[$OJ_NAME."_user_id"]);
                $sql="select ip from users where user_id=? ";
                $ip=pdo_query($sql,$_SESSION[$OJ_NAME."_user_id"]);
                if(count($ip)>0){
                        $ip=$ip[0][0];
                        if($ip!="" && $ip!="127.0.0.1"){
                                $sql="update users set defunct='Y' where ip=?";
                                pdo_query($sql,$ip);
                        }
                }
                unset($_SESSION[$OJ_NAME.'_'.'user_id']);
                setcookie($OJ_NAME."_user","");
                setcookie($OJ_NAME."_check","");
                session_destroy();
                header("Location:index.php");
        }
        */
  }

  $sql = "UPDATE solution SET result=? WHERE solution_id=?";
  pdo_query($sql,$result,$insert_id);


  //using redis task queue
  if ( $OJ_REDIS && $result==0 ) {
    $redis = new Redis();
    $redis->connect($OJ_REDISSERVER, $OJ_REDISPORT);
    
    if (isset($OJ_REDISAUTH)) {
      $redis->auth($OJ_REDISAUTH);
    }

    $redis->lpush($OJ_REDISQNAME, $insert_id);
    $redis->close();
  }
}

if (isset($OJ_UDP) && $OJ_UDP && $result==0 ) {      
           trigger_judge($insert_id);     // moved to my_func.inc.php
}

if ($OJ_BENCHMARK_MODE) {
  echo $insert_id;
  exit(0);
}

$statusURI = strstr($_SERVER['REQUEST_URI'], "submit", true)."status.php";

if (isset($cid)) {
  $statusURI .= "?cid=$cid";
}

$sid = "";
if (isset($_SESSION[$OJ_NAME.'_'.'user_id'])) {
  $sid .= session_id().$_SERVER['REMOTE_ADDR'];
}

if (isset($_SERVER["REQUEST_URI"])) {
  $sid .= $statusURI;
}
//echo $statusURI."<br>";

$sid = md5($sid);
$file = "cache/cache_$sid.html";
//echo $file;

if ($OJ_MEMCACHE) {
  $mem = new Memcache();
    
  if ($OJ_SAE) {
    $mem = memcache_init();
  }
  else {
    $mem->connect($OJ_MEMSERVER, $OJ_MEMPORT);
  }
    
  $mem->delete($file, 0);
}
elseif (file_exists($file)) {
  unlink($file);
}
//echo $file;

$statusURI = "status.php?user_id=".$_SESSION[$OJ_NAME.'_'.'user_id'];
if(isset($_GET['spa'])) $statusURI .="&spa";

if (isset($cid)) {
  $statusURI .= "&cid=$cid&fixed=";
}

if (!$test_run&&!isset($_GET['ajax'])) {
  header("Location: $statusURI");
}
else {
  if (isset($_GET['ajax'])) {
    echo $insert_id;
  }
  else {
    ?>
    <script>window.parent.setTimeout("fresh_result('<?php echo $insert_id; ?>')",1000);</script><?php
  }
}
?>
