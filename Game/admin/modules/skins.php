<?php
/*
	 *** Custom Skins Module
	 * this module is for visual customization of the site
	 * created: 02.29.2012
	 * updated: 04.24.2012
	 * version: 1.2
*/
	require_once __DIR__.'/../../lib/group.class.php';

	$action = isset($_GET['action']) ? $_GET['action'] : 'list';
	if (!$id>0) $action = 'list';

	$tbl_groups  = 'groups';
	$tbl_terms  = 'groups_terms';
	$tbl_mail_config  = 'mail_config';
	$tbl_mail_templates  = 'mail_templates';
	$tbl_gitems  = 'groups_items';
	$path_slides = '../i/slides/';
	$path_logo   = '../i/logos/';

	switch ($action) {
		default: case 'list': {
			$template_to = 'skins/list.tpl';

			if (isset($_GET['deactivate']) && is_numeric($_GET['deactivate']) && $_GET['deactivate'] >= 0) {
				$db->Execute("UPDATE `$tbl_groups` SET `active`=0 WHERE id=".$_GET['deactivate']);
				$smarty->assign('noframe', true);
				unset($template_to);
				header('Location: index.php?cat=skins');
			} elseif (isset($_GET['activate']) && is_numeric($_GET['activate']) && $_GET['activate'] >= 0) {
				$db->Execute("UPDATE `$tbl_groups` SET `active`=1 WHERE id=".$_GET['activate']);
				$smarty->assign('noframe', true);
				unset($template_to);
				header('Location: index.php?cat=skins');
			}
			$smarty->assign('list', $db->GetAll("SELECT `id`, `ident`, `title`, `active`, `created`, `updated` FROM `$tbl_groups` ORDER BY `active` DESC, `title`"));
			break;
		}
		case 'articles': {
			if (isset($_GET['gitem_id']) && is_numeric($_GET['gitem_id']) && $_GET['gitem_id'] > 0) {
				# we have a request to change groups_item
				$gitem = $_GET['gitem_id'];
				if (isset($_GET['status']) && !empty($_GET['status'])) {
					# we must change the status
					$db->Execute("UPDATE `$tbl_gitems` SET `status`=".$db->qstr($_GET['status'])." WHERE `id` = ".$gitem);
					$message = array(
						'type'=>'success',
						'title'=>'Article Status Changed!',
						'body'=>'You can see the change in the frond end when you re-open the group page.'
					);
				}
			}
			if (isset($_POST['data']['save'])) {
				unset($_POST['data']['save']);
				if (isset($_POST['data']) && !empty($_POST['data']) && is_array($_POST['data'])) {
					foreach ($_POST['data'] as $ident=>$value) {
						$value = trim($value);
						if (!empty($value)) $db->Execute("UPDATE `$tbl_gitems` SET `data` = ".$db->qstr($value)." WHERE `group_id` = ".$id." AND `ident`=".$db->qstr($ident));
					}
					$message = array(
						'type'=>'success',
						'title'=>'All the data fields are saved successfully!',
						'body'=>'You can see the change in the frond end when you re-open the group page.'
					);
				}
			}
			# we are getting the list of the articles under the group
			$list = $db->GetAll("
				SELECT i.ident AS `index`, i.*, IFNULL(t.id,0) AS `texts_id`
				FROM `$tbl_gitems` i
					LEFT JOIN `texts` t ON t.identifier = i.texts_ident AND t.group_id = i.group_id
				WHERE i.`group_id` = ".$id."
				ORDER BY i.type, i.name
			");
			foreach ($list as $key=>$value) $nlist[$key] = $value;
			$list = $nlist;
			unset($nlist);
				# we must check is there any records in `$tbl_gitems` table
				if (isset($list) && is_array($list) && !empty($list)) {
					# everything is alright
				} else {
					# there is no items, we must get the ones from id = 1 and insert them
					$list = $db->GetAssoc("SELECT i.ident as `index`, i.* FROM `$tbl_gitems` i WHERE i.`group_id` = 1");
					foreach ($list as &$item) {
						$db->Execute("
							INSERT INTO `$tbl_gitems` SET
								`group_id` = ".$id.",
								`ident` = ".$db->qstr($item['ident']).",
								`name` = ".$db->qstr($item['name']).",
								`status` = 'default',
								`texts_ident` = ".$db->qstr($item['texts_ident'])."
						");
						$item['status'] = 'default';
					}
				}

			//print '<pre>'; print_r($list); print '</pre>';
			$template_to = 'skins/article.tpl';
			$data = $db->GetRow("SELECT * FROM `$tbl_groups` WHERE id=".$id);
			$smarty->assign('data', $data);
			$smarty->assign('list', $list);
			break;
		}
		case 'terms': {
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
			$default_data = $db->GetAssoc("SELECT term as `index`, value FROM `$tbl_terms` WHERE group_id = 0 ORDER BY `order`");
			$group_data = $db->GetAssoc("SELECT term as `index`, value FROM `$tbl_terms` WHERE group_id = ".$db->qstr($id)." ORDER BY `order`");
			// checking if the group has all of them, if not insert it
			foreach ($default_data as $term=>$replacement) {
				if (!isset($group_data[$term])) {
					$db->Execute("INSERT INTO `$tbl_terms` SET group_id = ".$id.", `term` = ".$db->qstr($term).", `value` = ".$db->qstr($replacement));
					$group_data[$term] = $replacement;
				}
			}

			$smarty->assign('terms', $group_data);
			$template_to = 'skins/terms.tpl';
			$data = $db->GetRow("SELECT * FROM `$tbl_groups` WHERE id=".$id);
			$smarty->assign('data', $data);
			break;
		}
		case 'add': {
			if (isset($_POST['form']['save'])) {
				$data = $_POST['form'];
				$smarty->assign('data', $data);
				
				$data['useSmtp'] = (isset($data['useSmtp']) ? 1 : 0) ;
				$data['useSmtpAuthentication'] = (isset($data['useSmtpAuthentication']) ? 1 : 0) ;
				$data['nopdfInclideAttachments'] = (isset($data['nopdfInclideAttachments']) ? 1 : 0) ;
				$data['pdfInclideAttachments'] = (isset($data['pdfInclideAttachments']) ? 1 : 0) ;
				
				
				if (empty($data['location_id'])){
					$message = array(
							'type'=>'error',
							'title'=>'Location is required field.',
							'body'=>'Choose a location.'
					);
				} elseif (empty($data['logo_file_name'])){
					$message = array(
							'type'=>'error',
							'title'=>'Logo is required field.',
							'body'=>'Choose a logo.'
					);
				} elseif (empty($data['smtpPort']) && $data['useSmtp']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP port is required field.',
							'body'=>'Fill SMTP port field up.'
					);
				} elseif (empty($data['smtpHost']) && $data['useSmtp']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP host is required field.',
							'body'=>'Fill SMTP host field up.'
					);
				} elseif (empty($data['smtpUser']) && $data['useSmtpAuthentication']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP user is required field.',
							'body'=>'Fill SMTP user field up.'
					);
				} elseif (empty($data['smtpPassword']) && $data['useSmtpAuthentication']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP password is required field.',
							'body'=>'Fill SMTP password field up.'
					);
				} elseif (empty($data['smtpRePassword']) && $data['useSmtpAuthentication']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP re-password is required field.',
							'body'=>'Fill SMTP re-password field up.'
					);
				} elseif ($data['smtpRePassword'] !== $data['smtpPassword'] && $data['useSmtpAuthentication']){
					$message = array(
							'type'=>'error',
							'title'=>'Both password don\'t match',
							'body'=>'Correct them.'
					);
				} elseif (!Validator::validEmail($data['nopdfFrom'])){
					$message = array(
							'type'=>'error',
							'title'=>'Invalid e-mail address for field Form (Standard Email - Auto Process)',
							'body'=>'Correct the e-mail address'
					);
				} elseif (!Validator::validEmail($data['nopdfReplyTo'])){
					$message = array(
							'type'=>'error',
							'title'=>'Invalid e-mail address for field Reply (Standard Email - Auto Process)',
							'body'=>'Correct the e-mail address'
					);
				} elseif (empty($data['nopdfSubject'])){
					$message = array(
							'type'=>'error',
							'title'=>'Subject is required  field (Standard Email - Auto Process)',
							'body'=>'Fill the field up'
					);
				} elseif (!Validator::validEmail($data['pdfFrom'])){
					$message = array(
							'type'=>'error',
							'title'=>'Invalid e-mail address for field Form (Standard Email - With PDF)',
							'body'=>'Correct the e-mail address'
					);
				} elseif (!Validator::validEmail($data['pdfReplyTo'])){
					$message = array(
							'type'=>'error',
							'title'=>'Invalid e-mail address for field Reply (Standard Email - With PDF)',
							'body'=>'Correct the e-mail address'
					);
				} elseif (empty($data['pdfSubject'])){
					$message = array(
							'type'=>'error',
							'title'=>'Subject is required  field (Standard Email - With PDF)',
							'body'=>'Fill the field up'
					);
				} elseif (
					isset($data['title']) && mb_strlen($data['title'], "UTF-8") > 0 &&
					isset($data['ident']) && mb_strlen($data['ident'], "UTF-8") > 0
				) {
					// so far, so good
					try {
						$db->BeginTrans() ;
						
						$group = Group::createGroup($data['location_id'], $data['ident'], $data['title'], $data['home_url'], $data['auto_url'], 
							$data['redirect_url'], '', $data['logo_file_name'], '', '', 1, 0, '', $data['ref_prefix'], 0) ;
						
						$smtpConfigId = $group->addSmtpConfig($data['useSmtp'], $data['smtpHost'], $data['smtpPort'], $data['useSmtpAuthentication'], 
								$data['smtpUser'], $data['smtpPassword'], '') ;
						
						// template saving
						
						$sysTemplate = $group->addMailTemplate($data['ident'].' - auto-process-no-pdf', 'Standard Email - Auto Process', $data['nopdfSubject'], $data['mailTemplateNoPdf'], 
									new DateTime(), 'system', '') ;
						
						$standardTemplate = $group->addMailTemplate($data['ident'].' - cc-auto-process-pdf', 'Standard Email - With PDF', $data['pdfSubject'], $data['mailTemplatePdf'],
								new DateTime(), 'standard', '') ;
						
						// mail config saving
						
						$sysMailConfig = $group->addMailConfig(1, $data['ident'].' Email Config without PDF', $data['nopdfFrom'], $data['nopdfReplyTo'], $sysTemplate, 
								$data['nopdfInclideAttachments'], '');
						
						$standardMailConfig = $group->addMailConfig(1, $data['ident'].' Email Config with PDF', $data['pdfFrom'], $data['pdfReplyTo'], $standardTemplate,
								$data['pdfInclideAttachments'], '');
						
						$group->setMailConfigId($standardMailConfig) ;
						
						// set mail config in hierarchy
						$h = new Hierarchy() ;
						$h->setMailConfig($data['location_id'], $smtpConfigId, $standardMailConfig, $sysMailConfig) ;
						
						$db->CommitTrans() ;
						
						$smarty->assign('noframe', true);
						unset($template_to);
						$groupData = $group->getGroupData() ;
						header('Location: index.php?cat=skins&action=edit&id='.$groupData['id']);
					} catch (Exception $e) {
						error_log(json_encode($e));
						$db->RollbackTrans() ;
						$message = array(
							'type'=>'error',
							'title'=>'Cannot add this group!',
							'body'=>'This `identifier` is already used, please try another one!'
						);
					}
				} else {
					$message = array(
						'type'=>'error',
						'title'=>'Cannot add this group!',
						'body'=>'Please fill up the `title` and `identifier` fields!'
					);
				}
				
				if(is_array($message) && $message['type'] === 'error'){
					$smarty->assign('pst', $data) ;
				}
				
			} else {
				// show form
				$data = array();
				$data['nopdfSubject'] = Group::mailSubjectNoPdf;
				$data['mailTemplateNoPdf'] = Group::mailTemplateNoPdf;
				
				$data['pdfSubject'] = Group::mailSubjectPdf;
				$data['mailTemplatePdf'] = Group::mailTemplatePdf;
				
				$smarty->assign('data', $data) ;
			}
			$template_to = 'skins/add.tpl';
			break;
		}
		case 'skin': {
			$template_to = 'skins/skin.tpl';
			if (isset($_POST['form']['save'])) {
				unset($_POST['form']['save']);
				$post = $_POST['form'];
				$update_slides = false;
				$update_logo = false;

				if (isset($_FILES)) {
					$files = $_FILES;
					if (isset($files['slide']['name']) && is_array($files['slide']['name'])) {
						$data = $db->GetRow("SELECT * FROM `$tbl_groups` WHERE id=".$id);
						$slides = @json_decode($data['slide_files'],true);
						foreach ($files['slide']['name'] as $key=>$slide) {
							if (isset($files['slide']['error'][$key]) && $files['slide']['error'][$key]==0) {
								if (move_uploaded_file($files['slide']['tmp_name'][$key], $path_slides.$slide)) {
									if (count($slides)<5) {
										$slides[] = $slide;
										$update_slides = true;
									}
								}
							}
						}
					}
					if (isset($files['logo']['name']) && $files['logo']['error']==0) {
						if (move_uploaded_file($files['logo']['tmp_name'], $path_logo.$files['logo']['name'])) {
							$logo = $files['logo']['name'];
							$update_logo = true;
						}
					}
				}

				$db->Execute("
					UPDATE `$tbl_groups` SET
						`skin` = ".$db->qstr(@json_encode($post)).",
						`updated` = UNIX_TIMESTAMP()
						".($update_slides ? ", `slide_files` = ".$db->qstr(@json_encode($slides)) : "")."
						".($update_logo ? ", `logo_file` = ".$db->qstr($logo) : "")."
					WHERE `id` = ".$id
				);
			}

			if (isset($_GET['remove_slide']) && is_numeric($_GET['remove_slide']) && $_GET['remove_slide'] >= 0) {
				$slide_index = $_GET['remove_slide'];
				$data = $db->GetRow("SELECT * FROM `$tbl_groups` WHERE id = ".$id);
				$slides = @json_decode($data['slide_files'], true);
				@array_splice($slides, $slide_index, 1);

				$db->Execute("
					UPDATE `$tbl_groups` SET
						`updated` = UNIX_TIMESTAMP(),
						`slide_files` = ".$db->qstr(@json_encode($slides))."
					WHERE `id` = ".$id
				);
				$smarty->assign('noframe', true);
				unset($template_to);
				header('Location: index.php?cat=skins&action=edit&id='.$id);

			}
			if (isset($_GET['remove_logo']) && $_GET['remove_logo']=='true') {
				$db->Execute("
					UPDATE `$tbl_groups` SET
						`updated` = UNIX_TIMESTAMP(),
						`logo_file` = ''
					WHERE `id` = ".$id
				);
				$smarty->assign('noframe', true);
				unset($template_to);
				header('Location: index.php?cat=skins&action=edit&id='.$id);
			}
			$data = $db->GetRow("SELECT * FROM `$tbl_groups` WHERE id=".$id);
			$data['skin'] = @json_decode($data['skin'],true);
			$data['slide_files'] = @json_decode($data['slide_files'],true);
			$smarty->assign('data', $data);
			break;
		}
		case 'edit': {
			$template_to = 'skins/edit.tpl';
			$data = $db->GetRow("SELECT * FROM `$tbl_groups` WHERE id=".$id);
			if (isset($_POST['form']['save'])) {
				$data = $_POST['form'];
				$data['id'] = $id;
				if (
					isset($data['title']) && mb_strlen($data['title'], "UTF-8") > 0 &&
					isset($data['ident']) && mb_strlen($data['ident'], "UTF-8") > 0
				) {
					// so far, so good
					$check = $db->GetOne("SELECT `id` FROM `$tbl_groups` WHERE `ident` = ".$db->qstr($data['ident'])." AND `id`!=".$id);
					if (!$check) {
						// we have title and ident, and the ident is unique
						// saving the group
						$db->Execute("
							UPDATE `$tbl_groups` SET
								`title` = ".$db->qstr($data['title']).",
								`ident` = ".$db->qstr($data['ident']).",
								`title` = ".$db->qstr($data['title']).",
								`home_url` = ".$db->qstr($data['home_url']).",
								`auto_url` = ".$db->qstr($data['auto_url']).",
								`redirect_url` = ".$db->qstr($data['redirect_url']).",
								`ref_prefix` = ".$db->qstr($data['ref_prefix']).",
								`updated` = UNIX_TIMESTAMP()
							WHERE `id` = ".$id."
						");
						$message = array(
							'type'=>'success',
							'title'=>'Group Data Saved!',
							'body'=>'Maybe you will like to change the group skin or the articles!'
						);
					} else {
						$message = array(
							'type'=>'error',
							'title'=>'Cannot add this group!',
							'body'=>'This `identifier` is already used, please try another one!'
						);
					}
				} else {
					$message = array(
						'type'=>'error',
						'title'=>'Cannot add this group!',
						'body'=>'Please fill up the `title` and `identifier` fields!'
					);
				}
			}
			$smarty->assign('data', $data);
			break;
		}
		case 'erase': {
			$db->Execute("DELETE FROM `$tbl_groups` WHERE id=".$id);
			$smarty->assign('noframe', true);
			unset($template_to);
			header('Location: index.php?cat=skins');
			break;
		}

		case 'email': {
			$template_to = 'skins/email.tpl';
			if(empty($id)) redirect('/admin/?cat=skins');

			#$db->debug=1;
			if(!empty($_POST['form']['group']['mail_config_id'])){
				$db->Execute("UPDATE `$tbl_groups` SET `mail_config_id` = ".$db->qstr($_POST['form']['group']['mail_config_id']).",`use_mail_template` = ".$db->qstr($_POST['form']['group']['use_mail_template']).",`email_admins` = ".$db->qstr($_POST['form']['group']['email_admins'])." WHERE `id` = ".$id);
				$message = array(
						'type'=>'success',
						'title'=>'Group Data Saved!',
						'body'=>'Maybe you will like to change the group skin or the articles!'
				);
			}

			$import_errors_list = array(
			0=>'Any Message',
			1=>'Unable to distribute claim',
			2=>'No `state` defined for location',
			3=>'Unable to insert claim',
			4=>'No matching location code found',
			5=>'Malformed XML; multiple claim records found',
			6=>'Malformed XML; no claim section found',
			7=>'Malformed XML; file was empty or missing',
			8=>'General error during claim import');

			$import_organizations_errors_list = array(
			0=>'Any Message',
			1=>'Invalid file format or unable to parse XML file');

			#$db->debug=1;
			#insert RD
			if(!empty($_POST['form']['rd']['add'])) foreach ($_POST['form']['rd']['add'] as $k => $v){
				$stmt = $db->Prepare("INSERT INTO `groups_notifications` SET `type`=?, `status`=?, `message`=?, `email_template`=?, `active`=?, `send_to`=?, `group_id`=?");
				$db->Execute($stmt, array('rd', $v['status'], $v['message'], $v['email_template'], $v['active'], $v['send_to'], $id));
				#print_r($v);
			}

			#update RD
			if(!empty($_POST['form']['rd']['update'])) foreach ($_POST['form']['rd']['update'] as $k => $v){
				$stmt = $db->Prepare("UPDATE `groups_notifications` SET `status`=?, `message`=?, `email_template`=?, `active`=?, `send_to`=? WHERE `id`=?");
				$db->Execute($stmt, array($v['status'], $v['message'], $v['email_template'], $v['active'], $v['send_to'], $k));
				#print_r($v);
			}

			#delete RD
			if(!empty($_POST['form']['rd']['delete'])) foreach ($_POST['form']['rd']['delete'] as $v){
				$stmt = $db->Prepare("DELETE FROM `groups_notifications` WHERE `id`=?");
				$db->Execute($stmt, array($v));
			}

			#insert CIF
			if(!empty($_POST['form']['cif']['add'])) foreach ($_POST['form']['cif']['add'] as $k => $v){
				$stmt = $db->Prepare("INSERT INTO `groups_notifications` SET `type`=?, `message`=?, `email_template`=?, `active`=?, `send_to`=?, `group_id`=?");
				$db->Execute($stmt, array('cif', $v['message'], $v['email_template'], $v['active'], $v['send_to'], $id));
				#print_r($v);
			}

			#update CIF
			if(!empty($_POST['form']['cif']['update'])) foreach ($_POST['form']['cif']['update'] as $k => $v){
				$stmt = $db->Prepare("UPDATE `groups_notifications` SET `message`=?, `email_template`=?, `active`=?, `send_to`=? WHERE `id`=?");
				$db->Execute($stmt, array($v['message'], $v['email_template'], $v['active'], $v['send_to'], $k));
				#print_r($v);
			}

			#delete CIF
			if(!empty($_POST['form']['cif']['delete'])) foreach ($_POST['form']['cif']['delete'] as $v){
				$stmt = $db->Prepare("DELETE FROM `groups_notifications` WHERE `id`=?");
				$db->Execute($stmt, array($v));
			}

			#insert OIF
			if(!empty($_POST['form']['oif']['add'])) foreach ($_POST['form']['oif']['add'] as $k => $v){
				$stmt = $db->Prepare("INSERT INTO `groups_notifications` SET `type`=?, `message`=?, `email_template`=?, `active`=?, `send_to`=?, `group_id`=?");
				$db->Execute($stmt, array('oif', $v['message'], $v['email_template'], $v['active'], $v['send_to'], $id));
				#print_r($v);
			}

			#update OIF
			if(!empty($_POST['form']['oif']['update'])) foreach ($_POST['form']['oif']['update'] as $k => $v){
				$stmt = $db->Prepare("UPDATE `groups_notifications` SET `message`=?, `email_template`=?, `active`=?, `send_to`=? WHERE `id`=?");
				$db->Execute($stmt, array($v['message'], $v['email_template'], $v['active'], $v['send_to'], $k));
				#print_r($v);
			}

			#delete OIF
			if(!empty($_POST['form']['oif']['delete'])) foreach ($_POST['form']['oif']['delete'] as $v){
				$stmt = $db->Prepare("DELETE FROM `groups_notifications` WHERE `id`=?");
				$db->Execute($stmt, array($v));
			}

			$group_data = $db->GetRow("SELECT * FROM `$tbl_groups` WHERE id=".$id);
			$smarty->assign('url', $_SERVER['REQUEST_URI']);
			$smarty->assign('rd', $db->GetAll("SELECT * FROM `groups_notifications` WHERE `type`='rd' AND `group_id`={$group_data['id']} ORDER BY `id` ASC"));
			$smarty->assign('cif', $db->GetAll("SELECT * FROM `groups_notifications` WHERE `type`='cif' AND `group_id`={$group_data['id']} ORDER BY `id` ASC"));
			$smarty->assign('oif', $db->GetAll("SELECT * FROM `groups_notifications` WHERE `type`='oif' AND `group_id`={$group_data['id']} ORDER BY `id` ASC"));
			$smarty->assign('import_errors_list', $import_errors_list);
			$smarty->assign('import_organizations_errors_list', $import_organizations_errors_list);
			$smarty->assign('claim_distribution_log_messages', array(0=>'Any Message')+$account->getJsonSnippet('claim_distribution_log_messages'));
			$smarty->assign('claim_distribution_log_status', $account->getJsonSnippet('claim_distribution_log_status'));
			$smarty->assign('group', $group_data);
			$smarty->assign('mail_config_list', $db->GetAll("SELECT * FROM `$tbl_mail_config` ORDER BY `name` ASC"));
			$smarty->assign('templates_list', $db->GetAll("SELECT * FROM `$tbl_mail_templates` ORDER BY `name` ASC"));

			break;
		}
		
		case 'advanced': {
			$template_to = 'skins/advanced_config.tpl' ;
			if(isset($_POST['form'])){
				$data = $_POST['form'];
				
				$data['useSmtp'] = (isset($data['use_smtp']) ? 1 : 0) ;
				$data['useSmtpAuthentication'] = (isset($data['use_smtp_authentication']) ? 1 : 0) ;
				$data['nopdfInclideAttachments'] = (isset($data['nopdfInclideAttachments']) ? 1 : 0) ;
				$data['pdfInclideAttachments'] = (isset($data['pdfInclideAttachments']) ? 1 : 0) ;
				
				
				if (empty($data['location_id'])){
					$message = array(
							'type'=>'error',
							'title'=>'Location is required field.',
							'body'=>'Choose a location.'
					);
				} elseif (empty($data['logo_file_name'])){
					$message = array(
							'type'=>'error',
							'title'=>'Logo is required field.',
							'body'=>'Choose a logo.'
					);
				} elseif (empty($data['smtpPort']) && $data['useSmtp']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP port is required field.',
							'body'=>'Fill SMTP port field up.'
					);
				} elseif (empty($data['smtpHost']) && $data['useSmtp']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP host is required field.',
							'body'=>'Fill SMTP host field up.'
					);
				} elseif (empty($data['smtpUser']) && $data['useSmtpAuthentication']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP user is required field.',
							'body'=>'Fill SMTP user field up.'
					);
				} elseif (empty($data['smtpPassword']) && $data['useSmtpAuthentication']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP password is required field.',
							'body'=>'Fill SMTP password field up.'
					);
				} elseif (empty($data['smtpRePassword']) && $data['useSmtpAuthentication']){
					$message = array(
							'type'=>'error',
							'title'=>'SMTP re-password is required field.',
							'body'=>'Fill SMTP re-password field up.'
					);
				} elseif ($data['smtpRePassword'] !== $data['smtpPassword'] && $data['useSmtpAuthentication']){
					$message = array(
							'type'=>'error',
							'title'=>'Both password don\'t match',
							'body'=>'Correct them.'
					);
				} elseif (!Validator::validEmail($data['nopdfFrom'])){
					$message = array(
							'type'=>'error',
							'title'=>'Invalid e-mail address for field Form (Standard Email - Auto Process)',
							'body'=>'Correct the e-mail address'
					);
				} elseif (!Validator::validEmail($data['nopdfReplyTo'])){
					$message = array(
							'type'=>'error',
							'title'=>'Invalid e-mail address for field Reply (Standard Email - Auto Process)',
							'body'=>'Correct the e-mail address'
					);
				} elseif (empty($data['nopdfSubject'])){
					$message = array(
							'type'=>'error',
							'title'=>'Subject is required  field (Standard Email - Auto Process)',
							'body'=>'Fill the field up'
					);
				} elseif (!Validator::validEmail($data['pdfFrom'])){
					$message = array(
							'type'=>'error',
							'title'=>'Invalid e-mail address for field Form (Standard Email - With PDF)',
							'body'=>'Correct the e-mail address'
					);
				} elseif (!Validator::validEmail($data['pdfReplyTo'])){
					$message = array(
							'type'=>'error',
							'title'=>'Invalid e-mail address for field Reply (Standard Email - With PDF)',
							'body'=>'Correct the e-mail address'
					);
				} elseif (empty($data['pdfSubject'])){
					$message = array(
							'type'=>'error',
							'title'=>'Subject is required  field (Standard Email - With PDF)',
							'body'=>'Fill the field up'
					);
				} else {
					// so far, so good
					try {
						$db->BeginTrans() ;
				
						$group = new Group($id) ;
						$groupData = $group->getGroupData() ;
						
						$group->updateGroup($data['location_id'], $groupData['ident'], $groupData['title'], $groupData['home_url'], $groupData['auto_url'],
									$groupData['redirect_url'], $groupData['skin'], $data['logo_file_name'], $groupData['css_file'], $groupData['slide_files'], 
									$groupData['use_mail_template'], $groupData['mail_config_id'], $groupData['email_admins'], $groupData['ref_prefix'], $groupData['active']) ;
				
						$h = new Hierarchy() ;
						$hData = $h->getLocationData($groupData['location_id']) ;
						$group->updateSmtpConfig($hData['smtp_config_id'], $data['useSmtp'], $data['smtpHost'], $data['smtpPort'], $data['useSmtpAuthentication'],
								$data['smtpUser'], $data['smtpPassword'], '') ;
				
						// template saving
				
						$nopdfMailConfig = $h->getMailconfig($hData['froi_link_mail_config_id']) ;
						$nopdfMailTemplate = $h->getMailTemplateById($nopdfMailConfig['mail_template_id']) ;
						
						$group->updateMailTemplate($nopdfMailTemplate['id'], $nopdfMailTemplate['identifier'], $nopdfMailTemplate['name'], $data['nopdfSubject'], $data['mailTemplateNoPdf'],
								new DateTime(), $nopdfMailTemplate['type'], $nopdfMailTemplate['desc']) ;
				
						$pdfMailConfig = $h->getMailconfig($hData['mail_config_id']) ;
						$pdfMailTemplate = $h->getMailTemplateById($pdfMailConfig['mail_template_id']) ;
						
						$group->updateMailTemplate($pdfMailTemplate['id'], $pdfMailTemplate['identifier'], $pdfMailTemplate['name'], $data['pdfSubject'], $data['mailTemplatePdf'],
								new DateTime(), $pdfMailTemplate['type'], $pdfMailTemplate['desc']) ;
				
						// mail config saving
				
						$group->updateMailConfig($nopdfMailConfig['id'], $nopdfMailConfig['use_mail_template'], $nopdfMailConfig['name'], $data['nopdfFrom'], $data['nopdfReplyTo'], $nopdfMailTemplate['id'],
								$data['nopdfInclideAttachments'], $nopdfMailConfig['memo']);
				
						$group->updateMailConfig($pdfMailConfig['id'], $pdfMailConfig['use_mail_template'], $pdfMailConfig['name'], $data['pdfFrom'], $data['pdfReplyTo'], $pdfMailTemplate['id'],
								$data['pdfInclideAttachments'], $pdfMailConfig['memo']);
				
						$db->CommitTrans() ;
				
						$smarty->assign('noframe', true);
						unset($template_to);
						$groupData = $group->getGroupData() ;
						$memcache->flush();
						header('Location: index.php?cat=skins&action=edit&id='.$groupData['id']);
					} catch (Exception $e) {
						error_log(json_encode($e));
						$db->RollbackTrans() ;
						$message = array(
								'type'=>'error',
								'title'=>'Could not update this group!',
								'body'=>''
						);
					}
				}
				
				if(isset($message) && is_array($message) && $message['type'] === 'error'){
					$smarty->assign('pst', $data) ;
				}
				
			} else {
				// show the form
				$group = new Group($id) ;
				$smarty->assign('group', $group->getGroupData()) ;
				$h = new Hierarchy() ;
				$groupData = $group->getGroupData() ;
				$location = $h->getLocationData($groupData['location_id']) ;
				$smarty->assign('location', $location) ;
				$smtpConfig = $h->getSMTPconfig($location['smtp_config_id']) ;
				$smarty->assign('smtpConfig', $smtpConfig) ;
				
				$pdfMailConfig = $h->getMailconfig($location['mail_config_id']) ;
				$pdfMailTemplate = $h->getMailTemplateById($pdfMailConfig['mail_template_id']);
				$smarty->assign('pdfMailConfig', $pdfMailConfig) ;
				$smarty->assign('pdfMailTemplate', $pdfMailTemplate) ;
				
				$nopdfMailConfig = $h->getMailconfig($location['froi_link_mail_config_id']) ;
				$nopdfMailTemplate = $h->getMailTemplateById($nopdfMailConfig['mail_template_id']);
				$smarty->assign('nopdfMailConfig', $nopdfMailConfig) ;
				$smarty->assign('nopdfMailTemplate', $nopdfMailTemplate) ;
			}
			
			break ;
		}
	}

	function validateMultiEmails($emails){

	}
?>