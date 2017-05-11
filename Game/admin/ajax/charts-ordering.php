<?php
#init
require '../../bootstrap.php';
if (isset($_REQUEST['cid']) && count($_REQUEST['cid']) > 0){
	$i=1;
	foreach($_REQUEST['cid'] as $catid){
	
		$db->Execute("UPDATE `charts` SET `ordering`=".$i." WHERE id=".$catid);
		$i++;
	}	
		echo '1';
}else{
		echo "0";
}?>