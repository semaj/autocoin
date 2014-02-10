<?php
error_reporting(-1);
$action = $_GET['action'];
chdir('/home/jamesfordummies/');
$email = $_GET['email'];
$fileName = "addresses.txt";
if ($action === "unsubscribe") {
  $contents = file_get_contents($fileName);
  $contents = str_replace($email . "\n", '', $contents);
  if (file_put_contents($fileName, $contents)) {
    $result = "Success!";
  } else {
    $result = "Failure!";
  }
} else if ($action === "subscribe") {
  $current = file_get_contents($fileName);
  $new = $current . $email . "\n";
  if (file_put_contents($fileName, $new)) {
    $result = "Success!";
  } else {
    $result = "Failure!";
  }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title></title>
  <link rel="stylesheet" href="bootstrap.css"  type="text/css"/>
  <link rel="stylesheet" href="cover.css"  type="text/css"/>
</head>
<body>
<div class="site-wrapper">

      <div class="site-wrapper-inner">

        <div class="cover-container">

          <div class="inner cover">
          <h1 class="cover-heading"><?php echo $result; ?></h1>
          </div>

          <div class="mastfoot">
            <div class="inner">
              <p><a href="https://twitter.com/jamesfordummes">@jamesfordummies</a></p>
            </div>
          </div>

        </div>

      </div>

    </div>
 </div> 
</body>
  <script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
  <script src="bootstrap.min.js"></script>
</html>
