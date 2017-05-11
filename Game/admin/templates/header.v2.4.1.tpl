<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/2001/REC-xhtml11-20010531/DTD/xhtml11-flat.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>TriageNow :: Administrative Panel</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="description" content="{$page.description|default:'...'}" />
    <meta name="keywords" content="{$page.keywords|default:'...'}" />
    <meta name="distribution" content="global" />
    <link rel="icon" type="image/gif" href="/favicon.gif" />

    <link rel="stylesheet/less" href="css/global.css" type="text/css" />
    <link rel="stylesheet" href="css/admin.v2.4.1.css?version=1" type="text/css" />
	<link rel="stylesheet" href="css/smoothness/jquery-ui-1.8.5.custom.css" type="text/css" />
	<link rel="stylesheet" href="css/chosen.css" type="text/css" />
	<link rel="stylesheet" href="../css/jsonSuggest.css" type="text/css" />
	<link rel="stylesheet" href="css/select2.css" type="text/css" />
	<link rel="stylesheet" href="../css/colorbox.css" type="text/css" />
	<link rel="stylesheet" href="css/humanity/jquery-ui-1.10.4.custom.min.css" type="text/css" />
	<link rel="stylesheet" href="/css/fileuploader.css" type="text/css" />
	
	<script type="text/javascript" src="/js/jquery-2.1.1.min.js"></script>
	<script type="text/javascript" src="js/chosen.jquery.min.js"></script>
    <script type="text/javascript" src="/js/jquery.jsonSuggest.js"></script>
	<script type="text/javascript" src="../js/jquery.colorbox.js"></script>
    <script type="text/javascript" src="js/global.functions.js"></script>
    <script type="text/javascript" src="js/select2.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="/js/less-1.7.3.min.js"></script>
    <script type="text/javascript" src="/admin/js/tree.js"></script>
    <script type="text/javascript" src="/js/fileuploader.js"></script>
    
    
	{if $smarty.get.cat=='skins'}
		<link rel="stylesheet" href="css/colorpicker.css" type="text/css" />
		{if $smarty.get.id>0}
			<link rel="stylesheet" href="../css/base_v2_preview.css" type="text/css" />
			<link rel="stylesheet" href="../css.php?id={$smarty.get.id}&preview=true" type="text/css" />
			<script type="text/javascript" src="../js/jquery.cycle.all.js"></script>
		{/if}
	{/if}
	
	{*<script type="text/javascript" src="../js/jquery.colorbox.js"></script><link rel="stylesheet" href="../css/colorbox.css" type="text/css" />*}
	
    <!--[if lte IE 6]>
    <link rel="stylesheet" href="css/admin.v2.4.ie.css?version=1" type="text/css" media="screen" title="IE Hacks" charset="utf-8" />
    <![endif]-->
