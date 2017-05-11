<p class="ss">section</p>
<h2>{$pagetitle|default:'Groups and Skins'}</h2>
<ul class="snav">
	<li><a href="?cat=skins">group list</a></li>
	<li><a href="?cat=skins&amp;action=add&amp;id=999999" class="sel"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new group</a></li>
</ul>
<form action="" method="post">
<fieldset>
	<h3>{$group.title} : Advanced Group Configuration</h3>
	{include file="global/message.tpl"}
	<br>
	<p>
		<input type="text" id="locationTitle" name="form[locationTitle]" class="in nosize" size="35" placeholder="Choose a location" value="{$pst.locationTitle|default:$location.title|default:''}"/>
		<input type="hidden" name="form[location_id]" id="locationId" value="{$pst.location_id|default:$location.id|default:''}">
		<input type="hidden" name="form[logo_file_name]" id="logoFileName" value="{$pst.logo_file_name|default:$group.logo_file|default:''}">
	</p>
	<div id="logoContainer" style="width:350px; padding: 10px;">
		<div id="file-uploader" class="upload_key" style="float:left; display: inline-block;"></div>
		<div style="float:right;">
			<img id="imgLogo" width="150" height="150" {if $pst.logo_file_name|default:$group.logo_file|default:false} src="/draw.php?path=i/logos/{$pst.logo_file_name|default:$group.logo_file}&do=fixed&h=150&w=150" {/if}/>
		</div>
	</div>
	<h3 style="clear: both;">SMTP Settings</h3>
	<br/>
	<p>
		<label><input type="checkbox" name="form[use_smtp]" id="useSmtp" value="1" {if $pst.use_smtp|default:$smtpConfig.use_smtp}checked="checked"{/if}/> Use SMTP server</label>
	</p>
	<br/>
	<p>
		<input type="text" name="form[smtpHost]" class="in nosize useSmtp" size="35" placeholder="SMTP Host Name" value="{$pst.smtpHost|default:$smtpConfig.smtp_host}">
		<input type="text" name="form[smtpPort]" class="in nosize useSmtp" size="10" placeholder="SMTP Port" value="{$pst.smtpPort|default:$smtpConfig.smtp_port}">
	</p>
	<br/>
	<p>
		<label><input type="checkbox" name="form[use_smtp_authentication]" class="useSmtp" id="useSmtpAuthentication" value="1" {if $pst.use_smtp_authentication|default:$smtpConfig.smtp_auth}checked="checked"{/if}/> Use SMTP Authentication</label>
	</p>
	<br/>
	<p>
		<input type="text" name="form[smtpUser]" class="in nosize useSmtpAuthentication" size="35" placeholder="SMTP User Name" value="{$pst.smtpUser|default:$smtpConfig.smtp_username}">
		<input type="password" name="form[smtpPassword]" class="in nosize useSmtpAuthentication" size="20" placeholder="SMTP Password" value="{$pst.smtpPassword|default:$smtpConfig.smtp_password}">
		<input type="password" name="form[smtpRePassword]" class="in nosize useSmtpAuthentication" size="20" placeholder="Retype SMTP Password" value="{$pst.smtpRePassword|default:$smtpConfig.smtp_password}">
	</p>
	
	<h3>Standard Email - Auto Process</h3>
	<br/>
	<p>
		<input type="text" name="form[nopdfFrom]" class="in nosize" size="35" placeholder="From" value="{$pst.nopdfFrom|default:$nopdfMailConfig.mail_from}">
		<input type="text" name="form[nopdfReplyTo]" class="in nosize" size="35" placeholder="Reply to" value="{$pst.nopdfFrom|default:$nopdfMailConfig.mail_reply_to}">
	</p>
	<br/>
	<p><input type="text" name="form[nopdfSubject]" class="in nosize" size="74" placeholder="Subject" value="{$pst.nopdfSubject|default:$data.nopdfSubject|default:$nopdfMailTemplate.subject}"></p>
	<br/>
	<p>
		<label><input type="checkbox" name="form[nopdfInclideAttachments]" value="1" {if $pst.nopdfInclideAttachments|default:$nopdfMailConfig.mail_include_attachment}checked="checked"{/if}/> Include Attachment</label>
	</p>
	<br/>
	<textarea name="form[mailTemplateNoPdf]" class="in nosize" rows="20" cols="20">{$pst.mailTemplateNoPdf|default:$nopdfMailTemplate.template}</textarea>
	
	<h3>Standard Email - With PDF</h3>
	<br/>
	<p>
		<input type="text" name="form[pdfFrom]" class="in nosize" size="35" placeholder="From" value="{$pst.pdfFrom|default:$pdfMailConfig.mail_from}">
		<input type="text" name="form[pdfReplyTo]" class="in nosize" size="35" placeholder="Reply to" value="{$pst.pdfReplyTo|default:$pdfMailConfig.mail_reply_to}">
	</p>
	<br/>
	<p><input type="text" name="form[pdfSubject]" class="in nosize" size="74" placeholder="Subject" value="{$pst.pdfSubject|default:$pdfMailTemplate.subject}"></p>
	<br/>
	<p>
		<label><input type="checkbox" name="form[pdfInclideAttachments]" value="1" {if $pst.pdfInclideAttachments|default:$pdfMailConfig.mail_include_attachment}checked="checked"{/if}/> Include Attachment</label>
	</p>
	<br/>
	<textarea name="form[mailTemplatePdf]" class="in nosize" rows="20" cols="20">{$pst.mailTemplatePdf|default:$pdfMailTemplate.template}</textarea>
	
	<input type="submit" class="bt" name="form[save]" value="Save" />
