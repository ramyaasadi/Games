<?php
require '../bootstrap.php';

$smarty->template_dir =  __DIR__.'/templates/';
if(!session_id()) session_start();

#claims class
require_once('lib/claims.php');
$claims = new Claims();

#claim pdf files class
require_once('lib/claim_pdf_files.php');
$claim_pdf_files = new ClaimPdfFiles();

#account helper class
require_once 'account.php';
$account = new Account();


function php_check_syntax($file,&$error){
	  if(@strstr($_SERVER['HTTP_HOST'], 'claimcompass.com')) $php_path='/usr/local/nginx/php/bin/php'; else $php_path='php';
	  exec("$php_path -l $file",$error,$code);
	  if($code==0) return true;
	  return false;
}//php_check_syntax

#require '../lib/smarty3/Smarty.class.php';
#$smarty = new Smarty;

$lang['id']=1;

$smarty->assign('top', $m = $db->GetAll("SELECT url, name, identifier, `pos`, title, `add` FROM pages WHERE parent_id = 0 AND (`pos`='top') ORDER BY `position`"));
$smarty->assign('menu', $m = $db->GetAll("SELECT url, name, identifier, `pos`, title, `add` FROM pages WHERE parent_id = 0 AND(`pos`='header') ORDER BY `position`"));
$smarty->assign('footer', $f = $db->GetAll("SELECT url, name, identifier, `pos`, title, `add` FROM pages WHERE parent_id = 0 AND (`pos`='header' OR `pos`='footer') ORDER BY `pos`='header' DESC, `position`"));
$smarty->assign('domain_name', $_SERVER['HTTP_HOST']);

