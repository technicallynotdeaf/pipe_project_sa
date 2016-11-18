<?php include '../header.php'; ?>

<!-- Page Content -->
<div class="container">
<!-- Title -->
<div class="row"> <div class="col-lg-12">
	<h2>Available Summaries</h2>
    </div> </div>
<!-- /.row -->


<?php 
# this is where I tell it to make links to the html docs
# in the summaries page. 

$dir = "./summaries";
$dh  = opendir($dir);
while (false !== ($filename = readdir($dh))) {
 $files[] = $filename;
}

sort($files);



foreach ($files as $filename) {

          $linkaddr = "summary.php?date={$filename}";

          if ($filename != "." && $filename != "..") {
               echo "<br> <a href=\"{$linkaddr}\">";
               echo $filename;
               echo "</a>";
          }
     }
?>
        <hr>

<?php include '../footer.php' ?>
