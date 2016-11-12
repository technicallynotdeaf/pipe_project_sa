
<div id="container"> 

<h2> Summaries: </h2> 

<?php

  # this is where I tell it to make links to the html docs
  # in the summaries page. 

$dir = "./summaries";
$dh  = opendir($dir);
while (false !== ($filename = readdir($dh))) {
    $files[] = $filename;
}

sort($files);

echo "<a href=\"summary.php?date=2016-11-01\"> 2016-11-01 </a>";

?>

</div>