global $db, $smarty;


	$page_1 = isset($_GET['page']) && $_GET['page'] > 0 ? $_GET['page'] : 0;
	$id = (isset($_GET['id']) && $_GET['id'] > 0 ) ? filter_var($_GET['id'],FILTER_SANITIZE_NUMBER_INT) : 0;
	$pool_id = 1;
	if(isset($_SESSION['admin'])) $admin = $_SESSION['admin']; else $admin=null;

	if (
		(isset($_GET['cat']) && $_GET['cat']!='home' && !isset($admin)) ||
		(isset($admin) && $admin['type']!='manager' && $admin['type']!='administrator')
	) {
		$_GET['cat'] = 'home';
		$template_to = 'home.tpl';
		$message = array(
		'type'=>'error',
		'title'=>'Sorry, but you don\'t have enough right to see or edit this page!',
		'body'=>'Please use the administrator with full access!'
		);
	}
	if ((isset($admin) && $admin['type']=='sales') && ($_GET['action']!='logout' && $_GET['action']!='login')) {
		$_GET['cat'] = 'quotes';
		unset($message);
	}

	if(isset($_GET['cat'])) $cat=$_GET['cat']; else $cat=null;
	switch ($cat) {
		  default: case 'home': {
				if (isset($_GET['action']) && $_GET['action']=='logout') {
					unset($admin);
					unset($_SESSION['admin']);
				}
				if (isset($_POST['login']['now'])) {
					// имаме заявка за административен вход
					$form = $_POST['login'];
					// проверяваме дали такъв потребител съществува
					$check = $db->GetRow("SELECT * FROM administrators WHERE `username`=".$db->qstr($form['username'])." AND `password`=SHA1(MD5(".$db->qstr($form['password'])."))");

					//echo "SELECT * FROM administrators WHERE `username`=".$db->qstr($form['username'])." AND `password`=SHA1(MD5(".$db->qstr($form['password'])."))";
					//print_r($check); exit;
					if (isset($check['id']) && $check['id']>0) {
						$db->Execute("UPDATE administrators SET `last_active` = NOW() WHERE id =".$check['id']);
						// имаме администратор
						$message = array(
							  'type'=>'success',
							  'title'=>'Login successfull!',
							  'body'=>'Welcome back!'
						);
						$admin = $_SESSION['admin'] = $check;
					} else {
						$message = array(
							  'type'=>'error',
							  'title'=>'Wrong username or password!',
							  'body'=>'Please try again, with Caps Lock off!'
						);
					}
				}
				$template_to = 'home.tpl';
				break;
		  }
		  case 'graphs': { include 'modules/graphs.php'; break;}
		  case 'skins': { include 'modules/skins.php'; break;}
		  case 'file_browser': {
			$template_to = "file_browser.tpl";
			break;
		  }
		  case 'docs': {
			require_once('modules/docs.php');
			break;
		  }
		  case 'stats': {
			require_once('modules/stats.php');
			break;
		  }
		  case 'members': {
			  require_once('modules/members.php');
			  break;
		  }
		  case 'ajax': {
			  require_once('modules/ajax.php');
			  break;
		  }
		  case 'server': {

		  	$action = isset($_GET['action']) ? $_GET['action'] : false;

		  	switch ($action) {
		  		case 'force_dist_queue':{

		  			break;
		  		}

		  		case 'force_ftp_upload':{

		  			break;
		  		}

		  		case 'flush_memcached':{
		  			$memcache->flush();
		  			break;
		  		}
		  	}//swi

		  	$smarty->assign('action', $action);
		  	$template_to = "server.tpl";
		  	break;
		  }
		  case 'texts': {
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
			  	if (isset($_GET['ident']) && isset($_GET['group_id']) && isset($_GET['owner'])) {
			  		### we have atempt to load/create group specific text panel
			  		# checking if there is a texts item like that
			  		$check = $db->GetOne("
			  			SELECT id FROM texts
			  			WHERE
			  				(identifier = ".$db->qstr($_GET['ident'])." OR identifier = ".$db->qstr($_GET['ident'].'1').")
			  				AND group_id = ".$db->qstr($_GET['group_id'])
					);
					if ($check > 0) $id = $check;
					else {
						$db->debug=false;
						# there is no texts item like that
						# trying to load the default value
						if ($_GET['ident'] == 'hints_' || $_GET['ident'] == 'blog_' || $_GET['ident'] == 'news_') {
							# those has multiple rows, loading the latest one
							$sample = $db->GetRow("SELECT * FROM texts WHERE identifier LIKE ".$db->qstr($_GET['ident'].'%')." AND `owner` = ".$db->qstr($_GET['owner'])." AND group_id = 0 ORDER BY `id` DESC");
							$_GET['ident'].='1';
						} else $sample = $db->GetRow("SELECT * FROM texts WHERE identifier = ".$db->qstr($_GET['ident'])." AND `owner` = ".$db->qstr($_GET['owner'])." AND group_id = 0 ORDER BY `id` DESC");
						# check is there a valid sample
						if (isset($sample['id'])) {
							# we do have a sample, must create a copy now
							$db->Execute("
								INSERT INTO texts SET
									`lang_id` = ".$sample['lang_id'].",
									`identifier` = ".$db->qstr($_GET['ident']).",
									`group_id` = ".$db->qstr($_GET['group_id']).",
									`title` = ".$db->qstr($sample['title']).",
									`subtitle` = ".$db->qstr($sample['subtitle']).",
									`name` = ".$db->qstr($sample['name']).",
									`body` = ".$db->qstr($sample['body']).",
									`owner` = ".$db->qstr($_GET['owner']).",
									`position` = ".$db->qstr($sample['position']).",
									`date` = NOW()
							");
							$id = $db->Insert_ID();
						} else {
							# we don't have a sample, creating brand new one
							$db->Execute("
								INSERT INTO texts SET
									`lang_id` = ".$lang['id'].",
									`identifier` = ".$db->qstr($_GET['ident']).",
									`group_id` = ".$db->qstr($_GET['group_id']).",
									`title` = ".$db->qstr($_GET['ident']).",
									`name` = ".$db->qstr($_GET['ident']).",
									`body` = ".$db->qstr('Please fill some text here...').",
									`owner` = ".$db->qstr($_GET['owner']).",
									`position` = 99,
									`date` = NOW()
							");
							$id = $db->Insert_ID();
						}
						$db->debug=false;
					}
			  	}

				if (!$id>0) $action = 'list';
				$filter = isset($_GET['filter']) ? $_GET['filter'] : null;
				if (isset($filter)) {
					switch ($filter) {
						default: $pagetitle='Text Panels';break;
						case 'aboutus': $pagetitle='About Us';break;
						case 'services': $pagetitle='Services';break;
					}
					$smarty->assign('pagetitle', $pagetitle);
				}
				switch ($action) {
					  default: case 'list': {
							// Texts: List
							$smarty->assign('texts', $db->GetAll("
								  SELECT * FROM texts
								  WHERE
									  lang_id=".$db->qstr($lang['id'])."
									  ".($filter ? "AND `owner` = ".$db->qstr($filter) : "")."
								  ORDER BY `position`, `date` DESC"));
							$template_to = 'texts_list.tpl';
							break;
					  }
					  case 'add': {
							$smarty->assign('identifier', $filter.'_'.$db->GetOne("SELECT id+1 FROM texts ORDER BY `id` DESC"));
							$smarty->assign('owner', $filter);
							$template_to = 'texts_add.tpl';
							if (isset($_POST['text']['save'])) {
								  $smarty->assign('n', $_POST['text']);
								  if (mb_strlen($_POST['text']['title'],"UTF-8")>0 && mb_strlen($_POST['text']['identifier'],"UTF-8")>0) {
										if (isset($_FILES['text']['name']['image']) && mb_strlen($_FILES['text']['name']['image'],"UTF-8")>0 && move_uploaded_file($_FILES['text']['tmp_name']['image'], 'photos/texts/'.$_FILES['text']['name']['image'])) {
											  $image = $_FILES['text']['name']['image'];
										} else $image = null;
										$db->Execute("INSERT INTO `texts` SET
											  `title` = ".$db->qstr($_POST['text']['title']).",
											  `subtitle` = ".$db->qstr($_POST['text']['subtitle']).",
											  `name` = ".$db->qstr($_POST['text']['name']).",
											  `position` = ".$db->qstr($_POST['text']['position']).",
											  `identifier` = ".$db->qstr($_POST['text']['identifier']).",
											  `owner` = ".$db->qstr($_POST['text']['owner']).",
											  ".($image ? "`image`=".$db->qstr($image)."," : "")."
											  `image_width` = ".$db->qstr($_POST['text']['image_width']).",
											  `image_position` = ".$db->qstr($_POST['text']['image_position']).",
											  `image_border` = ".$db->qstr($_POST['text']['image_border']).",
											  `body` = ".$db->qstr($_POST['text']['body']).",
											  `date` = ".(empty($_POST['text']['date']) ? 'NOW()' : $db->qstr($_POST['text']['date'])).",
											  `lang_id` = ".$lang['id']."
										");
										$message = array(
											  'type'=>'success',
											  'title'=>'Text Panel was saved successfully!',
											  'body'=>'We are going back to the text panels list.',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=texts&filter='.$filter
										);
										$template_to = '../global/message.tpl';
								  } else {
										$message = array(
											  'type'=>'error',
											  'title'=>'Text Panel cannot be added!',
											  'body'=>'Title and identifier are required fields, please fill them and try again!'
										);
								  }
							}
							break;
					  }
					  case 'edit': {
							if (isset($_POST['text']['save'])) {
								  // първа снимка
								  if (isset($_FILES['text']['name']['image']) && mb_strlen($_FILES['text']['name']['image'],"UTF-8")>0 && move_uploaded_file($_FILES['text']['tmp_name']['image'], 'photos/texts/'.$_FILES['text']['name']['image'])) {
										$image = $_FILES['text']['name']['image'];
								  } elseif (isset($_POST['text']['remove_image']) && $_POST['text']['remove_image']>0) {
									  $image = null;
									  $remove_image = 1;
								  } else $remove_image = null;
								  // втора снимка
								  if (isset($_FILES['text']['name']['image2']) && mb_strlen($_FILES['text']['name']['image2'],"UTF-8")>0 && move_uploaded_file($_FILES['text']['tmp_name']['image2'], 'photos/texts/'.$_FILES['text']['name']['image2'])) {
										$image2 = $_FILES['text']['name']['image2'];
								  } elseif (isset($_POST['text']['remove_image2']) && $_POST['text']['remove_image2']>0) {
									  $image2 = null;
									  $remove_image2 = 1;
								  } else $remove_image2 = null;
								  // трета снимка
								  if (isset($_FILES['text']['name']['image3']) && mb_strlen($_FILES['text']['name']['image3'],"UTF-8")>0 && move_uploaded_file($_FILES['text']['tmp_name']['image3'], 'photos/texts/'.$_FILES['text']['name']['image3'])) {
										$image3 = $_FILES['text']['name']['image3'];
								  } elseif (isset($_POST['text']['remove_image3']) && $_POST['text']['remove_image3']>0) {
									  $image3 = null;
									  $remove_image3 = 1;
								  } else $remove_image3 = null;

								  if(!isset($image))$image=null;
								  if(!isset($image2))$image2=null;
								  if(!isset($image3))$image3=null;

								  if(!isset($remove_image))$remove_image=null;
								  if(!isset($remove_image2))$remove_image2=null;
								  if(!isset($remove_image3))$remove_image3=null;

								  // заявка
								  $db->Execute("UPDATE `texts` SET
													`title` = ".$db->qstr($_POST['text']['title']).",
													`subtitle` = ".$db->qstr($_POST['text']['subtitle']).",
													`name` = ".$db->qstr($_POST['text']['name']).",
													`position` = ".$db->qstr($_POST['text']['position']).",

													".($remove_image ? "`image`=NULL," : "")."
													".($image ? "`image`=".$db->qstr($image)."," : "")."

													".($remove_image2 ? "`image2`=NULL," : "")."
													".($image2 ? "`image2`=".$db->qstr($image2)."," : "")."

													".($remove_image3 ? "`image3`=NULL," : "")."
													".($image3 ? "`image3`=".$db->qstr($image3)."," : "")."

													`image_width` = ".$db->qstr($_POST['text']['image_width']).",
													`image_position` = ".$db->qstr($_POST['text']['image_position']).",
													`image_border` = ".$db->qstr($_POST['text']['image_border']).",
													`body` = ".$db->qstr($_POST['text']['body']).",
													".(isset($_POST['text']['color']) ? "`color` = ".$db->qstr($_POST['text']['color'])."," : "")."
													`date` = ".(empty($_POST['text']['date']) ? 'NOW()' : $db->qstr($_POST['text']['date']))."
											   WHERE `id` = ".$db->qstr($id));
								  $message = array(
										'type'=>'success',
										'title'=>'Text Panel was saved successfully!',
										'body'=>'Please check all your fields!'
								  );
							}
							if (isset($_GET['group_id']) && $_GET['group_id'] > 0) $smarty->assign('group', $db->GetRow("SELECT * FROM `groups` WHERE id=".$_GET['group_id']));
							$smarty->assign('n', $n = $db->GetRow("SELECT * FROM texts WHERE id=".$db->qstr($id)));
							$template_to = 'texts_form.tpl';
							break;
					  }
					  case 'erase': {
							$db->Execute("DELETE FROM `texts` WHERE `id`=".$db->qstr($id));
							$message = array(
								  'type'=>'success',
								  'title'=>'The item was erased successfully!',
								  'body'=>'We are going back to the text panels list.',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=texts&filter='.$filter
							);
							$template_to = '../global/message.tpl';
							break;
					  }
				}
				break;
		  }

	 case 'forms': {

				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				#if (!$id>0) $action = 'list';
				$filter = isset($_GET['filter']) ? $_GET['filter'] : null;
				if (isset($filter)) {
					switch ($filter) {
						default: $pagetitle='UI Forms';break;
						case 'aboutus': $pagetitle='About Us';break;
						case 'services': $pagetitle='Services';break;
					}
					$smarty->assign('pagetitle', $pagetitle);
				}

				#echo $action; exit;
				switch ($action) {
					  default: case 'list': {
							// Texts: List
							$smarty->assign('forms', $db->GetAll("SELECT * FROM `forms` ORDER BY `sum_usa_state_name` ASC"));
							$template_to = 'forms_list.tpl';

							break;
					  }
					  case 'add': {

					  	//print_r($_FILES); 	exit;
							$template_to = 'forms_add.tpl';
							if (isset($_POST['form']['save'])) {
								  $smarty->assign('n', $_POST['form']);

								  	if (is_uploaded_file($_FILES['rep_xml_file']['tmp_name'])){
											  $fp = fopen($_FILES['rep_xml_file']['tmp_name'], 'r');
											  $xml_file = addslashes(fread($fp, filesize($_FILES['rep_xml_file']['tmp_name'])));
											  fclose($fp);
										} else $xml_file = null;

								  		if (is_uploaded_file($_FILES['rep_jrxml_file']['tmp_name'])){
											  $fp = fopen($_FILES['rep_jrxml_file']['tmp_name'], 'r');
											  $jrxml_file = addslashes(fread($fp, filesize($_FILES['rep_jrxml_file']['tmp_name'])));
											  fclose($fp);

										} else $jrxml_file = null;

										//epdf - pdftk
										if (is_uploaded_file($_FILES['rep_epdf_file']['tmp_name'])){

										    #store file to fs
										    $froi_dir = FROI_ROOT_FS.$id;
										    if(!file_exists($froi_dir)) mkdir($froi_dir,0755,true);
										    $dest_file = $froi_dir.'/froi.pdf';

										    if(move_uploaded_file($_FILES['rep_epdf_file']['tmp_name'], $dest_file)){

										        $epdf_file = TRUE;

										        //get data-ready epdf_fields

										        //fdf lib
										        include_once("lib/fdf.php");

										        //get fields list
										        $epdf_fields = FDF::get_pdf_field_names($dest_file);

										        if(!empty($epdf_fields)){

										            //implode result
										            $epdf_fields = implode(',', $epdf_fields);

										            //set update flag
										            $update_epdf_fields = TRUE;
										        }//if fields list
										    }//if move_uploaded_file

										} else $epdf_file = null;

										$db->Execute("INSERT INTO `forms` SET
											  `sum_usa_state_name` = ".$db->qstr($_POST['form']['sum_usa_state_name']).",
											  `sum_state_abbrev` = ".$db->qstr($_POST['form']['sum_state_abbrev']).",
											  `sum_each_state_different` = ".$db->qstr($_POST['form']['sum_each_state_different']).",
											  `sum_wc_department_name` = ".$db->qstr($_POST['form']['sum_wc_department_name']).",
											  `sum_wc_details` = ".$db->qstr($_POST['form']['sum_wc_details']).",
											  `sum_news_and_events` = ".$db->qstr($_POST['form']['sum_news_and_events']).",
											  `stat_year_of_stat` = ".$db->qstr($_POST['form']['stat_year_of_stat']).",
											  `stat_num_average_anual` = ".$db->qstr($_POST['form']['stat_num_average_anual']).",
											  `stat_num_recordable_work_comp` = ".$db->qstr($_POST['form']['stat_num_recordable_work_comp']).",
											  `stat_num_cases_with_lost` = ".$db->qstr($_POST['form']['stat_num_cases_with_lost']).",
											  `stat_perc_cases_with_lost` = ".$db->qstr($_POST['form']['stat_perc_cases_with_lost']).",
											  `stat_perc_cases_per_num_of_employees` = ".$db->qstr($_POST['form']['stat_perc_cases_per_num_of_employees']).",
											  `stat_rev_date` = ".$db->qstr($_POST['form']['stat_rev_date']).",
											  `stat_memo` = ".$db->qstr($_POST['form']['stat_memo']).",
											  `rep_form_name` = ".$db->qstr($_POST['form']['rep_form_name']).",
											  `rep_form_id` = ".$db->qstr($_POST['form']['rep_form_id']).",
											  `rep_preferred_method` = ".$db->qstr($_POST['form']['rep_preferred_method']).",
											  `rep_type` = ".$db->qstr($_POST['form']['rep_type'])
											   .($xml_file?',`rep_xml_file`=\''.$xml_file.'\'':'')
										       .($epdf_file?'`rep_epdf_file`=1,':'')
											   .($jrxml_file?',`rep_jrxml_file`=\''.$jrxml_file.'\'':''))
											   .(isset($update_epdf_fields)?',`epdf_fields`=\''.$epdf_fields.'\'':'')
											   .(isset($_POST['form']['show_on_frontend'])?', show_on_frontend=1':', show_on_frontend=0');


										#update pdf and screenshot
										if (is_uploaded_file($_FILES['rep_jrxml_file']['tmp_name']) && $db->Insert_ID()>0) admin_froi2pdf($db->Insert_ID());

										$message = array(
											  'type'=>'success',
											  'title'=>'UI Form was saved successfully!',
											  'body'=>'We are going back to the UI Forms.',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=forms'
										);
										$template_to = '../global/message.tpl';
								  }
								  //INSERT INTO PICTABLE (MYID, PIC) VALUES (3, LOAD_FILE('/PHP/ME.JPG'));

							break;
					  }
					  case 'edit': {
							if (isset($_POST['form']['save'])) {

										if (is_uploaded_file($_FILES['rep_xml_file']['tmp_name'])){
											  $fp = fopen($_FILES['rep_xml_file']['tmp_name'], 'r');
											  $xml_file = addslashes(fread($fp, filesize($_FILES['rep_xml_file']['tmp_name'])));
											  fclose($fp);

											  #store file to fs
											  $xml_dir = FORMS_XML_ROOT_FS . $id;
											  if(!file_exists($xml_dir)) mkdir($xml_dir,0755,true);
											  move_uploaded_file($_FILES['rep_xml_file']['tmp_name'], $xml_dir.'/form.xml');

										} else $xml_file = null;

								  		if (is_uploaded_file($_FILES['rep_jrxml_file']['tmp_name'])){
											  $fp = fopen($_FILES['rep_jrxml_file']['tmp_name'], 'r');
											  $jrxml_file = addslashes(fread($fp, filesize($_FILES['rep_jrxml_file']['tmp_name'])));
											  fclose($fp);

											  #store file to fs
											  $jrxml_dir = FORMS_JRXML_ROOT_FS . $id;
											  if(!file_exists($jrxml_dir)) mkdir($jrxml_dir,0755,true);
											  move_uploaded_file($_FILES['rep_jrxml_file']['tmp_name'], $jrxml_dir.'/form.jrxml');

											  #create pdf file
											 // admin_froi2pdf($id);

										} else $jrxml_file = null;
										
										//epdf - pdftk
										if (is_uploaded_file($_FILES['rep_epdf_file']['tmp_name'])){
										
										    #store file to fs
										    $froi_dir = FROI_ROOT_FS.$id;
										    if(!file_exists($froi_dir)) mkdir($froi_dir,0755,true);
										    $dest_file = $froi_dir.'/froi.pdf';
										
										    if(move_uploaded_file($_FILES['rep_epdf_file']['tmp_name'], $dest_file)){
										
										        $epdf_file = TRUE;
										
										        //get data-ready epdf_fields
										
										        //fdf lib
										        include_once("lib/fdf.php");
										
										        //get fields list
										        $epdf_fields = FDF::get_pdf_field_names($dest_file);
										
										        if(!empty($epdf_fields)){
										
										            //implode result
										            $epdf_fields = implode(',', $epdf_fields);
										
										            //set update flag
										            $update_epdf_fields = TRUE;
										        }//if fields list
										    }//if move_uploaded_file
										
										} else $epdf_file = null;

										$upd_sql = "UPDATE `forms` SET
											  `sum_usa_state_name` = ".$db->qstr($_POST['form']['sum_usa_state_name']).",
											  `sum_state_abbrev` = ".$db->qstr($_POST['form']['sum_state_abbrev']).",
											  `sum_each_state_different` = ".$db->qstr($_POST['form']['sum_each_state_different']).",
											  `sum_wc_department_name` = ".$db->qstr($_POST['form']['sum_wc_department_name']).",
											  `sum_wc_details` = ".$db->qstr($_POST['form']['sum_wc_details']).",
											  `sum_news_and_events` = ".$db->qstr($_POST['form']['sum_news_and_events']).",
											  `stat_year_of_stat` = ".$db->qstr($_POST['form']['stat_year_of_stat']).",
											  `stat_num_average_anual` = ".$db->qstr($_POST['form']['stat_num_average_anual']).",
											  `stat_num_recordable_work_comp` = ".$db->qstr($_POST['form']['stat_num_recordable_work_comp']).",
											  `stat_num_cases_with_lost` = ".$db->qstr($_POST['form']['stat_num_cases_with_lost']).",
											  `stat_perc_cases_with_lost` = ".$db->qstr($_POST['form']['stat_perc_cases_with_lost']).",
											  `stat_perc_cases_per_num_of_employees` = ".$db->qstr($_POST['form']['stat_perc_cases_per_num_of_employees']).",
											  `stat_rev_date` = ".$db->qstr($_POST['form']['stat_rev_date']).",
											  `stat_memo` = ".$db->qstr($_POST['form']['stat_memo']).",
											  `rep_form_name` = ".$db->qstr($_POST['form']['rep_form_name']).",
											  `rep_form_id` = ".$db->qstr($_POST['form']['rep_form_id']).",
											  `rep_preferred_method` = ".$db->qstr($_POST['form']['rep_preferred_method']).",
											  `rep_type` = ".$db->qstr($_POST['form']['rep_type']).","
											   .($xml_file?'`rep_xml_file`=\''.$xml_file.'\',':'')
											   .($jrxml_file?'`rep_jrxml_file`=\''.$jrxml_file.'\',':'')."
											   `delivery_method` = ".$db->qstr($_POST['form']['delivery_method']).",
											   `delivery_wc_dep_fax_private` = ".$db->qstr($_POST['form']['delivery_wc_dep_fax_private']).",
											   `delivery_wc_dep_fax_public` = ".$db->qstr($_POST['form']['delivery_wc_dep_fax_public']).",
											   `delivery_wc_dep_email` = ".$db->qstr($_POST['form']['delivery_wc_dep_email']).",
											   `delivery_wc_dep_email_config` = ".$db->qstr($_POST['form']['delivery_wc_dep_email_config']).",
											   `delivery_ftp_host` = ".$db->qstr($_POST['form']['delivery_ftp_host']).",
											   `delivery_ftp_port` = ".$db->qstr($_POST['form']['delivery_ftp_port']).",
											   `delivery_ftp_username` = ".$db->qstr($_POST['form']['delivery_ftp_username']).",
											   `delivery_ftp_password` = ".$db->qstr($_POST['form']['delivery_ftp_password']).",
											   `delivery_ftp_folder` = ".$db->qstr($_POST['form']['delivery_ftp_folder']).",
											   `delivery_us_mail_admin_email` = ".$db->qstr($_POST['form']['delivery_us_mail_admin_email']).",
											   `delivery_us_mail_admin_email_config` = ".$db->qstr($_POST['form']['delivery_us_mail_admin_email_config']).",
											   `delivery_us_mail_address1` = ".$db->qstr($_POST['form']['delivery_us_mail_address1']).",
											   `delivery_us_mail_address2` = ".$db->qstr($_POST['form']['delivery_us_mail_address2']).",
											   `delivery_us_mail_city` = ".$db->qstr($_POST['form']['delivery_us_mail_city']).",
											   `delivery_us_mail_state` = ".$db->qstr($_POST['form']['delivery_us_mail_state']).",
											   `delivery_us_mail_zip` = ".$db->qstr($_POST['form']['delivery_us_mail_zip'])
											   .(isset($_POST['form']['show_on_frontend'])?', show_on_frontend=1':', show_on_frontend=0')
											   .($epdf_file?',`rep_epdf_file`=1':'')
											   .(isset($update_epdf_fields)?',`epdf_fields`=\''.$epdf_fields.'\'':'')
											   ." WHERE `id` = ".$db->qstr($id);

										$db->Execute($upd_sql);

										//echo $id.($xml_file?',`rep_xml_file`=\''.$xml_file.'\'':'');

								  $message = array(
										'type'=>'success',
										'title'=>'Claim Form was saved successfully!',
										'body'=>'Please check all your fields!'
								  );
							}//save

							#get row
							$smarty->assign('n', $n = $db->GetRow("SELECT *,length(`rep_xml_file`) as `rep_xml_file_size`,length(`rep_jrxml_file`) as `rep_jrxml_file_size` FROM `forms` WHERE id=".$db->qstr($id)));
							$smarty->assign('mconfig', $db->GetAll("SELECT `id`,`name` FROM `mail_config` ORDER BY `name`"));

							#update pdf file and screenshots
							if(PostGet('updatepdf')){
								#create pdf file
								//admin_froi2pdf($id);
							}

					  		#get screenshots
							$pdf_dir = FROI_PDF_ROOT . $id;
							$pdf_dir_fs = FROI_PDF_ROOT_FS . $id;
							$pdf_file_fs = $pdf_dir_fs . "/blank.pdf";
							$pdf_file = $pdf_dir . "/blank.pdf";

							if(file_exists($pdf_file_fs)){
								$smarty->assign('pdf_file',$pdf_file);
								$smarty->assign('pdf_preview',$pdf_dir.'/blank_preview_small.jpg');
								$smarty->assign('pdf_review',$pdf_dir.'/blank.jpg');
							}

							$template_to = 'forms_form.tpl';
							break;
					  }

				 case 'editformula': {
				 	$formula_file = $_SERVER['DOCUMENT_ROOT'].'/inc/jrxml_formula.php';

							if (isset($_POST['form']['save'])) {

								if (is_uploaded_file($_FILES['php_file']['tmp_name'])){
									 move_uploaded_file($_FILES['php_file']['tmp_name'], $formula_file);
								}

								$message = array(
									'type'=>'success',
									'title'=>'JRXML/PHP formula file was saved successfully!',
									'body'=>'Please check all your fields!'
								);
							}
							//phpinfo();
							$smarty->assign('file_syntax',php_check_syntax($formula_file,$validate_file));
							$smarty->assign('filesize',filesize($formula_file));
							$smarty->assign('preview',highlight_file($formula_file, true));

							//print_r($validate_file);
							if(isset($validate_file[0]))
								$smarty->assign('check',$validate_file[0]);
							else
								$smarty->assign('check',false);

							//print_r($validate_file);

							$template_to = 'forms_formula.tpl';
							break;
					  }
				case 'get_custom_report_by_location' :
					{
						if (! empty ( $_GET ['id'] )) {
							$id = intval ( ( int ) $_GET ['id'] );

							header ( 'Content-Type: application/json' );
							echo json_encode ( $db->GetAll ( "SELECT `id`,`title`  FROM `custom_reports` WHERE `jrxml_file`!='' AND `location`=$id GROUP BY `filesize` ORDER BY `title` DESC" ) );
							exit ();
						}
						break;
					}

				case 'get_locations_by_name' :
					{
						if (! empty ( $_GET ['name'] )) {
							$name = $_GET ['name'];
							$limit = 20;
							$result = array ();

							// db->debug=1;
							$sql = "SELECT h.`id`, h.`title`, h.`state`, h.`address1`, h.`address2`, h.`code` FROM `$hierarchy->tbl_hierarchy` h
					  		WHERE (`title` LIKE CONCAT('%',?,'%') OR `address1` LIKE CONCAT('%',?,'%') OR `address2` LIKE CONCAT('%',?,'%') OR `code` LIKE CONCAT('%',?,'%'))
					  		ORDER BY `title` ASC LIMIT $limit";
							$stmt = $db->Prepare ( $sql );
							$data = $db->Execute ( $stmt, array (
									$name,
									$name,
									$name,
									$name
							) );

							while ( $tmp = $data->fetchRow () ) {

								$title = '';
								$address = '';

								$title = htmlspecialchars ( $tmp ['title'] );
								if (! empty ( $tmp ['code'] ))
									$title .= ' (' . $tmp ['code'] . ')';
								$title .= '<br />';

								if (! empty ( $states [$tmp ['state']] ))
									$address .= $states [$tmp ['state']];
								if (! empty ( $tmp ['city'] ))
									if (! empty ( $address ))
										$address .= ', ' . $tmp ['city'];
									else
										$address .= $tmp ['city'];
								if (! empty ( $tmp ['address1'] ))
									if (! empty ( $address ))
										$address .= ', ' . $tmp ['address1'];
									else
										$address .= $tmp ['address1'];
								if (! empty ( $tmp ['address2'] ))
									if (! empty ( $address ))
										$address .= ', ' . $tmp ['address2'];
									else
										$address .= $tmp ['address2'];

								$title .= '<span>' . htmlspecialchars ( $address ) . '</span>';
								$result [] = array (
										'id' => $tmp ['id'],
										'text' => $title
								);
							}

							header ( 'Content-Type: application/json' );
							echo json_encode ( $result );
							exit ();
						}
						break;
					}

					  case 'generate': {

						// ni_set('display_errors',true);
						// ni_set('error_reporting',E_ALL | E_STRICT);

						if (! empty ( $_POST ['report_id'] ) && ! empty ( $_POST ['claim_id'] )) {

							// laims
							require_once ('lib/claims.php');
							$claims = new Claims ();

							// laimDistribution Class
							require_once ('lib/claim_distribution.php');
							$claim_distribution = new ClaimDistribution ();

							$report_id = ( int ) $_POST ['report_id'];
							$claim_id = ( int ) $_POST ['claim_id'];
							$state = $_POST ['state'];

							//assign location data
							if(!empty($_POST['injury_location'])){
							    $location_id = (int) $_POST['injury_location'];
							    $location_data = $claim_distribution->location_data = $hierarchy->getLocationData($location_id);
							}

							switch ($report_id) {
								case 1 : // FROI
									$pdf_file = $claim_distribution->claim2pdf ( $state, $claim_id );
									if ($pdf_file) {
										$pdf_file = DOC_ROOT . $pdf_file;
										// utput result, no-cache
										header ( "Cache-Control: no-cache, must-revalidate" ); // HTTP/1.1
										header ( "Expires: Sat, 26 Jul 1997 05:00:00 GMT" ); // Date in the past
										header ( 'Content-type: application/pdf' );
										header ( 'Content-Disposition: attachment; filename="claim_' . $claim_id . '.pdf"' );
										header ( "Content-Length: " . filesize ( $pdf_file ) );
										header ( "Content-Transfer-Encoding: binary" );
										readfile ( $pdf_file );
										exit ();
									}
									break;

								case 3 : // Export (York)
									$result = $claim_distribution->claim2FlatFile ( $claim_id );
									if (! empty ( $result ['filename_fs'] )) {
										// utput result, no-cache
										header ( "Cache-Control: no-cache, must-revalidate" ); // HTTP/1.1
										header ( "Expires: Sat, 26 Jul 1997 05:00:00 GMT" ); // Date in the past
										header ( 'Content-type: text/plain' );
										header ( 'Content-Disposition: attachment; filename="claim_' . $claim_id . '_York.fpt"' );
										header ( "Content-Length: " . filesize ( $result ['filename_fs'] ) );
										header ( "Content-Transfer-Encoding: binary" );
										readfile ( $result ['filename_fs'] );
										exit ();
									}
									break;

								case 4 : // Export (MN Zip)
									$result = $claim_distribution->claim2FlatFile ( $claim_id, true );
									if (! empty ( $result ['filename_fs'] )) {
										// utput result, no-cache
										header ( "Cache-Control: no-cache, must-revalidate" ); // HTTP/1.1
										header ( "Expires: Sat, 26 Jul 1997 05:00:00 GMT" ); // Date in the past
										header ( 'Content-type: application/x-zip-compressed' );
										header ( 'Content-Disposition: attachment; filename="claim_' . $claim_id . '_MN.zip"' );
										header ( "Content-Length: " . filesize ( $result ['filename_fs'] ) );
										header ( "Content-Transfer-Encoding: binary" );
										readfile ( $result ['filename_fs'] );
										exit ();
									}
									break;

								case 5 : // Export (MN XML)
									$result = $claim_distribution->claim2XMLexport ( $claim_id );
									if (! empty ( $result ['filename_fs'] )) {
										// utput result, no-cache
										header ( "Cache-Control: no-cache, must-revalidate" ); // HTTP/1.1
										header ( "Expires: Sat, 26 Jul 1997 05:00:00 GMT" ); // Date in the past
										header ( 'Content-type: text/xml' );
										header ( 'Content-Disposition: attachment; filename="claim_' . $claim_id . '_MN.xml"' );
										header ( "Content-Length: " . filesize ( $result ['filename_fs'] ) );
										header ( "Content-Transfer-Encoding: binary" );
										readfile ( $result ['filename_fs'] );
										exit ();
									}
									break;

								case 6 : // Export (IVOS)
									$result = $claim_distribution->claim2FlatFile ( $claim_id, false, true );
									if (! empty ( $result ['filename_fs'] )) {
										// utput result, no-cache
										header ( "Cache-Control: no-cache, must-revalidate" ); // HTTP/1.1
										header ( "Expires: Sat, 26 Jul 1997 05:00:00 GMT" ); // Date in the past
										header ( 'Content-type: text/plain' );
										header ( 'Content-Disposition: attachment; filename="claim_' . $claim_id . '_IVOS.fpt"' );
										header ( "Content-Length: " . filesize ( $result ['filename_fs'] ) );
										header ( "Content-Transfer-Encoding: binary" );
										readfile ( $result ['filename_fs'] );
										exit ();
									}
									break;

								case 7 : // Export (MVSC)
									$result = $claim_distribution->claim2FlatFile ( $claim_id, true, false, true );
									if (! empty ( $result ['filename_fs'] )) {
										// utput result, no-cache
										header ( "Cache-Control: no-cache, must-revalidate" ); // HTTP/1.1
										header ( "Expires: Sat, 26 Jul 1997 05:00:00 GMT" ); // Date in the past
										header ( 'Content-type: application/x-zip-compressed' );
										header ( 'Content-Disposition: attachment; filename="claim_' . $claim_id . '_MVSC.zip"' );
										header ( "Content-Length: " . filesize ( $result ['filename_fs'] ) );
										header ( "Content-Transfer-Encoding: binary" );
										readfile ( $result ['filename_fs'] );
										exit ();
									}
									break;

								case 8 : // Export (CN XML)
									$claim_data = $claims->getData ( $claim_id );

									if (! empty ( $claim_data ['cn_export_file_url'] ) && file_exists ( DOC_ROOT . $claim_data ['cn_export_file_url'] )) {
										$explode = explode ( '/', $claim_data ['cn_export_file_url'] );

										$xml_file ['path'] = '';
										$xml_file ['filename'] = '';

										foreach ( $explode as $k => $v ) {
											if (count ( $explode ) != $k + 1)
												$xml_file ['path'] .= $v . '/';
											else
												$xml_file ['filename'] = $v;
										}

										$file = $xml_file ['path'] . $xml_file ['filename'];
										if (file_exists ( $file )) {
											// utput result, no-cache
											header ( "Cache-Control: no-cache, must-revalidate" ); // HTTP/1.1
											header ( "Expires: Sat, 26 Jul 1997 05:00:00 GMT" ); // Date in the past
											header ( 'Content-type: text/xml' );
											header ( 'Content-Disposition: attachment; filename="claim_' . $claim_id . '_MN.xml"' );
											header ( "Content-Length: " . filesize ( $file ) );
											header ( "Content-Transfer-Encoding: binary" );
											readfile ( $file );
											exit ();
										}
									} // if claim_data && cn_export_file_url
									break;

								case 10 : // Export (PMA)
									$result = $claim_distribution->claim2PMA_XML ( $claim_id );
									if (! empty ( $result ['filename_fs'] )) {
										// utput result, no-cache
										header ( "Cache-Control: no-cache, must-revalidate" ); // HTTP/1.1
										header ( "Expires: Sat, 26 Jul 1997 05:00:00 GMT" ); // Date in the past
										header ( 'Content-type: text/xml' );
										header ( 'Content-Disposition: attachment; filename="claim_' . $claim_id . '_PMA.xml"' );
										header ( "Content-Length: " . filesize ( $result ['filename_fs'] ) );
										header ( "Content-Transfer-Encoding: binary" );
										readfile ( $result ['filename_fs'] );
										exit ();
									}
									break;

								case $report_id > 100 :
									$pdf_file = $claim_distribution->claim2pdf ( $state, $claim_id, $report_id );
									if ($pdf_file) {
										$pdf_file = DOC_ROOT . $pdf_file;
										// utput result, no-cache
										header ( "Cache-Control: no-cache, must-revalidate" ); // HTTP/1.1
										header ( "Expires: Sat, 26 Jul 1997 05:00:00 GMT" ); // Date in the past
										header ( 'Content-type: application/pdf' );
										header ( 'Content-Disposition: attachment; filename="claim_' . $claim_id . '.pdf"' );
										header ( "Content-Length: " . filesize ( $pdf_file ) );
										header ( "Content-Transfer-Encoding: binary" );
										readfile ( $pdf_file );
										exit ();
									}
									break;
							}
						}

						$custom_reports = $db->GetAll ( "SELECT `id`,`title`  FROM `custom_reports` WHERE `jrxml_file`!='' GROUP BY `filesize` ORDER BY `title` ASC" );

						$smarty->assign ( 'available_forms', $db->GetAll ( "SELECT * FROM `forms` ORDER BY `sum_usa_state_name` ASC" ) );
						$smarty->assign ( 'custom_reports', $custom_reports );
						$smarty->assign ( 'custom_reports_json', json_encode ( array_reverse ( $custom_reports ) ) );
						// $smarty->assign('custom_reports', $claims->getCustomClaimReports($location_id));

						$template_to = 'forms_generate.tpl';
						break;
					}

					case 'generate-error-log' :{

							if(!empty($_POST['clear'])){
								file_put_contents(CLAIM_GENERATION_ERROR_LOG, false);
								$message = array(
								  'type'=>'error',
								  'title'=>'Clear Log',
								  'body'=>'Form Generation Error Log truncated.',
								  'redirect'=>3000,
								  'url'=>'/admin/?cat=forms&action=generate-error-log'
								);
								$smarty->assign('message', $message);
								$template_to = 'global/message.tpl';
								break;
							}

							$log = array_reverse(file(CLAIM_GENERATION_ERROR_LOG));
							$smarty->assign('CLAIM_GENERATION_ERROR_LOG', implode(false, $log));
							$template_to = 'forms_generate_error_log.tpl';

							break;
					}

					case 'sendmail-error-log' :{

							if(!empty($_POST['clear'])){
								file_put_contents(SENDMAIL_ERROR_LOG, false);
								$message = array(
								  'type'=>'error',
								  'title'=>'Clear Log',
								  'body'=>'Sendmail Error Log truncated.',
								  'redirect'=>3000,
								  'url'=>'/admin/?cat=forms&action=sendmail-error-log'
								);
								$smarty->assign('message', $message);
								$template_to = 'global/message.tpl';
								break;
							}

							$log = array_reverse(file(SENDMAIL_ERROR_LOG));
							$smarty->assign('SENDMAIL_ERROR_LOG', implode(false, $log));
							$template_to = 'forms_sendmail_error_log.tpl';

							break;
					}

					  case 'erase': {
							$db->Execute("DELETE FROM `forms` WHERE `id`=".$db->qstr($id));
							$message = array(
								  'type'=>'success',
								  'title'=>'The item was erased successfully!',
								  'body'=>'We are going back to the text panels list.',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=forms'
							);
							$template_to = '../global/message.tpl';
							break;
					  }
				}
				break;
		  }//forms

		  case 'registrations': {
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				if (!$id>0) $action = 'list';
				switch ($action) {
					  default: case 'list': {
							// Registered Users: List
							if (isset($_POST['filter']['apply'])) {
							  $list = $db->GetAll("
								  SELECT * FROM registrations
								  WHERE
									  `".$_POST['filter']['by']."` LIKE ".$db->qstr("%".$_POST['filter']['string']."%")."
								  ORDER BY `registered_at` DESC");
							} else {
								$all = $db->GetOne("SELECT COUNT(*) FROM registrations");
								$limit = 20;
								$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
								$list = $db->GetAll("
									  SELECT * FROM registrations ORDER BY `registered_at` DESC
									  LIMIT ".($paging['current']*$limit).", $limit");
							}
							$smarty->assign('registrations', $list);
							$template_to = 'registrations_list.tpl';
							break;
					  }
					  case 'edit': {
							if (isset($_POST['reg']['save'])) {
								  $db->Execute("UPDATE `registrations` SET
													`name` = ".$db->qstr($_POST['reg']['name']).",
													`email` = ".$db->qstr($_POST['reg']['email']).",
													`gsm` = ".$db->qstr($_POST['reg']['gsm']).",
													`product_id` = ".$db->qstr($_POST['reg']['product_id']).",
													`date` = ".$db->qstr($_POST['reg']['date']).",
													`diler` = ".$db->qstr($_POST['reg']['diler']).",
													".(isset($_POST['reg']['montage_certificate']) ? "`montage_certificate` = ".$db->qstr($_POST['reg']['montage_certificate'])."," : '')."
													".(isset($_POST['reg']['door_manufacturer_name']) ? "`door_manufacturer_name` = ".$db->qstr($_POST['reg']['door_manufacturer_name'])."," : '')."
													".(isset($_POST['reg']['door_manufacturer_company']) ? "`door_manufacturer_company` = ".$db->qstr($_POST['reg']['door_manufacturer_company'])."," : '')."
													".(isset($_POST['reg']['door_manufacturer_address']) ? "`door_manufacturer_address` = ".$db->qstr($_POST['reg']['door_manufacturer_address'])."," : '')."
													`key` = ".$db->qstr($_POST['reg']['key'])."
											  WHERE `id` = ".$db->qstr($id));
								  $message = array(
										'type'=>'success',
										'title'=>'Потребителят беше записан успешно!',
										'body'=>'Моля прегледайте дали данните отговарят на това, което сте написали!'
								  );
							}
							$smarty->assign('r', $r = $db->GetRow("
								  SELECT r.*, i.value as `question`
								  FROM registrations r
										LEFT JOIN interface i ON i.name = CONCAT('secret_question_', r.question) AND i.lang_id = ".$db->qstr($lang['id'])."
								  WHERE r.id=".$db->qstr($id)));
							$template_to = 'registered_form.tpl';
							break;
					  }
					  case 'erase': {
							$db->Execute("DELETE FROM `registrations` WHERE `id`=".$db->qstr($id));
							$message = array(
								  'type'=>'success',
								  'title'=>'Потребителят беше изтрит успешно!',
								  'body'=>'Връщате се към списъка с потребителите.',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=registrations'
							);
							$template_to = '../global/message.tpl';
							break;
					  }
					  case 'pool': {
						  $template_to = 'registered_pool.tpl';

						  $pool = $db->GetRow("SELECT id, name FROM pools WHERE id = ".$pool_id);
						  $pool['questions'] = $db->GetAll("SELECT id, question FROM pools_questions WHERE pool_id=".$pool['id']);
						  // Delete the Answers
						  if (isset($_POST['pool']['erase'])) {
							  $db->Execute("DELETE FROM reg_answers WHERE pool_id = $pool_id AND reg_id=".$db->qstr($id));
							  $message = array(
								  'type'=>'success',
								  'title'=>'Анкетата беше изтрита успешно!',
								  'body'=>'Връщате се към списъка с регистрираните потребители.',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=registrations'
							  );
							  $db->Execute("
								  UPDATE `registrations` SET
									  `pool_points` = NULL
								  WHERE id = ".$db->qstr($id)."
							  ");
							  $template_to = '../global/message.tpl';
						  }
						  // Update the Pool
						  if (isset($_POST['pool']['save'])) {
							  $db->Execute("DELETE FROM reg_answers WHERE pool_id = $pool_id AND reg_id=".$db->qstr($id));
							  foreach ($_POST['pool'] as $key => $answer) {
								  if ($key>0 && $answer>0) {
									  $db->Execute("
										  INSERT INTO reg_answers SET
										  `pool_id`='$pool_id',
										  `reg_id`=".$db->qstr($id).",
										  `answer_id`=".$db->qstr($answer)."
									  ");
								  }
							  }
							  unset($_POST['pool']['save']);
							  $points = $db->GetOne("SELECT SUM(points) FROM pools_answers WHERE id IN (".implode(',', $_POST['pool']).")");
							  if (!empty($points)) $db->Execute("
								  UPDATE `registrations` SET
									  `pool_points` = $points
								  WHERE id = ".$db->qstr($id)."
							  ");
							  $message = array(
								  'type'=>'success',
								  'title'=>'Анкетата беше редактираната успешно!',
								  'body'=>'Прегледайте дали съдържанието отговаря на вашите отговори.'
							  );
						  }

						  if (!empty($pool['questions'])) foreach ($pool['questions'] as &$q) {
							  $q['answers'] = $db->GetAll("
								  SELECT pa.id, pa.answer, pa.points, IF(a.id IS NULL,0,1) AS `checked`
								  FROM pools_answers pa
									  LEFT JOIN reg_answers a ON a.answer_id = pa.id AND a.pool_id = ".$pool_id." AND reg_id = ".$db->qstr($id)."
								  WHERE pa.question_id=".$q['id']."
							  ");
						  }
						  $smarty->assign('p', $pool);
						  $smarty->assign('r', $r = $db->GetRow("
								  SELECT r.*, i.value as `question`, c.id as `montager_id`
								  FROM registrations r
										LEFT JOIN interface i ON i.name = CONCAT('secret_question_', r.question) AND i.lang_id = ".$db->qstr($lang['id'])."
										LEFT JOIN sc_personal_cerfiticates c ON c.certificate_number = r.montage_certificate
								  WHERE r.id=".$db->qstr($id)));
						  //print_array($pool);
						  break;
					  }
				}
				break;
		  }
		  case 'pages': {
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				if (!$id>0) $action = 'list';
				switch ($action) {
					  default: case 'list': {
							// Pages: List
							$smarty->assign('pages', $pages = $db->GetAll("SELECT * FROM pages WHERE lang_id=".$lang['id']." ORDER BY `pos`, `position`"));
							$template_to = 'pages_list.tpl';
							break;
					  }
					  case 'add': {
							$template_to = 'pages_add.tpl';
							if (isset($_POST['page']['save'])) {
								  if (mb_strlen($_POST['page']['identifier'],"UTF-8")>0 && mb_strlen($_POST['page']['name'],"UTF-8")>0 && $db->GetOne("SELECT id FROM pages WHERE `identifier`=".$db->qstr($_POST['page']['identifier']))==false) {
										$db->Execute("INSERT INTO `pages` SET
														  `lang_id` = ".$db->qstr($lang['id']).",
														  `identifier` = ".$db->qstr($_POST['page']['identifier']).",
														  `pos` = ".$db->qstr($_POST['page']['pos']).",
														  `position` = ".$db->qstr($_POST['page']['position']).",
														  `url` = ".$db->qstr('/pg/'.$_POST['page']['identifier'].'/').",
														  `name` = ".$db->qstr($_POST['page']['name']).",
														  `add` = ".$db->qstr($_POST['page']['add']).",
														  `title` = ".$db->qstr($_POST['page']['title']).",
														  `description` = ".$db->qstr($_POST['page']['description']).",
														  `keywords` = ".$db->qstr($_POST['page']['keywords'])."
													 ");
										$db->Execute("INSERT INTO `texts` SET
														  `lang_id` = ".$db->qstr($lang['id']).",
														  `identifier` = ".$db->qstr('ext_'.$_POST['page']['identifier']).",
														  `name` = ".$db->qstr($_POST['page']['name']).",
														  `title` = ".(mb_strlen($_POST['page']['title'],"UTF-8")>0 ? $db->qstr($_POST['page']['title']) : $db->qstr($_POST['page']['name'])).",
														  `owner` = 'global'
													 ");
										$text_id = $db->Insert_ID();
										$message = array(
											  'type'=>'success',
											  'title'=>'Page was added successfully!',
											  'body'=>'We are going to page information forms.',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=texts&action=edit&id='.$text_id
										);
										$template_to = '../global/message.tpl';
								  } else {
										$message = array(
											  'type'=>'error',
											  'title'=>'The page has no identifier, or this name/identifier is already used!',
											  'body'=>'Please enter other identifier and try again!'
										);
								  }
							}
							break;
					  }
					  case 'edit': {
							if (isset($_POST['page']['save'])) {
								  $db->Execute("UPDATE `pages` SET
													`pos` = ".$db->qstr($_POST['page']['pos']).",
													`position` = ".$db->qstr($_POST['page']['position']).",
													`url` = ".$db->qstr($_POST['page']['url']).",
													`name` = ".$db->qstr($_POST['page']['name']).",
													`add` = ".$db->qstr($_POST['page']['add']).",
													`title` = ".$db->qstr($_POST['page']['title']).",
													`description` = ".$db->qstr($_POST['page']['description']).",
													`keywords` = ".$db->qstr($_POST['page']['keywords'])."
											  WHERE `id` = ".$db->qstr($id));
								  $message = array(
										'type'=>'success',
										'title'=>'Meta information was saved successfully!',
										'body'=>'Please check all the field data!'
								  );
							}
							$smarty->assign('p', $p = $db->GetRow("
								  SELECT *
								  FROM pages
								  WHERE id=".$id));
							$template_to = 'pages_form.tpl';
							break;
					  }
					  case 'erase': {
						  $page_info = $db->GetRow("SELECT * FROM `pages` WHERE `id`=".$db->qstr($id));
						  if ($page['pos']!='top') {
							  $db->Execute("DELETE FROM `pages` WHERE `id`=".$db->qstr($id));
							  $db->Execute("DELETE FROM `texts` WHERE `identifier`=".$db->qstr('ext_'.$page_info['identifier']));
							  $message = array(
								  'type'=>'success',
								  'title'=>'The page was erased successfully!',
								  'body'=>'We are going back to the page list.',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=pages'
							  );
						  } else {
							  $message = array(
								  'type'=>'error',
								  'title'=>'This page cannot be erased!',
								  'body'=>'This is primary page! We are going back to the page list.',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=pages'
							  );
						  }
							$template_to = '../global/message.tpl';
							break;
					  }
				}
				break;
		  }

		  case 'mail_settings': {
			if (isset($_POST['mail']['save'])) {
				$db->Execute("UPDATE `vars` SET `value` = ".$db->qstr($_POST['mail']['mail_to_auto'])." WHERE `name` = 'mail_to_auto'");
				$db->Execute("UPDATE `vars` SET `value` = ".$db->qstr($_POST['mail']['mail_to_feedback'])." WHERE `name` = 'mail_to_feedback'");
				$db->Execute("UPDATE `vars` SET `value` = ".$db->qstr($_POST['mail']['mail_from'])." WHERE `name` = 'mail_from'");
				$db->Execute("UPDATE `vars` SET `value` = ".$db->qstr($_POST['mail']['send_for_new_quote'])." WHERE `name` = 'send_for_new_quote'");
				$db->Execute("UPDATE `vars` SET `value` = ".$db->qstr($_POST['mail']['send_for_complete_quote'])." WHERE `name` = 'send_for_complete_quote'");
				$db->Execute("UPDATE `vars` SET `value` = ".$db->qstr($_POST['mail']['send_for_complete_quote_user'])." WHERE `name` = 'send_for_complete_quote_user'");
				$db->Execute("UPDATE `vars` SET `value` = ".$db->qstr($_POST['mail']['send_for_feedback'])." WHERE `name` = 'send_for_feedback'");

				$message = array(
					'type'=>'success',
					'title'=>'The settings are saved!',
					'body'=>'Please check out all the data!'
				);
			}
			$smarty->assign('settings', $db->GetAssoc("SELECT NAME, VALUE FROM vars WHERE NAME IN ('mail_to_auto', 'mail_to_feedback', 'mail_from', 'send_for_new_quote', 'send_for_complete_quote', 'send_for_complete_quote_user', 'send_for_feedback')"));
			$template_to = 'mail_settings.tpl';
			break;
		  }
		  case 'mail_templates': {
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				if (!$id>0) $action = 'list';
				switch ($action) {
					  default: case 'list': {
							// Mail Templates: List
							$all = $db->GetOne("SELECT COUNT(*) FROM mail_templates");
							$limit = 15;
							$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
							$list = $db->GetAll("SELECT * FROM mail_templates ORDER BY `date` DESC LIMIT ".($paging['current']*$limit).", $limit");
							$smarty->assign('list', $list);
							$template_to = 'mail_templates_list.tpl';
							break;
					  }
					  case 'edit': {
						// Mail Templates: Edit and Preview
						if (isset($_POST['mail']['save'])) {
							  if (mb_strlen($_POST['mail']['template'],"UTF-8")>0) {
									$db->Execute("UPDATE `mail_templates` SET
													  `name` = ".$db->qstr($_POST['mail']['name']).",
													  `template` = ".$db->qstr($_POST['mail']['template']).",
													  `date` = NOW()
												 WHERE `id` = ".$db->qstr($id));
									$message = array(
										'type'=>'success',
										'title'=>'Mail Template is saved successfuly!',
										'body'=>'Please check it out in the preview panel!'
									);
							  } else {
									$message = array(
										'type'=>'error',
										'title'=>'Mail Template cannot be saved!',
										'body'=>'Please fill title and body fields!'
									);
							  }
						}
						$smarty->assign('t', $t = $db->GetRow("SELECT * FROM mail_templates WHERE id=".$db->qstr($id)));
						$template_to = 'mail_template_form.tpl';
						break;
					  }
					  case 'preview': {
						  $t = $db->GetOne("SELECT template FROM mail_templates WHERE id=".$db->qstr($id));
						  $d = $db->GetRow("SELECT * FROM `hierarchy` WHERE `id`=40");
						  $smarty->assign('message', compileMessage($t, $d));

						  $smarty->assign('noframe', true);
						  $template_to = 'global_template.tpl';
						  break;
					  }
					  case 'full': {
						  $smarty->assign('id', $id);
						  $template_to = 'mail_templates_full.tpl';
						  break;
					  }
					  case 'add': {
							$template_to = 'mail_template_add.tpl';
							if (isset($_POST['mail']['save'])) {
								  if (mb_strlen($_POST['mail']['template'],"UTF-8")>0) {
										$db->Execute("INSERT INTO `mail_templates` SET
														  `lang_id` = ".$db->qstr($lang['id']).",
														  `name` = ".$db->qstr($_POST['mail']['name']).",
														  `template` = ".$db->qstr($_POST['mail']['template']).",
														  `date` = NOW()
													 ");
										$message = array(
											  'type'=>'success',
											  'title'=>'Mail Template is saved successfuly!',
											  'body'=>'Please check it out in the preview panel!',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=mail_templates'
										);
										$template_to = '../global/message.tpl';
								  } else {
										$message = array(
											'type'=>'error',
											'title'=>'Mail Template cannot be saved!',
											'body'=>'Please fill title and body fields!'
										);
								  }
							}
							break;
					  }
					  case 'erase': {
							$db->Execute("DELETE FROM `mail_templates` WHERE `id`=".$db->qstr($id));
							$message = array(
								  'type'=>'success',
								  'title'=>'The mail template was erased successfully!',
								  'body'=>'We are taking you back to the templates list.',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=mail_templates'
							);
							$template_to = '../global/message.tpl';
							break;
					  }
				}
				break;
		  }
		case 'triage_queue': { 
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				
				$true_all = false; $isQueue = true; $all = true;ini_set('date.timezone','America/Denver');
				
				$stats_hold = 0;
				$stats_pending = 0;
				
				$calls_status = array(
									'ended'=>'Call Ended',
									'callback'=>'Call Back Required',
									'onhold'=>'Call On Hold',
									'willcall'=>'IE Will Call Back',
									'closed'=>'Completing Call'
								);
								
				if($_GET['action'] != "eraseselected")
				if (!$id>0) $action = 'list';
				switch ($action) {
					  default: case 'list': {
							// Mail Templates: List
																						
							$all = $db->GetOne("SELECT COUNT(*)
							FROM triage_calls t
							LEFT JOIN claims c ON t.claim_id = c.id
							WHERE
								t.phone IS NOT NULL AND t.date IS NOT NULL AND t.date!=''
								".($true_all == false ? "AND t.claim_id > 0 AND t.status!='ended'" : "")."
								".($all ? false: "AND c.claim_result_code IN(2,3)")."
								".($isQueue ? ' AND t.clear!="1" ' : '')."
							".($isQueue ? '' : ' GROUP BY t.claim_id ')."
							ORDER BY
								".($true_all == false ? "t.status, t.claim_id, t.date ASC" : "t.date DESC")."");
														
							
							$limit = 999;
							$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
							
							$calls = $db->GetAll("SELECT c.id, c.userid, c.claimant_first_name, c.claimant_last_name, c.claim_result_code, c.claim_result_description,
							t.id as `call_id`, c.injury_description, c.injury_part_of_body_description, c.injury_cause_description,
							c.`general_jurisdiction` AS `benefit_state`, c.claim_submit_timestamp, c.employer_name, c.employer_location_name, 
							t.`triage_begin_time`, t.claim_id, t.status AS `call_status`, t.phone AS `call_number`, t.date,
							IF(c.claim_submit_timestamp = '0000-00-00 00:00:00', TIME_TO_SEC(TIMEDIFF(NOW(), " . ( $isQueue ? 't.in_triage_queue_time' : 't.date' ) . ")), TIME_TO_SEC(TIMEDIFF(c.claim_submit_timestamp, t.in_triage_queue_time))) AS `lag`,
							IF(c.claim_submit_timestamp = '0000-00-00 00:00:00', IF(HOUR(TIMEDIFF(NOW(), " . ( $isQueue ? 't.in_triage_queue_time' : 't.date' ) . ")) > 0, TRUE, FALSE), IF(HOUR(TIMEDIFF(c.claim_submit_timestamp, t.in_triage_queue_time)) > 0, TRUE, FALSE)) AS `lag_over_hour`, t.taken_by_user_id, t.triage_by_user_id, t.deleted
							FROM triage_calls t
							LEFT JOIN claims c ON t.claim_id = c.id
							WHERE
								t.phone IS NOT NULL AND t.date IS NOT NULL AND t.date!=''
								".($true_all == false ? "AND t.claim_id > 0 AND t.status!='ended'" : "")."
								".($all ? false: "AND c.claim_result_code IN(2,3)")."
								".($isQueue ? ' AND t.clear!="1" ' : '')."
							".($isQueue ? '' : ' GROUP BY t.claim_id ')."
							ORDER BY
								".($true_all == false ? "t.status, t.claim_id, t.date ASC" : "t.date DESC")." LIMIT ".($paging['current']*$limit).", $limit");
							
							
							if($calls)
							{
								$new_calls = array();
								$call_id = array();
								$claim_id = array();
								foreach ($calls as $key => $value) {
									$new_calls[] = array(
										'call_id'=>$value['call_id'],
										'claim_id' => $value['claim_id'],
										'key' => $key
									);
									$call_id[$key] = $value['call_id'];
									$claim_id[$key] = $value['claim_id'];
								}
								array_multisort($claim_id, SORT_ASC, $call_id, SORT_DESC, $new_calls);
								foreach($new_calls as $key => $value){
									foreach($new_calls as $key1 => $value1){
										if($value1['claim_id'] == $value['claim_id']){
											if($value1['call_id'] < $value['call_id']){
												unset($calls[$value1['key']]);
												//$stats_pending--;
											}
										}
									}
								}
								foreach($calls as $call){
									if($call['deleted'] == 0){
										if($call['call_status'] == 'onhold'){
											$stats_hold++;
										}
										$stats_pending++;
									}
								}
							}
							
						
								function smartdate($objects){
								  foreach ($objects as $key => $object) {
									// $objects[$key] = array_replace($object,  array('lag' => secondsToTime($object['lag'])));
									$objects[$key]['lag'] = secondsToTime($object['lag']);
								  }
								  return $objects;
								}
								
								//transform seconds to human readable time elapsed
								function secondsToTime($inputSeconds) {
									$secondsInAMinute = 60;
									$secondsInAnHour  = 60 * $secondsInAMinute;
									$secondsInADay    = 24 * $secondsInAnHour;

									// extract days
									$days = floor($inputSeconds / $secondsInADay);

									// extract hours
									$hourSeconds = $inputSeconds % $secondsInADay;
									$hours = floor($hourSeconds / $secondsInAnHour);

									// extract minutes
									$minuteSeconds = $hourSeconds % $secondsInAnHour;
									$minutes = floor($minuteSeconds / $secondsInAMinute);

									// extract the remaining seconds
									$remainingSeconds = $minuteSeconds % $secondsInAMinute;
									$seconds = ceil($remainingSeconds);

									// return the final array
									$obj = ( $days ? (int) $days .'d ' : '' ) . ($hours ? (int) $hours . 'h ' : '') . (int) $minutes .'min' ;
									return $obj;
								}
	
							//echo "<pre>";
							//print_r($calls);exit;
							
							
							$calls = smartdate($calls);
							
							$smarty->assign('calls', $calls);
							//$smarty->assign('stats', getCallStats());
							$smarty->assign('stats_hold', $stats_hold);
							$smarty->assign('stats_pending', $stats_pending);
							$smarty->assign('calls_status', $calls_status);
		
							$template_to = 'triage_queue_list.tpl';
							break;
					  }
					  case 'erase': {
						  //echo "UPDATE `triage_calls` SET `clear`= '1' WHERE `id`=".$db->qstr($id);
							$db->Execute("UPDATE `triage_calls` SET `clear`= '1' WHERE `id`=".$db->qstr($id));
							$message = array(
								  'type'=>'success',
								  'title'=>'Call was erased successfully!',
								  'body'=>'We are taking you back to the triage queue list.',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=triage_queue'
							);
							$smarty->assign('message', $message);
							$template_to = 'templates/global/message.tpl';
							break;
					  }
					  case 'eraseselected': { 
							foreach($_POST['chkids'] as $idval)
							{
							$db->Execute("UPDATE `triage_calls` SET `clear`= '1' WHERE `id`=".$idval);
							}
							$message = array(
								  'type'=>'success',
								  'title'=>'Call was erased successfully!',
								  'body'=>'We are taking you back to the triage queue list.',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=triage_queue'
							);
							$smarty->assign('message', $message);
							$template_to = 'templates/global/message.tpl';
							break;
					  
					  }
				}
				break;
		  }
		  ////////////////////// Start Added by rambabu /////////////////////
		  case 'injurycode': {
			 
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				
				if (!$id>0) $action = 'list';
				
				if(isset($_GET['action']))
				{
				if($_GET['action'] == 'changestatus') $action = 'changestatus';
				elseif($_GET['action'] == 'showlist') $action = 'showlist';
				}
				
				switch ($action) {
					  default: case 'list': {
							// severity: List
							if(isset($_GET['order']))
							$orderby = $_GET['order'];
							else $orderby = 'default';
							switch ($orderby) {
								case 'id_asc' :
									$order = 'ORDER BY id ASC';
									$smarty->assign('order','id_asc');
									break;
								case 'id_desc' :
									$order = 'ORDER BY id DESC';
									$smarty->assign('order','id_desc');
									break;
								case 'title_asc' :
									$order = 'ORDER BY title ASC';
									$smarty->assign('order','title_asc');
									break;
								case 'title_desc' :
									$order = 'ORDER BY title DESC';
									$smarty->assign('order','title_desc');
									break;
								default :
									$order = 'ORDER BY status ASC, title ASC';
									$smarty->assign('order','');
									break;
							}
							if (isset($_POST['filter']['apply']) || (isset($_GET['searchterm']) && $_GET['searchterm']!=''))
							{
								if (isset($_POST['filter']['apply']))
									$search_term = $_POST['filter']['string'];
								else
									$search_term = trim($_GET['searchterm']);
								
								$list = $db->GetAll("SELECT * FROM triage_injury_codes WHERE title LIKE ".$db->qstr("%".$search_term."%")." ".$order."");
								$smarty->assign('search',$search_term);
							}
							else
							{
								$all = $db->GetOne("SELECT COUNT(*) FROM triage_injury_codes");
								$limit = 25;
								$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
								$list = $db->GetAll("SELECT * FROM triage_injury_codes ".$order." LIMIT ".($paging['current']*$limit).", $limit");
								$smarty->assign('search','');
							}
							$smarty->assign('list', $list);
							$template_to = 'injurycode_list.tpl';
							break;
					  }
					  case 'changestatus': {
						  
						  if (isset($_POST['selectedvalue'])){
	
								$resvalues = $_POST['selectedvalue'];
								
								if(isset($resvalues)) {
									
									$changedinfo = explode("_", $resvalues); 
									if(($changedinfo[1]!='') && ($changedinfo[0]!=''))
									{
									$stmt = $db->Prepare("UPDATE `triage_injury_codes` SET `status`= '".$changedinfo[1]."' WHERE (`id`=?)");
									$db->Execute($stmt, array($changedinfo[0]));
									echo "1";exit;
									}
									else echo "2";exit;
								
								}
								else echo "2";exit;
							}
							else echo "2";exit;
						  break;
					  }
					  case 'showlist': {
						  
						  if (isset($_GET['term']))
						  {
								$return_arr = array(); 
								$param = $_GET['term'];
								$stmt = $db->Prepare('SELECT `title` FROM `triage_injury_codes` WHERE `title` LIKE CONCAT(?,"%") GROUP BY `title`');
								$result = $db->Execute($stmt, array($param));
								
								while($row = $result->fetchRow()) {
									$return_arr[] =  $row['title'];
								}

								/* Toss back results as json encoded array. */
								echo json_encode($return_arr);exit;
							}
						  exit;
						  break;
					  }
					  case 'edit': {
						// injurycode: Edit and Preview
						if (isset($_POST['injurycode']['save'])) {
							  if (mb_strlen($_POST['injurycode']['title'],"UTF-8")>0) {
									$db->Execute("UPDATE `triage_injury_codes` SET
													  `title` = ".$db->qstr($_POST['injurycode']['title']).",
													  `code` = ".$db->qstr($_POST['injurycode']['code']).",
													  `status` = ".$db->qstr($_POST['injurycode']['status'])."
												 WHERE `id` = ".$db->qstr($id));
												 
										////// Codes ////////
										$result = $db->Execute("DELETE FROM `triage_guidelines_injurycodes_map`
												 WHERE `injury_code` = ".$db->qstr($id));
										if($result)
										{
											if($_POST['injurycode']['guidelines']){
												foreach($_POST['injurycode']['guidelines'] as $injury_code)
												{
													$db->Execute("INSERT INTO `triage_guidelines_injurycodes_map` SET
														  `guideline` = ".$db->qstr($injury_code).",
														  `injury_code` = ".$db->qstr($id)."
													 ");
												
												}
											}
										}												 
												 
									$message = array(
										'type'=>'success',
										'title'=>'Injury code is saved successfuly!',
										'body'=>'Please check it out in the injurycode list!'
									);
							  } else {
									$message = array(
										'type'=>'error',
										'title'=>'Injury code cannot be saved!',
										'body'=>'Please fill title field !'
									);
							  }
						}
						
						$list = $db->GetAll("SELECT * FROM triage_guidelines WHERE status = 'y' ORDER BY title ASC");
						$smarty->assign('list', $list);
						
						$guidelinecodes = $db->GetAll("SELECT guideline FROM triage_guidelines_injurycodes_map WHERE injury_code=".$db->qstr($id));
						
						$guilinevals = array();
						foreach($guidelinecodes as $guide){
							$guilinevals[] = $guide['guideline'];
						}
						
						$smarty->assign('guidelinecodes', $guilinevals);
						
						$smarty->assign('t', $t = $db->GetRow("SELECT * FROM triage_injury_codes WHERE id=".$db->qstr($id)));
						$template_to = 'injurycode_form.tpl';
						break;
					  }
					  case 'add': {
							$template_to = 'injurycode_add.tpl';
							
							$list = $db->GetAll("SELECT * FROM triage_guidelines WHERE status = 'y' ORDER BY title ASC");
							$smarty->assign('list', $list);
							
							if (isset($_POST['injurycode']['save'])) {
								  if (mb_strlen($_POST['injurycode']['title'],"UTF-8")>0) {
										$sss = $db->Execute("INSERT INTO `triage_injury_codes` SET
														  `title` = ".$db->qstr($_POST['injurycode']['title']).",
														  `code` = ".$db->qstr($_POST['injurycode']['code']).",
														  `status` = ".$db->qstr($_POST['injurycode']['status'])."
													 ");
										$lastinsertid = $db->GetOne("SELECT LAST_INSERT_ID()");
													 	 
										foreach($_POST['injurycode']['guidelines'] as $injury_code)
										{
											$db->Execute("INSERT INTO `triage_guidelines_injurycodes_map` SET
													  `guideline` = ".$db->qstr($injury_code).",
													  `injury_code` = ".$db->qstr($lastinsertid)."
											 ");
											
										}
													 
										$message = array(
											  'type'=>'success',
											  'title'=>'Injury code is saved successfuly!',
											  'body'=>'Please check it out in the injurycode list!',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=injurycode'
										);
								
										$template_to = 'templates/global/message.tpl';
								  } else {
										$message = array(
											'type'=>'error',
											'title'=>'Injury code cannot be saved!',
											'body'=>'Please fill title field!'
										);
								  }
							}
							break;
					  }
				}
				break;
				
		  }
		  case 'accidentcode': {
			 
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				
				if (!$id>0) $action = 'list';
				
				if(isset($_GET['action']))
				{
				if($_GET['action'] == 'changestatus') $action = 'changestatus';
				elseif($_GET['action'] == 'showlist') $action = 'showlist';
				}
				
				switch ($action) {
					  default: case 'list': {
							// severity: List
							if(isset($_GET['order']))
							$orderby = $_GET['order'];
							else $orderby = 'default';
							switch ($orderby) {
								case 'id_asc' :
									$order = 'ORDER BY id ASC';
									$smarty->assign('order','id_asc');
									break;
								case 'id_desc' :
									$order = 'ORDER BY id DESC';
									$smarty->assign('order','id_desc');
									break;
								case 'title_asc' :
									$order = 'ORDER BY title ASC';
									$smarty->assign('order','title_asc');
									break;
								case 'title_desc' :
									$order = 'ORDER BY title DESC';
									$smarty->assign('order','title_desc');
									break;
								case 'description_asc' :
									$order = 'ORDER BY description ASC';
									$smarty->assign('order','description_asc');
									break;
								case 'description_desc' :
									$order = 'ORDER BY description DESC';
									$smarty->assign('order','description_desc');
									break;
								default :
									$order = 'ORDER BY status ASC, title ASC';
									$smarty->assign('order','');
									break;
							}
							if (isset($_POST['filter']['apply']) || (isset($_GET['searchterm']) && $_GET['searchterm']!=''))
							{
								if (isset($_POST['filter']['apply']))
									$search_term = $_POST['filter']['string'];
								else
									$search_term = trim($_GET['searchterm']);
								
								$list = $db->GetAll("SELECT * FROM triage_accident_codes WHERE title LIKE ".$db->qstr("%".$search_term."%")." ".$order."");
								$smarty->assign('search',$search_term);
							}
							else
							{
								$all = $db->GetOne("SELECT COUNT(*) FROM triage_accident_codes");
								$limit = 25;
								$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
								$list = $db->GetAll("SELECT * FROM triage_accident_codes ".$order." LIMIT ".($paging['current']*$limit).", $limit");
								$smarty->assign('search','');
							}
							$smarty->assign('list', $list);
							$template_to = 'accidentcode_list.tpl';
							break;
					  }
					  case 'changestatus': {
						  
						  if (isset($_POST['selectedvalue'])){
	
								$resvalues = $_POST['selectedvalue'];
								
								if(isset($resvalues)) {
									
									$changedinfo = explode("_", $resvalues); 
									if(($changedinfo[1]!='') && ($changedinfo[0]!=''))
									{
									$stmt = $db->Prepare("UPDATE `triage_accident_codes` SET `status`= '".$changedinfo[1]."' WHERE (`id`=?)");
									$db->Execute($stmt, array($changedinfo[0]));
									echo "1";exit;
									}
									else echo "2";exit;
								
								}
								else echo "2";exit;
							}
							else echo "2";exit;
						  break;
					  }
					  case 'showlist': {
						  
						  if (isset($_GET['term']))
						  {
								$return_arr = array(); 
								$param = $_GET['term'];
								$stmt = $db->Prepare('SELECT `title` FROM `triage_accident_codes` WHERE `title` LIKE CONCAT(?,"%") GROUP BY `title`');
								$result = $db->Execute($stmt, array($param));
								
								while($row = $result->fetchRow()) {
									$return_arr[] =  $row['title'];
								}

								/* Toss back results as json encoded array. */
								echo json_encode($return_arr);exit;
							}
						  exit;
						  break;
					  }
					  case 'edit': {
						// accidentcode: Edit and Preview
						if (isset($_POST['accidentcode']['save'])) {
							  if (mb_strlen($_POST['accidentcode']['title'],"UTF-8")>0) {
									$db->Execute("UPDATE `triage_accident_codes` SET
													  `title` = ".$db->qstr($_POST['accidentcode']['title']).",
													  `description` = ".$db->qstr($_POST['accidentcode']['desc']).",
													  `code` = ".$db->qstr($_POST['accidentcode']['code']).",
													  `status` = ".$db->qstr($_POST['accidentcode']['status'])."
												 WHERE `id` = ".$db->qstr($id));
												 
										////// Codes ////////
										$result = $db->Execute("DELETE FROM `triage_guidelines_accidentcodes_map`
												 WHERE `accident_code` = ".$db->qstr($id));
										if($result)
										{
											if($_POST['accidentcode']['guidelines']){
												foreach($_POST['accidentcode']['guidelines'] as $accident_code)
												{
													$db->Execute("INSERT INTO `triage_guidelines_accidentcodes_map` SET
														  `guideline` = ".$db->qstr($accident_code).",
														  `accident_code` = ".$db->qstr($id)."
													 ");
												
												}
											}
										}												 
												 
									$message = array(
										'type'=>'success',
										'title'=>'Accident code is saved successfuly!',
										'body'=>'Please check it out in the accidentcode list!'
									);
							  } else {
									$message = array(
										'type'=>'error',
										'title'=>'Accident code cannot be saved!',
										'body'=>'Please fill title field !'
									);
							  }
						}
						
						$list = $db->GetAll("SELECT * FROM triage_guidelines WHERE status = 'y' ORDER BY title ASC");
						$smarty->assign('list', $list);
						
						$guidelinecodes = $db->GetAll("SELECT guideline FROM triage_guidelines_accidentcodes_map WHERE accident_code=".$db->qstr($id));
						
						$guilinevals = array();
						foreach($guidelinecodes as $guide){
							$guilinevals[] = $guide['guideline'];
						}
						
						$smarty->assign('guidelinecodes', $guilinevals);
						
						$smarty->assign('t', $t = $db->GetRow("SELECT * FROM triage_accident_codes WHERE id=".$db->qstr($id)));
						$template_to = 'accidentcode_form.tpl';
						break;
					  }
					  case 'add': {
							$template_to = 'accidentcode_add.tpl';
							
							$list = $db->GetAll("SELECT * FROM triage_guidelines WHERE status = 'y' ORDER BY title ASC");
							$smarty->assign('list', $list);
							
							if (isset($_POST['accidentcode']['save'])) {
								  if (mb_strlen($_POST['accidentcode']['title'],"UTF-8")>0) {
										$sss = $db->Execute("INSERT INTO `triage_accident_codes` SET
														  `title` = ".$db->qstr($_POST['accidentcode']['title']).",
														  `description` = ".$db->qstr($_POST['accidentcode']['desc']).",
														  `code` = ".$db->qstr($_POST['accidentcode']['code']).",
														  `status` = ".$db->qstr($_POST['accidentcode']['status'])."
													 ");
										$lastinsertid = $db->GetOne("SELECT LAST_INSERT_ID()");
													 	 
										foreach($_POST['accidentcode']['guidelines'] as $accident_code)
										{
											$db->Execute("INSERT INTO `triage_guidelines_accidentcodes_map` SET
													  `guideline` = ".$db->qstr($accident_code).",
													  `accident_code` = ".$db->qstr($lastinsertid)."
											 ");
											
										}
													 
										$message = array(
											  'type'=>'success',
											  'title'=>'Accident code is saved successfuly!',
											  'body'=>'Please check it out in the accidentcode list!',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=accidentcode'
										);
								
										$template_to = 'templates/global/message.tpl';
								  } else {
										$message = array(
											'type'=>'error',
											'title'=>'Accident code cannot be saved!',
											'body'=>'Please fill title field!'
										);
								  }
							}
							break;
					  }
				}
				break;
				
		  }
		  case 'severity': {
			 
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				
				if (!$id>0) $action = 'list';
				
				if(isset($_GET['action']))
				{
				if($_GET['action'] == 'changestatus') $action = 'changestatus';
				elseif($_GET['action'] == 'showlist') $action = 'showlist';
				}
				
				switch ($action) {
					  default: case 'list': {
							// severity: List
							if(isset($_GET['order']))
							$orderby = $_GET['order'];
							else $orderby = 'default';
							switch ($orderby) {
								case 'id_asc' :
									$order = 'ORDER BY id ASC';
									$smarty->assign('order','id_asc');
									break;
								case 'id_desc' :
									$order = 'ORDER BY id DESC';
									$smarty->assign('order','id_desc');
									break;
								case 'title_asc' :
									$order = 'ORDER BY title ASC';
									$smarty->assign('order','title_asc');
									break;
								case 'title_desc' :
									$order = 'ORDER BY title DESC';
									$smarty->assign('order','title_desc');
									break;
								default :
									$order = 'ORDER BY status ASC, title ASC';
									$smarty->assign('order','');
									break;
							}
							if (isset($_POST['filter']['apply']) || (isset($_GET['searchterm']) && $_GET['searchterm']!=''))
							{
								if (isset($_POST['filter']['apply']))
									$search_term = $_POST['filter']['string'];
								else
									$search_term = trim($_GET['searchterm']);
								
								$list = $db->GetAll("SELECT * FROM triage_severity WHERE title LIKE ".$db->qstr("%".$search_term."%")." ".$order."");
								$smarty->assign('search',$search_term);
							}
							else
							{
								$all = $db->GetOne("SELECT COUNT(*) FROM triage_severity");
								$limit = 25;
								$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
								$list = $db->GetAll("SELECT * FROM triage_severity ".$order." LIMIT ".($paging['current']*$limit).", $limit");
								$smarty->assign('search','');
							}
							$smarty->assign('list', $list);
							$template_to = 'severity_list.tpl';
							break;
					  }
					  case 'changestatus': {
						  
						  if (isset($_POST['selectedvalue'])){
	
								$resvalues = $_POST['selectedvalue'];
								
								if(isset($resvalues)) {
									
									$changedinfo = explode("_", $resvalues); 
									if(($changedinfo[1]!='') && ($changedinfo[0]!=''))
									{
									$stmt = $db->Prepare("UPDATE `triage_severity` SET `status`= '".$changedinfo[1]."' WHERE (`id`=?)");
									$db->Execute($stmt, array($changedinfo[0]));
									echo "1";exit;
									}
									else echo "2";exit;
								
								}
								else echo "2";exit;
							}
							else echo "2";exit;
						  break;
					  }
					  case 'showlist': {
						  
						  if (isset($_GET['term']))
						  {
								$return_arr = array(); 
								$param = $_GET['term'];
								$stmt = $db->Prepare('SELECT `title` FROM `triage_severity` WHERE `title` LIKE CONCAT(?,"%") GROUP BY `title`');
								$result = $db->Execute($stmt, array($param));
								
								while($row = $result->fetchRow()) {
									$return_arr[] =  $row['title'];
								}

								/* Toss back results as json encoded array. */
								echo json_encode($return_arr);exit;
							}
						  exit;
						  break;
					  }
					  case 'edit': {
						// severity: Edit and Preview
						if (isset($_POST['severity']['save'])) {
							  if (mb_strlen($_POST['severity']['title'],"UTF-8")>0) {
									$db->Execute("UPDATE `triage_severity` SET
													  `title` = ".$db->qstr($_POST['severity']['title']).",
													  `status` = ".$db->qstr($_POST['severity']['status'])."
												 WHERE `id` = ".$db->qstr($id));
									$message = array(
										'type'=>'success',
										'title'=>'Severity is saved successfuly!',
										'body'=>'Please check it out in the severity list!'
									);
							  } else {
									$message = array(
										'type'=>'error',
										'title'=>'Severity cannot be saved!',
										'body'=>'Please fill title field !'
									);
							  }
						}
						$smarty->assign('t', $t = $db->GetRow("SELECT * FROM triage_severity WHERE id=".$db->qstr($id)));
						$template_to = 'severity_form.tpl';
						break;
					  }
					  case 'add': {
							$template_to = 'severity_add.tpl';
							if (isset($_POST['severity']['save'])) {
								  if (mb_strlen($_POST['severity']['title'],"UTF-8")>0) {
										$db->Execute("INSERT INTO `triage_severity` SET
														  `title` = ".$db->qstr($_POST['severity']['title']).",
														  `status` = ".$db->qstr($_POST['severity']['status'])."
													 ");
										$message = array(
											  'type'=>'success',
											  'title'=>'Severity is saved successfuly!',
											  'body'=>'Please check it out in the severity list!',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=severity'
										);
										$template_to = 'templates/global/message.tpl';
								  } else {
										$message = array(
											'type'=>'error',
											'title'=>'Severity cannot be saved!',
											'body'=>'Please fill title field!'
										);
								  }
							}
							break;
					  }
				}
				break;
				
		  }
		  case 'guidelines': {
			 
				$action = isset($_GET['action']) ? $_GET['action'] : 'list'; 
				
				if (!$id>0) $action = 'list';
				if(isset($_GET['action']))
				{
				if($_GET['action'] == 'changestatus') $action = 'changestatus';
				elseif($_GET['action'] == 'showlist') $action = 'showlist';
				}
				
				switch ($action) {
					  default: case 'list': {
							// Guideline: List
							//order code
							if(isset($_GET['order']))
							$orderby = $_GET['order'];
							else $orderby = 'default';
							
							switch ($orderby) {
								case 'id_asc' :
									$order = 'ORDER BY id ASC';
									$smarty->assign('order','id_asc');
									break;
								case 'id_desc' :
									$order = 'ORDER BY id DESC';
									$smarty->assign('order','id_desc');
									break;
								case 'title_asc' :
									$order = 'ORDER BY title ASC';
									$smarty->assign('order','title_asc');
									break;
								case 'title_desc' :
									$order = 'ORDER BY title DESC';
									$smarty->assign('order','title_desc');
									break;
								default :
									$order = 'ORDER BY status ASC, title ASC';
									$smarty->assign('order','');
									break;
							}
								
							if (isset($_POST['filter']['apply']) || (isset($_GET['searchterm']) && $_GET['searchterm']!=''))
							{
								if (isset($_POST['filter']['apply']))
									$search_term = $_POST['filter']['string'];
								else
									$search_term = trim($_GET['searchterm']);
								
								$list = $db->GetAll("SELECT * FROM triage_guidelines WHERE title LIKE ".$db->qstr("%".$search_term."%")." ".$order."");
								$smarty->assign('search',$search_term);
							}
							else
							{
								$all = $db->GetOne("SELECT COUNT(*) FROM triage_guidelines");
								$limit = 25;
								$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
								$list = $db->GetAll("SELECT * FROM triage_guidelines ".$order." LIMIT ".($paging['current']*$limit).", $limit");
								$smarty->assign('search','');
							}
							$smarty->assign('list', $list);
							$template_to = 'guidelines_list.tpl';
							break;
					  }
					  
					  case 'changestatus': {
						  
						  if (isset($_POST['selectedvalue'])){
	
								$resvalues = $_POST['selectedvalue'];
								
								if(isset($resvalues)) {
									
									$changedinfo = explode("_", $resvalues); 
									if(($changedinfo[1]!='') && ($changedinfo[0]!=''))
									{
									$stmt = $db->Prepare("UPDATE `triage_guidelines` SET `status`= '".$changedinfo[1]."' WHERE (`id`=?)");
									$db->Execute($stmt, array($changedinfo[0]));
									echo "1";exit;
									}
									else echo "2";exit;
								
								}
								else echo "2";exit;
							}
							else echo "2";exit;
						  break;
					  }
					  case 'showlist': {
						  
						  if (isset($_GET['term']))
						  {
								$return_arr = array(); 
								$param = $_GET['term'];
								$stmt = $db->Prepare('SELECT `title` FROM `triage_guidelines` WHERE `title` LIKE CONCAT(?,"%") GROUP BY `title`');
								$result = $db->Execute($stmt, array($param));
								
								while($row = $result->fetchRow()) {
									$return_arr[] =  $row['title'];
								}

								/* Toss back results as json encoded array. */
								echo json_encode($return_arr);exit;
							}
						  exit;
						  break;
					  }
					  case 'edit': {
						// Guideline: Edit and Preview
						if (isset($_POST['guideline']['save'])) {
							  if (mb_strlen($_POST['guideline']['title'],"UTF-8")>0) {
									$db->Execute("UPDATE `triage_guidelines` SET
													  `title` = ".$db->qstr($_POST['guideline']['title']).",
													  `status` = ".$db->qstr($_POST['guideline']['status'])."
												 WHERE `id` = ".$db->qstr($id));
									$message = array(
										'type'=>'success',
										'title'=>'Guideline is saved successfuly!',
										'body'=>'Please check it out in the guideline list!'
									);
							  } else {
									$message = array(
										'type'=>'error',
										'title'=>'Guideline cannot be saved!',
										'body'=>'Please fill title field!'
									);
							  }
						}
						$smarty->assign('t', $t = $db->GetRow("SELECT * FROM triage_guidelines WHERE id=".$db->qstr($id)));
						$template_to = 'guidelines_form.tpl';
						break;
					  }
					  case 'add': {
							$template_to = 'guidelines_add.tpl';
							if (isset($_POST['guideline']['save'])) {
								  if (mb_strlen($_POST['guideline']['title'],"UTF-8")>0) {
										$db->Execute("INSERT INTO `triage_guidelines` SET
														  `title` = ".$db->qstr($_POST['guideline']['title']).",
														  `status` = ".$db->qstr($_POST['guideline']['status'])."
													 ");
										$message = array(
											  'type'=>'success',
											  'title'=>'Guideline is saved successfuly!',
											  'body'=>'Please check it out in guideline list!',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=guidelines'
										);
										$template_to = 'templates/global/message.tpl';
								  } else {
										$message = array(
											'type'=>'error',
											'title'=>'Guideline cannot be saved!',
											'body'=>'Please fill title field!'
										);
								  }
							}
							break;
					  }
				}
				break;
				
		  }
		  case 'questions': {
			 
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				
				if (!$id>0) $action = 'list';
				
				if(isset($_GET['action']))
				{
				if($_GET['action'] == 'changestatus') $action = 'changestatus';
				elseif($_GET['action'] == 'showlist') $action = 'showlist';
				}
				
				switch ($action) {
					  default: case 'list': {
							// Questions: List
							if(isset($_GET['order']))
								$orderby = $_GET['order'];
							else
								$orderby = "default";
							
							switch ($orderby) {
								case 'id_asc' :
									$order = 'ORDER BY id ASC';
									$smarty->assign('order','id_asc');
									break;
								case 'id_desc' :
									$order = 'ORDER BY id DESC';
									$smarty->assign('order','id_desc');
									break;
								case 'question_asc' :
									$order = 'ORDER BY question ASC';
									$smarty->assign('order','question_asc');
									break;
								case 'question_desc' :
									$order = 'ORDER BY question DESC';
									$smarty->assign('order','question_desc');
									break;
								case 'severity_asc' :
									$order = 'ORDER BY severityval ASC';
									$smarty->assign('order','severity_asc');
									break;
								case 'severity_desc' :
									$order = 'ORDER BY severityval DESC';
									$smarty->assign('order','severity_desc');
									break;
								case 'guideline_asc' :
									$order = 'ORDER BY guidelineval ASC';
									$smarty->assign('order','guideline_asc');
									break;
								case 'guideline_desc' :
									$order = 'ORDER BY guidelineval DESC';
									$smarty->assign('order','guideline_desc');
									break;
								default :
									$order = 'ORDER BY status ASC, guideline_id ASC';
									$smarty->assign('order','');
									break;
							}
								
							if (isset($_POST['filter']['apply']) || (isset($_GET['searchterm']) && $_GET['searchterm']!=''))
							{
								if (isset($_POST['filter']['apply']))
									$search_term = $_POST['filter']['string'];
								else
									$search_term = trim($_GET['searchterm']);
								
								$list = $db->GetAll("SELECT *,(SELECT svr.title FROM triage_severity svr where svr.id = triage_questions.severity) as severityval,(SELECT gdi.title FROM triage_guidelines gdi where gdi.id = triage_questions.guideline_id) as guidelineval FROM triage_questions WHERE question LIKE ".$db->qstr("%".$search_term."%")." ".$order."");
								$smarty->assign('search',$search_term);
							}
							else
							{
								$all = $db->GetOne("SELECT COUNT(*) FROM triage_questions");
								$limit = 25;
								$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
								$list = $db->GetAll("SELECT *,(SELECT svr.title FROM triage_severity svr where svr.id = triage_questions.severity) as severityval,(SELECT gdi.title FROM triage_guidelines gdi where gdi.id = triage_questions.guideline_id) as guidelineval FROM triage_questions ".$order." LIMIT ".($paging['current']*$limit).", $limit");
								$smarty->assign('search',"");
							}
							$smarty->assign('list', $list);
							$template_to = 'questions_list.tpl';
							break;
					  }
					  case 'changestatus': {
						  
						  if (isset($_POST['selectedvalue'])){
	
								$resvalues = $_POST['selectedvalue'];
								
								if(isset($resvalues)) {
									
									$changedinfo = explode("_", $resvalues); 
									if(($changedinfo[1]!='') && ($changedinfo[0]!=''))
									{
									$stmt = $db->Prepare("UPDATE `triage_questions` SET `status`= '".$changedinfo[1]."' WHERE (`id`=?)");
									$db->Execute($stmt, array($changedinfo[0]));
									echo "1";exit;
									}
									else echo "2";exit;
								
								}
								else echo "2";exit;
							}
							else echo "2";exit;
						  break;
					  }
					  case 'showlist': {
						  
						  if (isset($_GET['term']))
						  {
								$return_arr = array(); 
								$param = $_GET['term'];
								$stmt = $db->Prepare('SELECT `question` FROM `triage_questions` WHERE `question` LIKE CONCAT(?,"%") GROUP BY `question`');
								$result = $db->Execute($stmt, array($param));
								
								while($row = $result->fetchRow()) {
									$return_arr[] =  $row['question'];
								}

								/* Toss back results as json encoded array. */
								echo json_encode($return_arr);exit;
							}
						  exit;
						  break;
					  }
					  case 'edit': {
						// Questions: Edit and Preview
						if (isset($_POST['question']['save'])) {
							  if ((mb_strlen($_POST['question']['question'],"UTF-8")>0) && (mb_strlen($_POST['question']['guideline_id'],"UTF-8")>0) && (mb_strlen($_POST['question']['severity'],"UTF-8")>0)) {
									$db->Execute("UPDATE `triage_questions` SET
													  `question` = ".$db->qstr($_POST['question']['question']).",
													  `guideline_id` = ".$db->qstr($_POST['question']['guideline_id']).",
													  `severity` = ".$db->qstr($_POST['question']['severity']).",
													  `status` = ".$db->qstr($_POST['question']['status'])."
												 WHERE `id` = ".$db->qstr($id));
									$message = array(
										'type'=>'success',
										'title'=>'Question is saved successfuly!',
										'body'=>'Please check it out in the questions list!'
									);
							  } else {
									$message = array(
										'type'=>'error',
										'title'=>'Question cannot be saved!',
										'body'=>'Please fill title, severity and guideline fields!'
									);
							  }
						}
						
						$severitylist = $db->GetAll("SELECT * FROM triage_severity WHERE `status` = 'y' ORDER BY title ASC");
						$smarty->assign('severitylist', $severitylist);
						
						$guidelinelist = $db->GetAll("SELECT * FROM triage_guidelines WHERE `status` = 'y' ORDER BY title ASC");
						$smarty->assign('guidelinelist', $guidelinelist);
						
						$smarty->assign('t', $t = $db->GetRow("SELECT * FROM triage_questions WHERE id=".$db->qstr($id)));
						$template_to = 'questions_form.tpl';
						break;
					  }
					  case 'add': {
							$template_to = 'questions_add.tpl';
							
															  
								$severitylist = $db->GetAll("SELECT * FROM triage_severity WHERE `status` = 'y' ORDER BY title ASC");
								$smarty->assign('severitylist', $severitylist);
						
								$guidelinelist = $db->GetAll("SELECT * FROM triage_guidelines WHERE `status` = 'y' ORDER BY title ASC");
								$smarty->assign('guidelinelist', $guidelinelist);
							
							if (isset($_POST['question']['save'])) { 
								  if ((mb_strlen($_POST['question']['question'],"UTF-8")>0) && (mb_strlen($_POST['question']['guideline_id'],"UTF-8")>0) && (mb_strlen($_POST['question']['severity'],"UTF-8")>0)) {
										$db->Execute("INSERT INTO `triage_questions` SET
														  `question` = ".$db->qstr($_POST['question']['question']).",
														  `guideline_id` = ".$db->qstr($_POST['question']['guideline_id']).",
														  `severity` = ".$db->qstr($_POST['question']['severity']).",
														  `status` = ".$db->qstr($_POST['question']['status'])."
													 ");
										$message = array(
											  'type'=>'success',
											  'title'=>'Question is saved successfuly!',
											  'body'=>'Please check it out in the questions list!',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=questions'
										);
										$template_to = 'templates/global/message.tpl';
								  } else {
										$message = array(
											'type'=>'error',
											'title'=>'Question cannot be saved!',
											'body'=>'Please fill title, severity and guideline fields!'
										);
								  }
					
							}
							break;
					  }
				}
				break;
				
		  }
		  case 'advices': {
			 
				$action = isset($_GET['action']) ? $_GET['action'] : 'list';
				
				if (!$id>0) $action = 'list';
				
				if(isset($_GET['action']))
				{
				if($_GET['action'] == 'changestatus') $action = 'changestatus';
				elseif($_GET['action'] == 'showlist') $action = 'showlist';
				}
				
				switch ($action) {
					  default: case 'list': { 
							// Advices : List
							//sort order code
							if(isset($_GET['order']))
								$orderby = $_GET['order'];
							else
								$orderby = 'default';
							
							switch ($orderby) {
								case 'id_asc' :
									$order = 'ORDER BY id ASC';
									$smarty->assign('order','id_asc');
									break;
								case 'id_desc' :
									$order = 'ORDER BY id DESC';
									$smarty->assign('order','id_desc');
									break;
								case 'advice_asc' :
									$order = 'ORDER BY advice ASC';
									$smarty->assign('order','advice_asc');
									break;
								case 'advice_desc' :
									$order = 'ORDER BY advice DESC';
									$smarty->assign('order','advice_desc');
									break;
								case 'severity_asc' :
									$order = 'ORDER BY severityval ASC';
									$smarty->assign('order','severity_asc');
									break;
								case 'severity_desc' :
									$order = 'ORDER BY severityval DESC';
									$smarty->assign('order','severity_desc');
									break;
								case 'guideline_asc' :
									$order = 'ORDER BY guidelineval ASC';
									$smarty->assign('order','guideline_asc');
									break;
								case 'guideline_desc' :
									$order = 'ORDER BY guidelineval DESC';
									$smarty->assign('order','guideline_desc');
									break;
								default :
									$order = 'ORDER BY status ASC, guideline_id ASC';
									$smarty->assign('order','');
									break;
							}
							
							
							
							if (isset($_POST['filter']['apply']) || (isset($_GET['searchterm']) && $_GET['searchterm']!=''))
							{
								if (isset($_POST['filter']['apply']))
									$search_term = $_POST['filter']['string'];
								else
									$search_term = trim($_GET['searchterm']);
								
							$list = $db->GetAll("SELECT *,(SELECT svr.title FROM triage_severity svr where svr.id = triage_advices.severity) as severityval,(SELECT gdi.title FROM triage_guidelines gdi where gdi.id = triage_advices.guideline_id) as guidelineval FROM triage_advices WHERE advice LIKE ".$db->qstr("%".$search_term."%")." ".$order."");
							$smarty->assign('search',$search_term);
						}
						else
						{
							$all = $db->GetOne("SELECT COUNT(*) FROM triage_advices");
							$limit = 25;
							$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
							$list = $db->GetAll("SELECT *,(SELECT svr.title FROM triage_severity svr where svr.id = triage_advices.severity) as severityval,(SELECT gdi.title FROM triage_guidelines gdi where gdi.id = triage_advices.guideline_id) as guidelineval FROM triage_advices ".$order." LIMIT ".($paging['current']*$limit).", $limit");
							$smarty->assign('search',"");
						}
							$smarty->assign('list', $list);
							$template_to = 'advices_list.tpl';
							break;
					  }
					  case 'changestatus': {
						  
						  if (isset($_POST['selectedvalue'])){
	
								$resvalues = $_POST['selectedvalue'];
								
								if(isset($resvalues)) {
									
									$changedinfo = explode("_", $resvalues); 
									if(($changedinfo[1]!='') && ($changedinfo[0]!=''))
									{
									$stmt = $db->Prepare("UPDATE `triage_advices` SET `status`= '".$changedinfo[1]."' WHERE (`id`=?)");
									$db->Execute($stmt, array($changedinfo[0]));
									echo "1";exit;
									}
									else echo "2";exit;
								
								}
								else echo "2";exit;
							}
							else echo "2";exit;
						  break;
					  }
					  case 'showlist': {
						  
						  if (isset($_GET['term']))
						  {
								$return_arr = array(); 
								$param = $_GET['term'];
								$stmt = $db->Prepare('SELECT `advice` FROM `triage_advices` WHERE `advice` LIKE CONCAT(?,"%") GROUP BY `advice`');
								$result = $db->Execute($stmt, array($param));
								
								while($row = $result->fetchRow()) {
									$return_arr[] =  $row['advice'];
								}

								/* Toss back results as json encoded array. */
								echo json_encode($return_arr);exit;
							}
						  exit;
						  break;
					  }
					  case 'edit': {
						// Advices : Edit and Preview
						if (isset($_POST['advice']['save'])) {
							  if ((mb_strlen($_POST['advice']['advice'],"UTF-8")>0) && (mb_strlen($_POST['advice']['guideline_id'],"UTF-8")>0) && (mb_strlen($_POST['advice']['severity'],"UTF-8")>0)) {
									$db->Execute("UPDATE `triage_advices` SET
													      `advice` = ".$db->qstr($_POST['advice']['advice']).",
														  `guideline_id` = ".$db->qstr($_POST['advice']['guideline_id']).",
														  `severity` = ".$db->qstr($_POST['advice']['severity']).",
														  `status` = ".$db->qstr($_POST['advice']['status'])."
												 WHERE `id` = ".$db->qstr($id));
									$message = array(
										'type'=>'success',
										'title'=>'Advice is saved successfuly!',
										'body'=>'Please check it out in the advice list!'
									);
							  } else {
									$message = array(
										'type'=>'error',
										'title'=>'Advice cannot be saved!',
										'body'=>'Please fill title, severity and guideline fields!'
									);
							  }
						}
						
						$severitylist = $db->GetAll("SELECT * FROM triage_severity WHERE `status` = 'y' ORDER BY title ASC");
						$smarty->assign('severitylist', $severitylist);
						
						$guidelinelist = $db->GetAll("SELECT * FROM triage_guidelines WHERE `status` = 'y' ORDER BY title ASC");
						$smarty->assign('guidelinelist', $guidelinelist);
							
						$smarty->assign('t', $t = $db->GetRow("SELECT * FROM triage_advices WHERE id=".$db->qstr($id)));
						$template_to = 'advices_form.tpl';
						break;
					  }
					  case 'add': {
							$template_to = 'advices_add.tpl';
							
							$severitylist = $db->GetAll("SELECT * FROM triage_severity WHERE `status` = 'y' ORDER BY title ASC");
							$smarty->assign('severitylist', $severitylist);
						
							$guidelinelist = $db->GetAll("SELECT * FROM triage_guidelines WHERE `status` = 'y' ORDER BY title ASC");
							$smarty->assign('guidelinelist', $guidelinelist);
								  
								  
							if (isset($_POST['advice']['save'])) {
								  if ((mb_strlen($_POST['advice']['advice'],"UTF-8")>0) && (mb_strlen($_POST['advice']['guideline_id'],"UTF-8")>0) && (mb_strlen($_POST['advice']['severity'],"UTF-8")>0)) {
										$db->Execute("INSERT INTO `triage_advices` SET
														  `advice` = ".$db->qstr($_POST['advice']['advice']).",
														  `guideline_id` = ".$db->qstr($_POST['advice']['guideline_id']).",
														  `severity` = ".$db->qstr($_POST['advice']['severity']).",
														  `status` = ".$db->qstr($_POST['advice']['status'])."
													 ");
										$message = array(
											  'type'=>'success',
											  'title'=>'Advice is saved successfuly!',
											  'body'=>'Please check it out in the advice list!',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=advices'
										);
										$template_to = 'templates/global/message.tpl';
								  } else {
										$message = array(
											'type'=>'error',
											'title'=>'Advice cannot be saved!',
											'body'=>'Please fill title, severity and guideline fields!'
										);
								  }
								  						
							}
							break;
					  }
				}
				break;
				
		  }
		  case 'facilitytype': {
			  
			  $action = isset($_GET['action']) ? $_GET['action'] : 'list';
				
				if (!$id>0) $action = 'list';
				
				if(isset($_GET['action']))
				{
				if($_GET['action'] == 'changestatus') $action = 'changestatus';
				elseif($_GET['action'] == 'showlist') $action = 'showlist';
				}
				
				switch ($action) {
					  default: case 'list': {
							// facilitytype: List
							if(isset($_GET['order']))
							$orderby = $_GET['order'];
							else $orderby = 'default';
							switch ($orderby) {
								case 'id_asc' :
									$order = 'ORDER BY id ASC';
									$smarty->assign('order','id_asc');
									break;
								case 'id_desc' :
									$order = 'ORDER BY id DESC';
									$smarty->assign('order','id_desc');
									break;
								case 'title_asc' :
									$order = 'ORDER BY title ASC';
									$smarty->assign('order','title_asc');
									break;
								case 'title_desc' :
									$order = 'ORDER BY title DESC';
									$smarty->assign('order','title_desc');
									break;
								default :
									$order = 'ORDER BY status ASC, title ASC';
									$smarty->assign('order','');
									break;
							}
							if (isset($_POST['filter']['apply']) || (isset($_GET['searchterm']) && $_GET['searchterm']!=''))
							{
								if (isset($_POST['filter']['apply']))
									$search_term = $_POST['filter']['string'];
								else
									$search_term = trim($_GET['searchterm']);
								
								$list = $db->GetAll("SELECT * FROM triage_facility_type WHERE title LIKE ".$db->qstr("%".$search_term."%")." ".$order."");
								$smarty->assign('search',$search_term);
							}
							else
							{
								$all = $db->GetOne("SELECT COUNT(*) FROM triage_facility_type");
								$limit = 25;
								$smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
								$list = $db->GetAll("SELECT * FROM triage_facility_type ".$order." LIMIT ".($paging['current']*$limit).", $limit");
								$smarty->assign('search','');
							}
							$smarty->assign('list', $list);
							$template_to = 'facilitytype_list.tpl';
							break;
					  }
					  case 'changestatus': {
						  
						  if (isset($_POST['selectedvalue'])){
	
								$resvalues = $_POST['selectedvalue'];
								
								if(isset($resvalues)) {
									
									$changedinfo = explode("_", $resvalues); 
									if(($changedinfo[1]!='') && ($changedinfo[0]!=''))
									{
									$stmt = $db->Prepare("UPDATE `triage_facility_type` SET `status`= '".$changedinfo[1]."' WHERE (`id`=?)");
									$db->Execute($stmt, array($changedinfo[0]));
									echo "1";exit;
									}
									else echo "2";exit;
								
								}
								else echo "2";exit;
							}
							else echo "2";exit;
						  break;
					  }
					  case 'showlist': {
						  
						  if (isset($_GET['term']))
						  {
								$return_arr = array(); 
								$param = $_GET['term'];
								$stmt = $db->Prepare('SELECT `title` FROM `triage_facility_type` WHERE `title` LIKE CONCAT(?,"%") GROUP BY `title`');
								$result = $db->Execute($stmt, array($param));
								
								while($row = $result->fetchRow()) {
									$return_arr[] =  $row['title'];
								}

								/* Toss back results as json encoded array. */
								echo json_encode($return_arr);exit;
							}
						  exit;
						  break;
					  }
					  case 'edit': {
						// facilitytype: Edit and Preview
						if (isset($_POST['facilitytype']['save'])) {
							  if (mb_strlen($_POST['facilitytype']['title'],"UTF-8")>0) {
									$db->Execute("UPDATE `triage_facility_type` SET
													  `title` = ".$db->qstr($_POST['facilitytype']['title']).",
													  `status` = ".$db->qstr($_POST['facilitytype']['status'])."
												 WHERE `id` = ".$db->qstr($id));
									$message = array(
										'type'=>'success',
										'title'=>'Facilitytype is saved successfuly!',
										'body'=>'Please check it out in the facilitytype list!'
									);
							  } else {
									$message = array(
										'type'=>'error',
										'title'=>'Facilitytype cannot be saved!',
										'body'=>'Please fill title field !'
									);
							  }
						}
						$smarty->assign('t', $t = $db->GetRow("SELECT * FROM triage_facility_type WHERE id=".$db->qstr($id)));
						$template_to = 'facilitytype_form.tpl';
						break;
					  }
					  case 'add': {
							$template_to = 'facilitytype_add.tpl';
							if (isset($_POST['facilitytype']['save'])) {
								  if (mb_strlen($_POST['facilitytype']['title'],"UTF-8")>0) {
										$db->Execute("INSERT INTO `triage_facility_type` SET
														  `title` = ".$db->qstr($_POST['facilitytype']['title']).",
														  `status` = ".$db->qstr($_POST['facilitytype']['status'])."
													 ");
										$message = array(
											  'type'=>'success',
											  'title'=>'Facilitytype is saved successfuly!',
											  'body'=>'Please check it out in the facilitytype list!',
											  'redirect'=>1000,
											  'url'=>'/admin/?cat=facilitytype'
										);
										$template_to = 'templates/global/message.tpl';
								  } else {
										$message = array(
											'type'=>'error',
											'title'=>'Facilitytype cannot be saved!',
											'body'=>'Please fill title field!'
										);
								  }
							}
							break;
					  }
				}
				break;
			}
		 
		  ////////////////////// End Added by rambabu /////////////////////
		  case 'mail_send': {
			  $action = isset($_GET['action']) ? $_GET['action'] : 'list';
			  switch ($action) {
				  default: case 'list': {
					  // Registered Users: List
					  $all = $db->GetOne("SELECT COUNT(*) FROM registrations");
					  $limit = 15;
					  $smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
					  $list = $db->GetAll("
						  SELECT COUNT(m.id) AS `messages`, r.* FROM registrations r
							  LEFT JOIN mail_messages m ON m.reg_id = r.id
						  GROUP BY r.id
						  ORDER BY r.registered_at DESC
						  LIMIT ".($paging['current']*$limit).", $limit");
					  $smarty->assign('list', $list);
					  $template_to = 'mail_send_users.tpl';

					  if (isset($_POST['reg']['save'])) {
						  unset($_POST['reg']['save']);
						  unset($_SESSION['mail_send']['reg']);
						  $_SESSION['mail_send']['reg'] = $_POST['reg'];
						  $message = array(
								  'type'=>'success',
								  'title'=>'Потребителите бяха избрани!',
								  'body'=>'Преминаваме към стъпка 2',
								  'redirect'=>1,
								  'url'=>'/admin/?cat=mail_send&action=template'
						  );
						  $smarty->assign('message', $message);
						  $template_to = '../global/message.tpl';
					  }
					  break;
				  }
				  case 'template': {
					  if (isset($_SESSION['mail_send']['reg']) && !empty($_SESSION['mail_send']['reg'])) {
						  $all = $db->GetOne("SELECT COUNT(*) FROM mail_templates WHERE lang_id=".$db->qstr($lang['id']));
						  $limit = 20;
						  $smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
						  $list = $db->GetAll("
							  SELECT * FROM mail_templates WHERE lang_id=".$db->qstr($lang['id'])." ORDER BY `date` DESC
							  LIMIT ".($paging['current']*$limit).", $limit");
						  $smarty->assign('list', $list);
						  $template_to = 'mail_send_template.tpl';
						  if (isset($_POST['template']['save'])) {
							  unset($_POST['template']['save']);
							  unset($_SESSION['mail_send']['template']);
							  $_SESSION['mail_send']['template'] = $_POST['template']['id'];
							  $message = array(
									  'type'=>'success',
									  'title'=>'Темплейта беше избрани!',
									  'body'=>'Преминаваме към стъпка 3',
									  'redirect'=>1,
									  'url'=>'/admin/?cat=mail_send&action=template_edit'
							  );
							  $smarty->assign('message', $message);
							  $template_to = '../global/message.tpl';
						  }
					  } else {
						  $message = array(
								  'type'=>'error',
								  'title'=>'Няма избрани потребители!',
								  'body'=>'Преминаваме към стъпка 1',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=mail_send'
						  );
						  $smarty->assign('message', $message);
						  $template_to = '../global/message.tpl';
					  }
					  break;
				  }
				  case 'template_edit': {
					  if (isset($_SESSION['mail_send']['template']) && !empty($_SESSION['mail_send']['template'])) {
						  if (isset($_POST['mail']['next'])) {
							  $message = array(
									  'type'=>'success',
									  'title'=>'Темплейта беше редактиран!',
									  'body'=>'Преминаваме към стъпка 4',
									  'redirect'=>1,
									  'url'=>'/admin/?cat=mail_send&action=template_preview'
							  );
							  $smarty->assign('message', $message);
							  $template_to = '../global/message.tpl';
						  }
						  $id = $_SESSION['mail_send']['template'];
						  if (isset($_POST['mail']['save'])) {
							  if (mb_strlen($_POST['mail']['template'],"UTF-8")>0) {
									$db->Execute("UPDATE `mail_templates` SET
													  `name` = ".$db->qstr($_POST['mail']['name']).",
													  `template` = ".$db->qstr($_POST['mail']['template']).",
													  `date` = NOW()
												 WHERE `id` = ".$db->qstr($id));
									$message = array(
										  'type'=>'success',
										  'title'=>'Темплейта беше записан успешно!',
										  'body'=>'Моля прегледайте дали изглежда както очаквахте!'
									);
							  } else {
									$message = array(
										  'type'=>'error',
										  'title'=>'Темплейта няма съдържание!',
										  'body'=>'Моля въведете някакво съдържание на темплейта!'
									);
							  }
							  $smarty->assign('message', $message);
						  }
						  if ($id=='new') {
							  // auto create the new template
							  $db->Execute("INSERT INTO mail_templates SET name = 'Нов Темплейт', lang_id=".$db->qstr($lang['id']));
							  $id = $db->Insert_ID();
							  $_SESSION['mail_send']['template'] = $id;
						  }
						  $t = $db->GetRow("SELECT * FROM mail_templates WHERE id=".$db->qstr($id));
						  $first = array_slice($_SESSION['mail_send']['reg'],0);
						  $t['reg_id'] = $first[0];
						  $smarty->assign('t', $t);
						  $smarty->assign('legend', $db->GetRow("SELECT * FROM registrations ORDER BY RAND()"));
						  $template_to = 'mail_send_template_edit.tpl';
					  } else {
						  $message = array(
								  'type'=>'error',
								  'title'=>'Няма избран темплейт!',
								  'body'=>'Преминаваме към стъпка 2',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=template'
						  );
						  $smarty->assign('message', $message);
						  $template_to = '../global/message.tpl';
					  }
					  break;
				  }
				  case 'template_preview': {
					  if (isset($_SESSION['mail_send']['template']) && !empty($_SESSION['mail_send']['template'])) {
						  $id = $_SESSION['mail_send']['template'];
						  $registrations = $_SESSION['mail_send']['reg'];
						  $t = $db->GetRow("SELECT * FROM mail_templates WHERE id=".$db->qstr($id));
						  if ($_POST['mail']['send']) {
							  require_once("libs/mail.functions.v2.php");
							  // prepare messages to be inserted into mail_messages table
							  $from = $db->GetOne("SELECT value FROM vars WHERE name='mail_from'");
							  foreach ($registrations as $r) {
								  $d = $db->GetRow("
									  SELECT r.*, i.value AS `question`
									  FROM registrations r
										  LEFT JOIN interface i ON i.name = CONCAT('secret_question_',r.question) AND i.lang_id=".$db->qstr($lang['id'])."
									  WHERE r.id=".$r);
								  $smarty->assign('message', $m=compileMessage($t['template'], $d));
								  $body = $smarty->fetch("mail/global_template.tpl");
								  if (sendMessage($d['email'], $t['name'], $body, $from)==1) {
									  $db->Execute("
										  INSERT INTO mail_messages SET
										  `reg_id` = ".$d['id'].",
										  `subject` = '".$t['name']."',
										  `body` = ".$db->qstr($body).",
										  `to` = '".$d['email']."',
										  `date` = NOW()
									  ");
									  $sended=true;
								  } else $sended=false;
							  }
							  if ($sended) {
								  $message = array(
									  'type'=>'success',
									  'title'=>'Съобщенията бяха изпратени успешно!',
									  'body'=>'Връщаме се към списъка с потребителите',
									  'redirect'=>1000,
									  'url'=>'/admin/?cat=mail_send'
								  );
							  } else {
								  $message = array(
									  'type'=>'error',
									  'title'=>'Има проблем с изпращането на съобщенията!',
									  'body'=>'Опитайте да ги изпратите отново'
								  );
							  }
							  $smarty->assign('message', $message);
						  }
						  $smarty->assign('r', $db->GetAll("SELECT * FROM registrations WHERE id IN(".implode(',', $registrations).")"));
						  $first = array_slice($_SESSION['mail_send']['reg'],0);
						  $t['reg_id'] = $first[0];
						  $smarty->assign('t', $t);
						  $template_to = 'mail_send_template_preview.tpl';
					  } else {
						  $message = array(
								  'type'=>'error',
								  'title'=>'Няма избран темплейт!',
								  'body'=>'Преминаваме към стъпка 2',
								  'redirect'=>1000,
								  'url'=>'/admin/?cat=template'
						  );
						  $smarty->assign('message', $message);
						  $template_to = '../global/message.tpl';
					  }
					  break;
				  }
			  }
			  break;
		  }
		  case 'mail_archive': {
			  # mCentral Achive
			  $action = isset($_GET['action']) ? $_GET['action'] : 'list';
			  if (!$id>0) $action = 'list';
				  switch ($action) {
					  default: case 'list': {
						  # Messages List
						  if (isset($_POST['filter']['apply'])) {
							  $list = $db->GetAll("
								  SELECT * FROM mail_messages
								  WHERE
									  `".$_POST['filter']['by']."` LIKE ".$db->qstr("%".$_POST['filter']['string']."%")."
								  ORDER BY `date` DESC");
						  } elseif(isset($_GET['reg_id']) && $_GET['reg_id']>0) {
							  $list = $db->GetAll("
								  SELECT * FROM mail_messages
								  WHERE
									  reg_id = ".$db->qstr($_GET['reg_id'])."
								  ORDER BY `date` DESC");
						  } else {
							  $all = $db->GetOne("SELECT COUNT(*) FROM mail_messages");
							  $limit = 20;
							  $smarty->assign('paging', $paging = GetPaging($page_1, $limit, $all, 10));
							  $list = $db->GetAll("
								  SELECT * FROM mail_messages ORDER BY `date` DESC
								  LIMIT ".($paging['current']*$limit).", $limit");
						  }
						  $smarty->assign('list', $list);
						  $template_to = 'mail_archive.tpl';
						  break;
					  }
					  case 'view': {
						  $smarty->assign('id', $id);
						  $template_to = 'mail_archive_view.tpl';
						  break;
					  }
					  case 'preview': {
						  $smarty->assign('noframe', true);
						  $smarty->assign('body', $db->GetOne("SELECT body FROM mail_messages WHERE id=".$db->qstr($id)));
						  $template_to = 'mail_archive_preview.tpl';
						  break;
					  }
					  case 'erase': {
						  $db->Execute("DELETE FROM `mail_messages` WHERE `id`=".$db->qstr($id));
						  $message = array(
							  'type'=>'success',
							  'title'=>'Писмото беше изтрито успешно!',
							  'body'=>'Връщате се към архива на писмата.',
							  'redirect'=>1000,
							  'url'=>'/admin/?cat=mail_archive'
						  );
						  $smarty->assign('message', $message);
						  $template_to = '../global/message.tpl';
						  break;
					  }
			  }
			  break;
		  }
		  case 'administrators': {
			  if ($admin['type']=='administrator') {
				  // потребителят има правата нужни да преглежда, редактира и създава нови администратори
				  $action = isset($_GET['action']) ? $_GET['action'] : 'list';
				  if (!$id>0) $action = 'list';
				  switch ($action) {
					  default: case 'list': {
						  $smarty->assign('list', $db->GetAll("SELECT * FROM administrators ORDER BY `type`, `registered`"));
						  $template_to = 'admins_list.tpl';
						  break;
					  }
					  case 'edit': {
						  if (isset($_POST['admin']['save'])) {
							  // имаме заявка за редакция на администратора
							  $form = $_POST['admin'];
							  // проверяваме дали има смяна на паролата
							  if (!empty($form['password'])) {
								  if ($form['password']==$form['password_confirm']) {
									  $pass=', `password`=SHA1(MD5('.$db->qstr($form['password']).'))';
								  } else {
									  $message = array(
										  'type'=>'error',
										  'title'=>'The password and confirmation don\' match!',
										  'body'=>'Administrator information is saved, but password is NOT changed.'
									  );
									  $pass='';
								  }
							  } else $pass='';
							  $db->Execute("
								  UPDATE `administrators` SET
									  `name`=".$db->qstr($form['name']).",
									  `username`=".$db->qstr($form['username']).",
									  `type`=".$db->qstr($form['type'])."
									  ".$pass."
								  WHERE id = ".$db->qstr($id)."
							  ");
							  if (empty($message)) $message = array(
								  'type'=>'success',
								  'title'=>'Administrator information is saved successfully!',
								  'body'=>'Please check all fields.'
							  );
						  }
						  if (isset($message)) $smarty->assign('message', $message);
						  $smarty->assign('n', $db->GetRow("SELECT * FROM administrators WHERE id = ".$db->qstr($id)));
						  $template_to = 'admins_form.tpl';
						  break;
					  }
					  case 'add': {
						  $template_to = 'admins_add.tpl';
						  if (isset($_POST['admin']['save'])) {
							  // имаме заявка за редакция на администратора
							  $form = $_POST['admin'];
							  if (!empty($form['username']) && !empty($form['password']) && $form['password']==$form['password_confirm']) {
								  // всичко е наред
								  $db->Execute("
									  INSERT INTO `administrators` SET
										  `name`=".$db->qstr($form['name']).",
										  `username`=".$db->qstr($form['username']).",
										  `type`=".$db->qstr($form['type']).",
										  `password`=SHA1(MD5(".$db->qstr($form['password']).")),
										  `registered`=NOW()
								  ");
								  $message = array(
										  'type'=>'success',
										  'title'=>'Administrator is added successfully!',
										  'body'=>'We are going back to the administrators list',
										  'redirect'=>1000,
										  'url'=>'/admin/?cat=administrators'
								  );
								  $template_to = '../global/message.tpl';
							  } else {
								  $message = array(
									  'type'=>'error',
									  'title'=>'the Administrator cannot be added!',
									  'body'=>'Please enter username, and make sure password and confirmation match!!'
								  );
							  }
							  $smarty->assign('n', $form);
						  }
						  if (isset($message)) $smarty->assign('message', $message);
						  break;
					  }
					  case 'erase': {
						  $db->Execute("DELETE FROM `administrators` WHERE `id`=".$db->qstr($id));
						  $message = array(
							  'type'=>'success',
							  'title'=>'Administrator was erased succcessfully!',
							  'body'=>'We are going back to the administrators list',
							  'redirect'=>1000,
							  'url'=>'/admin/?cat=administrators'
						  );
						  $template_to = '../global/message.tpl';
						  break;
					  }
				  }
			  } else {
				  // потребителя няма нужните права
				  $template_to = 'no_rights.tpl';
			  }
			  break;
		  }
		  case 'statistic':{
		  	if(!isset($_POST['stat']['submit'])){
		  		$template_to = 'statistic_date_selector.tpl';
		  	} else {
		  		$start_date = new DateTime($_POST['stat']['start_date']) ;
		  		$end_date = new DateTime($_POST['stat']['end_date']) ;
		  		$smarty->assign('startDate', $_POST['stat']['start_date']) ;
		  		$smarty->assign('endDate', $_POST['stat']['end_date']) ;
		  		// previous month
		  		$this_month = date('m');
		  		$this_year = date('Y');
		  		if($this_month == 1){
		  			$month = 12;
		  			$year = $this_year - 1;
		  		}
		  		else{
		  			$month = $this_month - 1;
		  			$year = $this_year;
		  		}
		  		// we have to prepare tose values, because of MySQL optimizer weakness
		  		$crTypes = $db->GetCol("SELECT DISTINCT `type` FROM `custom_reports`");

		  		//print_r($hierarchy->getLocationsBelow(2));
		  		// found root hierarchy
		  		$query = 'SELECT `id` FROM `hierarchy` WHERE `parent` = 0 LIMIT 1';
		  		$system_id = $db->GetOne($query);
		  		if($system_id > 0){
		  			$query = 'SELECT `id` FROM `hierarchy` WHERE `parent` = "'.$system_id.'" LIMIT 1';
		  			$root_hierarchy = $db->GetOne($query);
		  			if($root_hierarchy > 0){
		  				$query = 'SELECT `id`, `title` FROM `hierarchy` WHERE `parent` = "'.$root_hierarchy.'" ORDER BY `id`';
		  				$locations = $db->GetAll($query);
		  				if(is_array($locations) && count($locations) > 0){
		  					$max_execution = ini_get('max_execution_time');
		  					// set 30 minutes loading timeout
		  					ini_set('max_execution_time', 1800);
		  					//header('Content-type: text/csv');
		  					$tmp_array = array();
		  					$NEWLINE = "\r\n";
		  					$query = 'SELECT `id`, `title` FROM `hierarchy` WHERE `id` = "'.$root_hierarchy.'" LIMIT 1';
		  					$root_location = $db->GetRow($query);
		  					if($root_location){
		  						$root_location['title'] .= ' (TOTAL)';
		  						$locations = array_merge(array(0=>$root_location), $locations);
		  					}
		  					foreach($locations as $key => $value){
		  						if($value['id'] != $root_hierarchy){
		  							$locations_bellow = $hierarchy->getLocationsBelow($value['id']);
		  							if($locations_bellow){
		  								$locations[$key]['locations_str'] = $value['id'] . ','. implode(',', $locations_bellow);
		  							}
		  							else{
		  								$locations[$key]['locations_str'] = $value['id'];
		  							}
		  						}
		  					}
		  					foreach($locations as $key => $value){
		  						if($value['id'] == $root_hierarchy){
		  							// row1
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claims` WHERE `claim_create_timestamp` >= '.$db->DBDate($start_date) .' AND `claim_create_timestamp` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line1'][] = $cnt;
		  							// row2
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claims` WHERE `claim_create_timestamp` >= '.$db->DBDate($start_date) .' AND `claim_create_timestamp` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line2'][] = $cnt;
		  							// row3
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line3'][] = $cnt;
		  							// row4
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 1';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line4'][] = $cnt;
		  							// row5
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 2';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line5'][] = $cnt;
		  							// row6
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 3';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line6'][] = $cnt;
		  							// row7
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 4';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line7'][] = $cnt;
		  							// row8
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 0';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line8'][] = $cnt;
		  							// row9
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `sendas` IN (1, 2)';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line9'][] = $cnt;
		  							// row10
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `sendas` = 3';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line10'][] = $cnt;
		  							// row11
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `sendas` = 4';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line11'][] = $cnt;
		  							// row12
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `contacts` WHERE `created` >= '.$db->DBDate($start_date) .' AND `created` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line12'][] = $cnt;
		  							// row13
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `hierarchy` WHERE `date_added` >= '.$db->DBDate($start_date) .' AND `date_added` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line13'][] = $cnt;
		  							// row14
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `users` WHERE `last_access` >= '.$db->DBDate($start_date) .' AND `last_access` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line14'][] = $cnt;
		  							// row15
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_pdf_files` WHERE `added` >= '.$db->DBDate($start_date) .' AND `added` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line15'][] = $cnt;
		  							// row16
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_pdf_files` WHERE `added` >= '.$db->DBDate($start_date) .' AND `added` <= '.$db->DBDate($end_date).' AND `type` IN (SELECT DISTINCT `id` FROM `forms`)';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line16'][] = $cnt;
		  							// row17
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_pdf_files` WHERE `added` >= '.$db->DBDate($start_date) .' AND `added` <= '.$db->DBDate($end_date).' AND `type` IN ('. implode(',', $crTypes) .')';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line17'][] = $cnt;
		  							continue;
		  						}
		  						else{
		  							// row1
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claims` WHERE `location` IN ('.$value['locations_str'].') AND `claim_create_timestap` >= '.$db->DBDate($start_date) .' AND `claim_create_timestamp` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line1'][] = $cnt;
		  							// row2
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claims` WHERE `location` IN ('.$value['locations_str'].') AND `claim_submit_timestamp` >= '.$db->DBDate($start_date) .' AND `claim_submit_timestamp` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line2'][] = $cnt;
		  							// row3
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `location` IN ('.$value['locations_str'].') AND `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line3'][] = $cnt;
		  							// row4
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `location` IN ('.$value['locations_str'].') AND `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 1';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line4'][] = $cnt;
		  							// row5
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `location` IN ('.$value['locations_str'].') AND `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 2';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line5'][] = $cnt;
		  							// row6
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `location` IN ('.$value['locations_str'].') AND `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 3';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line6'][] = $cnt;
		  							// row7
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `location` IN ('.$value['locations_str'].') AND `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 4';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line7'][] = $cnt;
		  							// row8
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `location` IN ('.$value['locations_str'].') AND `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `status` = 0';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line8'][] = $cnt;
		  							// row9
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `location` IN ('.$value['locations_str'].') AND `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `sendas` IN (1, 2)';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line9'][] = $cnt;
		  							// row10
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `location` IN ('.$value['locations_str'].') AND `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `sendas` = 3';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line10'][] = $cnt;
		  							// row11
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_distribution_log` WHERE `location` IN ('.$value['locations_str'].') AND `date` >= '.$db->DBDate($start_date) .' AND `date` <= '.$db->DBDate($end_date).' AND `sendas` = 4';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line11'][] = $cnt;
		  							// row12
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `contacts` WHERE `locationid` IN ('.$value['locations_str'].') AND `created` >= '.$db->DBDate($start_date) .' AND `created` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line12'][] = $cnt;
		  							// row13
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `hierarchy` WHERE `id` IN ('.$value['locations_str'].') AND `date_added` >= '.$db->DBDate($start_date) .' AND `date_added` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line13'][] = $cnt;
		  							// row14
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `users` WHERE `location` IN ('.$value['locations_str'].') AND `last_access` >= '.$db->DBDate($start_date) .' AND `last_access` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line14'][] = $cnt;
		  							// row15
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_pdf_files` WHERE `location` IN ('.$value['locations_str'].') AND `added` >= '.$db->DBDate($start_date) .' AND `added` <= '.$db->DBDate($end_date);
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line15'][] = $cnt;
		  							// row16
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_pdf_files` WHERE `location` IN ('.$value['locations_str'].') AND `added` >= '.$db->DBDate($start_date) .' AND `added` <= '.$db->DBDate($end_date).' AND `type` IN (SELECT DISTINCT `id` FROM `forms`)';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line16'][] = $cnt;
		  							// row17
		  							$query = 'SELECT COUNT(`id`) AS `cnt` FROM `claim_pdf_files` WHERE `location` IN ('.$value['locations_str'].') AND `added` >= '.$db->DBDate($start_date) .' AND `added` <= '.$db->DBDate($end_date).' AND `type` IN ('. implode(',', $crTypes) .')';
		  							$cnt = $db->GetOne($query);
		  							$tmp_array['line17'][] = $cnt;
		  							continue;
		  						}
		  					}
		  					ini_set('max_execution_time', $max_execution);
		  				}
		  			}
		  		}
		  		if(isset($tmp_array) && count($tmp_array) > 0){
		  			$columns = array();
		  			$columns[] = '';
		  			// generate columns
		  			foreach($locations as $location){
		  				$columns[] = $location['title'];
		  			}
		  			// show statistics
		  			foreach($tmp_array as $key => $value){
		  				switch($key){
		  					case 'line1'	:	$tmp_array['line1'] = array_merge(array('Total Claims Added'), $value);
		  					break;
		  					case 'line2'	:	$tmp_array['line2'] = array_merge(array('Total Claims Submitted'), $value);
		  					break;
		  					case 'line3'	:	$tmp_array['line3'] = array_merge(array('Total Rules Run'), $value);
		  					break;
		  					case 'line4'	:	$tmp_array['line4'] = array_merge(array(' - Total Successes'), $value);
		  					break;
		  					case 'line5'	:	$tmp_array['line5'] = array_merge(array(' - Total Warnings'), $value);
		  					break;
		  					case 'line6'	:	$tmp_array['line6'] = array_merge(array(' - Total Failures'), $value);
		  					break;
		  					case 'line7'	:	$tmp_array['line7'] = array_merge(array(' - Total Skipped'), $value);
		  					break;
		  					case 'line8'	:	$tmp_array['line8'] = array_merge(array(' - Total Unknown'), $value);
		  					break;
		  					case 'line9'	:	$tmp_array['line9'] = array_merge(array(' - Total Emails'), $value);
		  					break;
		  					case 'line10'	:	$tmp_array['line10'] = array_merge(array(' - Total Faxes'), $value);
		  					break;
		  					case 'line11'	:	$tmp_array['line11'] = array_merge(array(' - Total FTP'), $value);
		  					break;
		  					case 'line12'	:	$tmp_array['line12'] = array_merge(array('Total Contacts Added'), $value);
		  					break;
		  					case 'line13'	:	$tmp_array['line13'] = array_merge(array('Total Orgs/Locations Added'), $value);
		  					break;
		  					case 'line14'	:	$tmp_array['line14'] = array_merge(array('Total User Logins'), $value);
		  					break;
		  					case 'line15'	:	$tmp_array['line15'] = array_merge(array('List of Forms Generated'), $value);
		  					break;
		  					case 'line16'	:	$tmp_array['line16'] = array_merge(array(' - State Forms'), $value);
		  					break;
		  					case 'line17'	:	$tmp_array['line17'] = array_merge(array(' - Custom Forms'), $value);
		  					break;
		  				}
		  			}
		  			$smarty->assign('columns', $columns);
		  			$smarty->assign('data', $tmp_array);
		  			if(isset($_GET['display'])){
		  				// just display
		  				$template_to = 'statistic.tpl';
		  			}
		  			else{
		  				// send email
		  				$smarty->assign('email', true);
		  				sendHtmlMessage('info@claimwire.com', 'statistics', $smarty->fetch('statistic.tpl'));
		  			}
		  		}
		  	}
		  	break;
		  }
	}

	if (isset($template_to)) $smarty->assign('template_to', $template_to);
	if (isset($admin['id']) && $admin['id']>0) $smarty->assign('admin', $admin);
	if (isset($message)) $smarty->assign('message', $message);

	$template_to = '_index.tpl';

	if (isset($template_to)) $smarty->display($template_to);
?>