</fieldset>
</form>

<p class="legend">
	<strong>Important:</strong><br />
	&bull; the identifier must be unique <br />
	&bull; you can change group's logo, color scheme, slides, and etc. AFTER you create it here. <br />
	&bull; from the "home link url" you can point out different url for the "Home" button, you can use url's like that "/contact.php" or even "http://yahoo.com" <br />
	&bull; "auto url" field gives you the option to determine on which url this group setting's will be applied automatically. Fill up just the url (ie "claimcompass.com"), don't put "http://" at front <br />
	&bull; if you put ANY url in the "auto-redirect" field then if the browser hits an address "/" will auto-redirect to the address in the field
</p>
<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="js/ckeditor/adapters/jquery.js"></script>
<script>
$(function(){
	$('#locationTitle').on('click', function(){
		hierarchyChooser();
	});
	
	var uploader = new qq.FileUploader({
	    element: $('#file-uploader')[0],
	    action: '/lib/fileuploader.php',
	    params: { uploadto: '/i/logos/' },
	    template:'<div class="qq-uploader">\
	    				<div class="qq-upload-drop-area">\
	    					<span>Drop files here to upload</span>\
	    				</div>\
	    				<div class="qq-upload-button qq-upload-button-key btn">Upload a logo</div>\
	    				<ul class="qq-upload-list"></ul>\
	    		</div>',
	    onComplete: function(id, fileName, responseJSON) {
	    	$('#logoFileName').val(responseJSON['fileName']);
	    	$('#imgLogo').attr('src','/draw.php?path=i/logos/'+responseJSON['fileName']+'&do=fixed&h=150&w=150');
	    }
	});
	
	var ckConfig = {
			toolbar: [
				{ name: 'basicstyles', items : [ 'Source','RemoveFormat','-','Bold','Italic','Underline','Strike'] },
				{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
				{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
				{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule', 'Styles'] },
				'/',
				{ name: 'styles', items : [ 'Format','Font','FontSize' ] },
				{ name: 'colors', items : [ 'TextColor','BGColor' ] }
			],

			skin:'kama'
		};
	
		$('textarea').ckeditor(ckConfig);
		
		$('#useSmtp').on('change', function(){
			var smtpChecked = $(this).is(':checked') ;
			var smtpAuthChecked = $('#useSmtpAuthentication').is(':checked') ;
			
			$('.useSmtp').prop('disabled', !smtpChecked) ;
			
			if(!smtpChecked && smtpAuthChecked){
				$('.useSmtpAuthentication').prop('disabled', true) ;
			} else {
				$('#useSmtpAuthentication').trigger('change');
			}
			
		});
		
		$('#useSmtpAuthentication').on('change', function(){
			var checked = $(this).is(':checked') ;
			
			$('.useSmtpAuthentication').prop('disabled', !checked) ;
		});
		
		$('#useSmtp').trigger('change');
});

function chosenNode(id, name){
	$('.aPop, .md').remove();
	$('#locationTitle').val(name);
	$('#locationId').val(id);
}
</script>