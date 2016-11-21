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

$reversed_list = array_reverse( $files );


foreach ($reversed_list as $filename) {

          $linkaddr = "summaries/{$filename}";

          // manually ignore . and .. ; better to use File.file? but the 
          // logic block kept throwing errors somewhere. TODO: fix this.
          if ($filename != "." && $filename != "..") {
               echo "<br> <a href=\"{$linkaddr}\">";
               echo $filename;
               echo "</a>";
          }
     }
?>
        <hr>

<?php include '../footer.php' ?>
