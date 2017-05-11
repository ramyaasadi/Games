<?php
/*
	 *** Custom Skins Module
	 * this module is for visual customization of the site
	 * created: 02.29.2012
	 * updated: 04.24.2012
	 * version: 1.2
*/
	require_once __DIR__.'/../../lib/group.class.php';
	$tbl_charts  = 'charts';
	if (isset($_POST['term']['save'])) {
		// saving the data
		unset($_POST['term']['save']);
		foreach ($_POST['term'] as $term=>$data) {
			$db->Execute("UPDATE `$tbl_terms` SET `value` = ".$db->qstr($data['value']).", `order` = ".$db->qstr($data['order'])." WHERE `term` = ".$db->qstr($term)." AND `group_id` = ".$id);
		}
		$message = array(
			'type'=>'success',
			'title'=>'All the data fields are saved successfully!',
			'body'=>'You can see the change in the frond end when you re-open the group page.'
		);
	}
	// getting the default and group terms
	$charts = $db->GetAll("SELECT * FROM `$tbl_charts` ORDER BY `ordering` asc");
	$smarty->assign('charts', $charts);
	$template_to = 'graphs-charts.tpl';
?>