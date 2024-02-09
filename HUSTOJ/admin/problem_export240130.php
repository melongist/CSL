<html>
<head>
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache">
  <meta http-equiv="Content-Language" content="zh-cn">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <title>Problem Export</title>
</head>
<hr>

<?php 
  require_once("../include/db_info.inc.php");
  require_once("admin-header.php");

  if (!(isset($_SESSION[$OJ_NAME.'_'.'administrator']) || isset($_SESSION[$OJ_NAME.'_'.'contest_creator']) || isset($_SESSION[$OJ_NAME.'_'.'problem_editor']))) {
    echo "<a href='../loginpage.php'>Please Login First!</a>";
    exit(1);
  }

  echo "<center><h3>".$MSG_PROBLEM."-".$MSG_EXPORT."</h3></center>";

?>

<body leftmargin="30" >
  <div class="container">
    <br><br>
    <!-- * by CSL-->
    - CSL HUSTOJ 문제 XML 다운로드<br><br>
    <form class="form-inline" action="problem_export_xml.php" method=post>
      <div class="form-group">
        <!-- * by CSL-->
        <label>1) 연속번호 다운로드:</label>
        <input class="form-control" name="start" type="text" placeholder="1001">
      </div>
      <div class="form-group">
        <label> ~ </label>
        <input class="form-control" name="end" type="text" placeholder="1009">
      </div>
      <br><br>
      <div class="form-group">
        <!-- * by CSL-->
        <label>2) 개별번호 다운로드:</label>
        <input class="form-control" name="in" type="text" placeholder="1001,1003,1005, ... ">
      </div>
      <br><br>

      <center>
      <div class='form-group'>
        <input type="hidden" name="do" value="do">
        <!-- <input type="submit" name="submit" value="Export to XML Script"> -->

        <!-- * by CSL -->
        <button class='btn btn-default btn-sm' type=submit>다운로드</button>
      </div>
      </center>

      <?php require_once("../include/set_post_key.php");?>
    </form>

    <br><br>
    <!--
    * from-to will working if empty IN <br>
    * if using IN,from-to will not working.<br>
    * IN can go with "," seperated problem_ids like [1000,1020]
    -->
    <!-- * by CSL -->
    - 연속번호 또는 개별번호 중 한가지 방법으로만 다운로드하세요.<br><br>

    - CSL HUSTOJ의 문제 XML은 상위 버전의 CSL HUSTOJ에도 업로드가 됩니다.<br>
    - 직접 만들거나 더 좋게 개선한 문제들을 다른 정보선생님들에게 나눔할 수 있습니다.<br>
  </div>

</body>
</html>
