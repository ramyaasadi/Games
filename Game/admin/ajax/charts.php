<?php
#init
require '../../bootstrap.php';

if (isset($_REQUEST['chartid']) && isset($_REQUEST['status']) && $_REQUEST['chartid'] != '' && $_REQUEST['status'] != ''){
	if($_REQUEST['status'] == 'edit'){
		$db->Execute("UPDATE `charts` SET `aliastitle`= '".$_REQUEST['aliastitle']."' WHERE id=".$_REQUEST['chartid']);
		echo "<pre>";
		print_r($db);
		echo '1';
	}else{
		$db->Execute("UPDATE `charts` SET `status`=".$_REQUEST['status']." WHERE id=".$_REQUEST['chartid']);
		echo '1';
	}
}else{
		echo "0";
}?>