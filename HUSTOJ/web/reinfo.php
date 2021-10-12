<?php
$cache_time = 10;
$OJ_CACHE_SHARE = false;

require_once('./include/cache_start.php');
require_once('./include/db_info.inc.php');
require_once('./include/setlang.php');

$view_title = "Welcome To Online Judge";

if(!isset($_SESSION[$OJ_NAME.'_'.'user_id'])){
  header("location:loginpage.php");
  exit(0);
} 

require_once("./include/const.inc.php");

if(!isset($_GET['sid'])){
  echo "No such code!\n";
  require_once("oj-footer.php");
  exit(0);
}

function is_valid($str2){
  global $_SESSION,$OJ_NAME;
  if(isset($_SESSION[$OJ_NAME.'_'.'source_browser'])) return true;
  $n = strlen($str2);
  $str = str_split($str2);
  $m = 1;
  for($i=0; $i<$n; $i++){
    if(is_numeric($str[$i]))
      $m++;
  }
  return $n/$m>3;
}

if(!isset($_SESSION[$OJ_NAME.'_'.'user_id'])){
  $view_errors = $MSG_WARNING_ACCESS_DENIED ;
  require("template/".$OJ_TEMPLATE."/error.php");
  exit(0);
}

$ok = false;
$id = strval(intval($_GET['sid']));

$sql = "SELECT * FROM `solution` WHERE `solution_id`=?";
$result = pdo_query($sql,$id);
$row = $result[0];
$lang = $row['language'];
$contest_id = intval($row['contest_id']);
$isRE = $row['result']==10;

if((isset($_SESSION[$OJ_NAME.'_'.'user_id']) && $row && ($row['user_id']==$_SESSION[$OJ_NAME.'_'.'user_id']) && $OJ_SHOW_DIFF==true)||isset($_SESSION[$OJ_NAME.'_'.'source_browser']))
{
  $ok = true;
}

$view_reinfo = "";
if($ok){
  if($row['user_id']!=$_SESSION[$OJ_NAME.'_'.'user_id']){
    $view_mail_link= "<a href='mail.php?to_user=".htmlentities($row['user_id'],ENT_QUOTES,"UTF-8")."&title=$MSG_SUBMIT $id'>Mail the auther</a>";
  }
  
  $sql = "SELECT `error` FROM `runtimeinfo` WHERE `solution_id`=?";
  $result = pdo_query($sql,$id);

  if(isset($result[0])){
    $row = $result[0];
  }

  if($OJ_SHOW_DIFF && $row && ($ok||$isRE) && ($OJ_TEST_RUN||is_valid($row['error'])||$ok)){ 
    $view_reinfo = htmlentities(str_replace("\n\r","\n",$row['error']),ENT_QUOTES,"UTF-8");
  }
  else{
    $view_errors = $MSG_WARNING_ACCESS_DENIED;
  }
}
else{
  $view_errors = $MSG_WARNING_ACCESS_DENIED;
  require("template/".$OJ_TEMPLATE."/error.php");
  exit(0);
}

/////////////////////////Template

if($OJ_SHOW_DIFF==false){
  $view_errors = $MSG_WARNING_ACCESS_DENIED;
  require("template/".$OJ_TEMPLATE."/error.php");
  exit(0);
}
else{
  require("template/".$OJ_TEMPLATE."/reinfo.php");
}
/////////////////////////Common foot
if(file_exists('./include/cache_end.php')){
  require_once('./include/cache_end.php');
}
?>