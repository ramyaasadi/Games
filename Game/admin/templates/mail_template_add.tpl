<p class="ss">section</p>
<h2>Mail Templates</h2>
<ul class="snav">
	<li><a href="?cat=mail_templates">templates list</a></li>
    <li><a href="?cat=mail_templates&amp;action=add&amp;id=999999" class="sel"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add mail template</a></li>
</ul>
<h3>Add New Mail Template</h3>
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
      <table width="100%" cellpadding="3" cellspacing="0" border="0" class="std">
      <tr>
            <th>title/subject</th>
            <th width="50%">preview</th>
      </tr>
      <tr>
            <td><input type="text" name="mail[name]" value="{$t.name|escape:'html'}" class="in" /></td>
            <td rowspan="3" valign="top">
                <iframe src="?cat=mail_templates&action=preview&id=999999999999" width="100%" height="450">
                    <p>Your browser does not support iframes.</p>
                </iframe>
            </td>
      </tr>
      <tr>
            <th>body</th>
      </tr>
      <tr valign="top">
            <td><textarea name="mail[template]" class="std" rows="20">{$t.template}</textarea></td>
      </tr>
      <tr>
	<td colspan="2">
			  <hr />
			  <input type="submit" name="mail[save]" value="Save Changes" class="bt fixed100" />
		</td>
      </tr>
      </table>
      <p class="legend">
        <strong>Quote fields usable in the mail template:</strong><br />
        {foreach from=$legend item=item key=key}
            {ldelim}{$key}{rdelim} &nbsp;
        {/foreach}
      </p>
</fieldset>
</form>
<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="js/ckeditor/adapters/jquery.js"></script>
<script type="text/javascript">
{literal}
	$(function() {
		var config = {
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
	
		$('textarea').ckeditor(config);
	});
{/literal}
</script>