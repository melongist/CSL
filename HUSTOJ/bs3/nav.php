<!-- /web/template/bs3/nav.php -->

<?php 
require_once(dirname(__FILE__)."/../../include/memcache.php");
function get_menu_news()
{
  $result = "";
  $sql_news_menu = "SELECT `news_id`,`title` FROM `news` WHERE `menu`=1 AND `title`!='faqs.cn' ORDER BY `importance` ASC,`time` DESC LIMIT 10";
  $sql_news_menu_result = mysql_query_cache($sql_news_menu);
  
  if($sql_news_menu_result)
  {
    foreach($sql_news_menu_result as $row)
    {
      $result .= '<li><a class="item" href="/viewnews.php?id='.$row['news_id'].'">'."<span class='glyphicon glyphicon-star' aria-hidden='true'>".$row['title'].'</a></li>';
    }
  }
  return $result;
}

if(stripos($_SERVER['REQUEST_URI'],"template")!==false)
  exit();

$url = basename($_SERVER['REQUEST_URI']);
$dir = basename(getcwd());

if($dir=="discuss3")
  $path_fix = "../";
else
  $path_fix = "";

if(isset($OJ_NEED_LOGIN) && $OJ_NEED_LOGIN && ($url!='loginpage.php' && $url!='lostpassword.php' && $url!='lostpassword2.php' && $url!='registerpage.php') && !isset($_SESSION[$OJ_NAME.'_'.'user_id']))
{
  header("location:".$path_fix."loginpage.php");
  exit();
}

$_SESSION[$OJ_NAME.'_'.'profile_csrf'] = rand();

if($OJ_ONLINE)
{
  require_once($path_fix.'include/online.php');
  $on = new online();
}

$sql_news_menu_result_html = "";

if($OJ_MENU_NEWS)
{
  if($OJ_REDIS)
  {
    $redis = new Redis();
    $redis->connect($OJ_REDISSERVER, $OJ_REDISPORT);

    if(isset($OJ_REDISAUTH))
    {
      $redis->auth($OJ_REDISAUTH);
    }
    
    $redisDataKey = $OJ_REDISQNAME.'_MENU_NEWS_CACHE';
    
    if($redis->exists($redisDataKey))
    {
      $sql_news_menu_result_html = $redis->get($redisDataKey);
    }
    else
    {
      $sql_news_menu_result_html = get_menu_news();
      $redis->set($redisDataKey, $sql_news_menu_result_html);
      $redis->expire($redisDataKey, 300);
    }

    $redis->close();
  }
  else
  {
    $sessionDataKey = $OJ_NAME.'_'."_MENU_NEWS_CACHE";
    
    if(isset($_SESSION[$sessionDataKey]))
    {
      $sql_news_menu_result_html = $_SESSION[$sessionDataKey];
    }
    else
    {
      $sql_news_menu_result_html = get_menu_news();
      $_SESSION[$sessionDataKey] = $sql_news_menu_result_html;
    }
  }
  //$sql_news_menu_result_html=" <li>$sql_news_menu_result_html</li>";
}

