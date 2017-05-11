<h2>Изпращане на писма: Стъпка 3</h2>
<h4>Прегледай и редактирай темплейта, който ще използваш за писмото</h4>
<br />
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
      <table width="100%" cellpadding="3" cellspacing="0" border="0" class="std">
      <tr>
            <td>Заглавие</td>
            <td width="70%">Превю</td>
      </tr>
      <tr>
            <td><input type="text" name="mail[name]" value="{$t.name|escape:'html'}" class="in" /></td>
            <td rowspan="3" valign="top">
                <iframe src="?cat=mail_templates&action=preview&id={$t.id|default:99999999}{if $t.reg_id>0}&reg_id={$t.reg_id}{/if}" width="100%" height="450">
                    <p>Your browser does not support iframes.</p>
                </iframe>
            </td>
      </tr>
      <tr>
            <td>Темплейт</td>
      </tr>
      <tr>
            <td><textarea name="mail[template]" class="std" rows="20">{$t.template}</textarea></td>
      </tr>
      <tr>
            <td colspan="2">
                  <hr />
                  <input type="submit" name="mail[save]" value="Запиши и Прегледай" class="bt fixed200" />
                  <input type="submit" name="mail[next]" class="bt fixed100" value="Продължи &raquo;" />
            </td>
      </tr>
      </table>
      <p class="legend">
        <strong>Всички налични полета, които могат да се използват в темплейта:</strong><br />
        {foreach from=$legend item=item key=key}
            {ldelim}{$key}{rdelim} &nbsp;
        {/foreach}
      </p>
      <hr />
      <p>
        <a href="?cat=mail_send&action=template">&laquo; върни се, за да избереш друг темплейт</a>
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