</head>
<body>
    <div id="frame">
	<div id="header">
	    <div class="buttons">
		{if $admin}
		<a href="?cat=home&amp;action=logout"><strong>{$admin.name}</strong> Log-out</a>
		{else}
		<a href="./">Log-in</a>
		{/if}
		<a href="/" target="_blank"><img src="interface/favicon.png" height="22" alt="favicon" align="absmiddle" /> Front End</a>
	    </div>
	</div>
	{if $admin.type=='administrator' || $admin.type=='manager'}
	<div id="menu">
	    <h4>Sections</h4>
	    <p class="sec">
			<strong>Text Pages</strong><br />
			<a href="?cat=texts&filter=home"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Home page</a><br />
			<a href="?cat=texts&filter=account"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Account</a><br />
			<a href="?cat=texts&filter=about"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> About</a><br />
			<a href="?cat=texts&filter=hints"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Hints</a><br />
			<a href="?cat=texts&filter=news"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> News</a><br />
			<a href="?cat=texts&filter=solutions"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Solutions</a><br />
			<a href="?cat=texts&filter=case_studies"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Case Studies</a><br />
			<a href="?cat=texts&filter=stateforms"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> State Forms</a><br />
			<a href="?cat=texts&filter=recent_claims"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Recent Claims</a><br />
			<a href="?cat=texts&filter=contact"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Contact Us</a><br />
			<a href="?cat=texts&filter=terms"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Terms of Use</a><br />
			<a href="?cat=texts&filter=privacy_policy"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Privacy Policy</a><br />
		</p>
		<p class="sec">
			<strong>Statistic Pages</strong><br />
			<a href="?cat=statistic&display"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Statistic page</a><br />
		</p>
		<p class="sec">
			<strong>Claim Forms / JRXML's</strong><br />
			<a href="?cat=forms"><img src="interface/icons/xml_icon.png" alt="edit" height="16" align="absmiddle" /> UI Forms And Reports</a><br />
			<a href="?cat=forms&action=editformula&id=1"><img src="interface/icons/xml_icon.png" height="16" alt="edit" align="absmiddle" /> JRXML/PHP formulas</a><br />
			<a href="?cat=forms&action=generate"><img src="interface/icons/report.gif" height="16" alt="edit" align="absmiddle" style="position:relative; top: 2px;" /> Generate Report</a><br />
			<a href="?cat=forms&action=generate-error-log"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Error Log</a><br />
			<a href="?cat=forms&action=sendmail-error-log"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Sendmail error Log</a><br />
			<!--
			<a href="?cat=texts&filter=service"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> Services</a><br />
			<a href="?cat=texts&action=edit&id=11&filter=faq"><img src="interface/icons/two-docs.gif" alt="edit" align="absmiddle" /> FAQ</a><br />
			 -->
		</p>
		<p class="sec">
			<strong>Server</strong><br />
			<a href="?cat=server&action=force_dist_queue"><img src="interface/icons/linux.png" alt="edit" height="16" align="absmiddle" /> Force Distribution Queue</a><br />
			{if $domain_name!="my.triagenow.net"}
				<a href="javascript:alert('This functionality is only available at my.triagenow.net');" style="color: #777;"><img src="interface/icons/linux.png" height="16" alt="edit" align="absmiddle" /> Force FTP Upload</a><br />
			{else}
				<a href="?cat=server&action=force_ftp_upload"><img src="interface/icons/linux.png" height="16" alt="edit" align="absmiddle" /> Force FTP Upload</a><br />
			{/if}
			<a href="?cat=server&action=flush_memcached"><img src="interface/icons/linux.png" height="16" alt="edit" align="absmiddle" /> Flush Memory Cache</a><br />
		</p>
		<p class="sec">
			<strong>Mail Notifications</strong><br />
			<a href="?cat=mail_templates"><img src="interface/icons/mail.gif" height="16" alt="edit" align="absmiddle" /> Mail Templates</a><br />
			<a href="?cat=mail_archive"><img src="interface/icons/mail.gif" height="16" alt="edit" align="absmiddle" /> Mail Archive</a>
		</p>
	    <p class="sec">
			<strong>Settings</strong><br />
			<a href="?cat=graphs"><img src="interface/icons/graph.png" alt="icon" align="absmiddle" /> Graphs </a><br />
			<a href="?cat=skins"><img src="interface/icons/skins.gif" alt="icon" align="absmiddle" /> Groups and Skins</a><br />
			<a href="?cat=pages"><img src="interface/icons/database.gif" alt="pages" align="absmiddle" /> Meta Data (SЕО)</a><br />
			{*<a href="?cat=mail_settings">Notifications Settings</a><br />*}
			<a href="?cat=administrators"><img src="interface/icons/user.gif" alt="users" align="absmiddle" /> Administrators</a><br />
			<a href="?cat=triage_queue"><img src="interface/icons/open-folder.gif" alt="users" align="absmiddle" /> Triage Queue </a><br />
	    </p>
		<p class="sec">
			<strong>Medical Guidelines</strong><br />
			<a href="?cat=facilitytype"><img src="interface/icons/add.gif" alt="icon" align="absmiddle" /> Facility Type </a><br />
			<a href="?cat=severity"><img src="interface/icons/clock.gif" alt="icon" align="absmiddle" /> Severity </a><br />
			<a href="?cat=guidelines"><img src="interface/icons/printed.gif" alt="icon" align="absmiddle" /> Guidelines </a><br />
			<a href="?cat=questions"><img src="interface/icons/exclaim.gif" alt="pages" align="absmiddle" /> Questions </a><br />
			<a href="?cat=advices"><img src="interface/icons/server.gif" alt="users" align="absmiddle" /> Advices</a><br />
			<a href="?cat=injurycode"><img src="interface/icons/add.gif" alt="icon" align="absmiddle" /> Nature of Injury </a><br />
			<a href="?cat=accidentcode"><img src="interface/icons/add.gif" alt="icon" align="absmiddle" /> Nature of Accident </a><br />
	    </p>
		<p class="sec">
			<strong>Files</strong><br />
			<a href="?cat=file_browser"><img src="interface/icons/open-folder.gif" height="16" alt="edit" align="absmiddle" /> File Browser</a><br />
		</p>
	</div>
	{/if}
	<div id="body_holder"{if $admin.type=='administrator' || $admin.type=='manager'} style="padding-left: 185px;"{/if}>
	<div id="body">