if(!isset($_GET['spa']))
{?>
<!-- Static navbar -->
<nav class="navbar navbar-default" role="navigation" style="position:fixed;z-index:99;width:98%;margin-bottom:50px">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="<?php echo $OJ_HOME?>"><i class="icon-home"></i><?php echo $OJ_NAME?></a>
  <?php
    if(file_exists("moodle"))
    {
  ?>
      <a class="navbar-brand" href="moodle"><i class="icon-home"></i>Moodle</a>
  <?php
    }
  ?>
    </div>
    <div id="navbar" class="navbar-collapse collapse">
      <ul class="nav navbar-nav">
        <?php $ACTIVE="class='active'"?>
        <?php
        if(!isset($OJ_ON_SITE_CONTEST_ID))
        {
        ?>
        <li <?php if ($url=="faqs.php") echo " $ACTIVE"; ?>>
          <a href="<?php echo $path_fix?>faqs.php">
            <span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span> <?php echo $MSG_FAQ?>
          </a>
        </li>
        <?php
        }
        else
        {
        ?>
        <?php
        }
        ?>

        <?php
        if(isset($OJ_PRINTER) && $OJ_PRINTER)
        {
        ?>
        <li <?php if ($url=="printer.php") echo " $ACTIVE";?>>
          <a href="<?php echo $path_fix?>printer.php">
            <span class="glyphicon glyphicon-print" aria-hidden="true"></span> <?php echo $MSG_PRINTER?>
          </a>
        </li>
        <?php
        }
        ?>

        <?php
        //if(!isset($OJ_ON_SITE_CONTEST_ID) && !isset($_GET['cid']))
        //{
        ?>

        <?php
        if(!isset($OJ_ON_SITE_CONTEST_ID))
        {
        ?>
        <?php if(isset($OJ_BBS)&&$OJ_BBS) {?>
        <li <?php if($url=="discuss.php") echo " $ACTIVE";?>>
          <a href="<?php echo $path_fix?>bbs.php"><span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span><?php echo $MSG_BBS?></a>
        </li>
        <?php }?>        
        <li <?php if ($url=="problemset.php") echo " $ACTIVE";?>>
          <a href="<?php echo $path_fix?>problemset.php" ><span class="glyphicon glyphicon-book" aria-hidden="true"></span> <?php echo $MSG_PROBLEMS?></a>
        </li>
        <li <?php if ($url=="category.php") echo " $ACTIVE";?>>
          <a href="<?php echo $path_fix?>category.php"><span class="glyphicon glyphicon-th" aria-hidden="true"></span> <?php echo $MSG_SOURCE?></a>
        </li>
        <li <?php if ($url=="status.php") echo " $ACTIVE";?>>
          <a href="<?php echo $path_fix?>status.php"><span class="glyphicon glyphicon-play-circle" aria-hidden="true"></span> <?php echo $MSG_STATUS?></a>
        </li>
        <li <?php if ($url=="ranklist.php") echo " $ACTIVE";?>>
          <a href="<?php echo $path_fix?>ranklist.php"><span class="glyphicon glyphicon-thumbs-up" aria-hidden="true"></span> <?php echo $MSG_RANKLIST?></a>
        </li>
        <li <?php if ($url=="contest.php") echo " $ACTIVE";?>>
          <a href="<?php echo $path_fix?>contest.php<?php if(isset($_SESSION[$OJ_NAME."_user_id"])) echo "?my"  ?>"><span class="glyphicon glyphicon-tasks" aria-hidden="true"></span> <?php echo $MSG_CONTEST?></a>
        </li>
        <?php
        }
        else
        {
        ?>
        <li <?php if ($url=="contest.php") echo " $ACTIVE";?>>
          <a href="<?php echo $path_fix?>contest.php" ><span class="glyphicon glyphicon-fire" aria-hidden="true"></span> <?php echo $MSG_CONTEST?></a>
        </li>
        <?php
        }
        ?>
        <?php echo $sql_news_menu_result_html; ?>
        <?php
        if(isset($_GET['cid']))
        {
          $cid = intval($_GET['cid']);
        }
        ?>

  <!--<li class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <span class="caret"></span></a>
  <ul class="dropdown-menu" role="menu">
  <li><a href="#">Action</a></li>
  <li><a href="#">Another action</a></li>
  <li><a href="#">Something else here</a></li>
  <li class="divider"></li>
  <li class="dropdown-header">Nav header</li>
  <li><a href="#">Separated link</a></li>
  <li><a href="#">One more separated link</a></li>
  </ul>
  </li>
  -->
      </ul>

      <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span id="profile">Login</span><span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu">
            <script src="<?php echo $path_fix."template/$OJ_TEMPLATE/profile.php?profile_csrf=".$_SESSION[$OJ_NAME.'_'.'profile_csrf'];?>" ></script>
            <!--<li><a href="../navbar-fixed-top/">Fixed top</a></li>-->
          </ul>
        </li>
      </ul>

      <!-- select language -->
      <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span id="profile">Language</span><span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu">
            <li><a href="setlang.php?lang=cn">中文</a></li>
            <li><a href="setlang.php?lang=ug">ئۇيغۇرچە</a></li>
            <li><a href="setlang.php?lang=en">English</a></li>
            <li><a href="setlang.php?lang=fa">فارسی</a></li>
            <li><a href="setlang.php?lang=th">ไทย</a></li>
            <li><a href="setlang.php?lang=ko">한국어</a></li>
          </ul>
        </li>
      </ul><!-- select language -->

    </div><!--/.nav-collapse -->
  </div><!--/.container-fluid -->
</nav>
<?php
}
?>
