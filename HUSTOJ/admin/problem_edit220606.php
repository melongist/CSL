<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <title>Edit Problem</title>
</head>
<hr>

<?php
require_once("../include/db_info.inc.php");
require_once("admin-header.php");
require_once("../include/my_func.inc.php");

if (!(isset($_SESSION[$OJ_NAME.'_'.'administrator']) || isset($_SESSION[$OJ_NAME.'_'.'problem_editor']))) {
  echo "<a href='../loginpage.php'>Please Login First!</a>";
  exit(1);
}

echo "<center><h3>"."Edit-".$MSG_PROBLEM."</h3></center>";
include_once("kindeditor.php") ;
?>

<body leftmargin="30" >
  <div class="container">
    <?php
    if (isset($_GET['id'])) {
      ;//require_once("../include/check_get_key.php");
    ?>

    <form method=POST action=problem_edit.php>
      <?php
      $sql = "SELECT * FROM `problem` WHERE `problem_id`=?";
      $result = pdo_query($sql,intval($_GET['id']));
      $row = $result[0];
      ?>

      <input type=hidden name=problem_id value='<?php echo $row['problem_id']?>'>
      <p align=left>
        <center>
          <h3>
          <?php echo $row['problem_id']?>: <input class="input input-xxlarge" style='width:90%' type=text name=title value='<?php echo htmlentities($row['title'],ENT_QUOTES,"UTF-8")?>'>
          </h3>
        </center>
      </p>
        <p align=left>
          <?php echo $MSG_Time_Limit?><br>
          <input class="input input-mini" type=number min="0.001" max="300" step="0.001" name=time_limit size=20 value="<?php echo $row['time_limit']?>"> sec<br><br>
          <?php echo $MSG_Memory_Limit?><br>
          <input class="input input-mini" type=number min="1" max="1024" step="1" name=memory_limit size=20 value="<?php echo $row['memory_limit']?>"> MiB<br><br>
        </p>
      <p align=left>
        <?php echo "<h4>".$MSG_Description."</h4>"?>
        <textarea class="kindeditor" rows=13 name=description cols=80><?php echo htmlentities($row['description'],ENT_QUOTES,"UTF-8")?></textarea><br>
      </p>

      <p align=left>
        <?php echo "<h4>".$MSG_Input."</h4>"?>
        <textarea class="kindeditor" rows=13 name=input cols=80><?php echo htmlentities($row['input'],ENT_QUOTES,"UTF-8")?></textarea><br>
      </p>

      <p align=left>
        <?php echo "<h4>".$MSG_Output."</h4>"?>
        <textarea  class="kindeditor" rows=13 name=output cols=80><?php echo htmlentities($row['output'],ENT_QUOTES,"UTF-8")?></textarea><br>
      </p>

      <p align=left>
        <?php echo "<h4>".$MSG_Sample_Input."</h4>"?>
        <textarea  class="input input-large" style="width:100%;" rows=13 name=sample_input><?php echo htmlentities($row['sample_input'],ENT_QUOTES,"UTF-8")?></textarea><br><br>
      </p>

      <p align=left>
        <?php echo "<h4>".$MSG_Sample_Output."</h4>"?>
        <textarea  class="input input-large" style="width:100%;" rows=13 name=sample_output><?php echo htmlentities($row['sample_output'],ENT_QUOTES,"UTF-8")?></textarea><br><br>
      </p>

      <p align=left>
        <?php echo "<h4>".$MSG_HINT."</h4>"?>
        <textarea class="kindeditor" rows=13 name=hint cols=80><?php echo htmlentities($row['hint'],ENT_QUOTES,"UTF-8")?></textarea><br>
      </p>

      <p>
        <?php echo "<h4>".$MSG_SPJ."</h4>"?>
        <?php echo "(".$MSG_HELP_SPJ.")"?><br>
        <?php echo "No "?><input type=radio name=spj value='0' <?php echo $row['spj']=="0"?"checked":""?>>
        <?php echo "/ Yes "?><input type=radio name=spj value='1' <?php echo $row['spj']=="1"?"checked":""?>><br><br>
      </p>

      <p align=left>
        <?php echo "<h4>".$MSG_SOURCE."</h4>"?>
        <textarea name=source style="width:100%;" rows=1><?php echo htmlentities($row['source'],ENT_QUOTES,"UTF-8")?></textarea><br><br>
      </p>


      <!-- + by CSL -->
      <br><br>
      <p align=left>
        <?php echo "<h5>"."앞에 붙일 코드"."</h5>"?>
        <textarea name=front style="width:100%;" <?php if ($row['front']=="") echo "placeholder='제출한 코드의 앞에 붙일 코드'";?> rows=1><?php echo htmlentities($row['front'],ENT_QUOTES,"UTF-8")?></textarea><br>
      </p>

      <p align=left>
        <?php echo "<h5>"."뒤에 붙일 코드"."</h5>"?>
        <textarea name=rear style="width:100%;" <?php if ($row['rear']=="") echo "placeholder='제출한 코드의 뒤에 붙일 코드'";?> rows=1><?php echo htmlentities($row['rear'],ENT_QUOTES,"UTF-8")?></textarea><br>
      </p>

      <p align=left>
        <?php echo "<h5>"."사용금지 코드"."</h5>"?>
        <textarea name=bann style="width:100%;" <?php if ($row['bann']=="") echo "placeholder='사용을 제한할 단어(/로 구분하여 입력)'";?> rows=1><?php echo htmlentities($row['bann'],ENT_QUOTES,"UTF-8")?></textarea><br>
      </p>

      <p align=left>
        <?php echo "<h5>"."만든사람"."</h5>"?>
        <textarea name=credits style="width:100%;" <?php if ($row['credits']=="") echo "placeholder='한영일, 이일영(역할), ... (2000)'";?> rows=1><?php echo htmlentities($row['credits'],ENT_QUOTES,"UTF-8")?></textarea><br><br>
      </p>
      <!-- + by CSL -->      


      <div align=center>
        <?php require_once("../include/set_post_key.php");?>
        <input type=submit value='<?php echo $MSG_SAVE?>' name=submit>
      </div>
    </form>

    <?php
    }
    else {
      require_once("../include/check_post_key.php");
      $id = intval($_POST['problem_id']);

      if (!(isset($_SESSION[$OJ_NAME.'_'."p$id"]) || isset($_SESSION[$OJ_NAME.'_'.'administrator']) || isset($_SESSION[$OJ_NAME.'_'.'problem_editor']) )) exit();  

      $title = $_POST['title'];
      $title = str_replace(",", "&#44;", $title);

      $time_limit = $_POST['time_limit'];

      $memory_limit = $_POST['memory_limit'];

      $description = $_POST['description'];
      $description = str_replace("<p>", "", $description); 
      $description = str_replace("</p>", "<br />", $description);
      $description = str_replace(",", "&#44;", $description);

      $input = $_POST['input'];
      $input = str_replace("<p>", "", $input); 
      $input = str_replace("</p>", "<br />", $input);
      $input = str_replace(",", "&#44;", $input);

      $output = $_POST['output'];
      $output = str_replace("<p>", "", $output); 
      $output = str_replace("</p>", "<br />", $output); 
      $output = str_replace(",", "&#44;", $output);

      $sample_input = $_POST['sample_input'];
      $sample_output = $_POST['sample_output'];
      if ($sample_input=="") $sample_input="\n";
      if ($sample_output=="") $sample_output="\n";

      $hint = $_POST['hint'];
      $hint = str_replace("<p>", "", $hint); 
      $hint = str_replace("</p>", "<br />", $hint);
      $hint = str_replace(",", "&#44;", $hint);

      $source = $_POST['source'];
      $spj = $_POST['spj'];


      //+ by CSL
      $front = $_POST['front'];
      $rear = $_POST['rear'];
      $bann = $_POST['bann'];
      $credits = $_POST['credits'];


      if (false) {
        $title = stripslashes($title);
        $time_limit = stripslashes($time_limit);
        $memory_limit = stripslashes($memory_limit);
        $description = stripslashes($description);
        $input = stripslashes($input);
        $output = stripslashes($output);
        $sample_input = stripslashes($sample_input);
        $sample_output = stripslashes($sample_output);
        //$test_input = stripslashes($test_input);
        //$test_output = stripslashes($test_output);
        $hint = stripslashes($hint);
        $source = stripslashes($source); 
        $spj = stripslashes($spj);

        //+ by CSL ?????
        $front = stripslashes($front);
        $rear = stripslashes($rear);
        $bann = stripslashes($bann);
        $credits = stripslashes($credits);
      }

      $title = ($title);
      $description = RemoveXSS($description);
      $input = RemoveXSS($input);
      $output = RemoveXSS($output);
      $hint = RemoveXSS($hint);
      $basedir = $OJ_DATA."/$id";

      echo "Problem Updated!<br>";

      if ($sample_input && file_exists($basedir."/sample.in")) {
        //mkdir($basedir);
        $fp = fopen($basedir."/sample.in","w");
        fputs($fp,preg_replace("(\r\n)","\n",$sample_input));
        fclose($fp);

        $fp = fopen($basedir."/sample.out","w");
        fputs($fp,preg_replace("(\r\n)","\n",$sample_output));
        fclose($fp);
      }

      $spj = intval($spj);


      //* by CSL
      $sql = "UPDATE `problem` SET `title`=?,`time_limit`=?,`memory_limit`=?, `description`=?,`input`=?,`output`=?,`sample_input`=?,`sample_output`=?,`hint`=?,`source`=?,`spj`=?,`front`=?,`rear`=?,`bann`=?,`credits`=?,`in_date`=NOW() WHERE `problem_id`=?";

      //* by CSL
      @pdo_query($sql,$title,$time_limit,$memory_limit,$description,$input,$output,$sample_input,$sample_output,$hint,$source,$spj,$front,$rear,$bann,$credits,$id);


      echo "Edit OK!<br>";
      echo "<a href='../problem.php?id=$id'>See The Problem!</a>";
    }
    ?>
  </div>
</body>
</html>
