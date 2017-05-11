<p class="ss">секция</p>
<h2>Новини</h2>

<ul class="snav">
    <li><a href="?cat=news">списък новини</a></li>
    <li><a href="?cat=news&amp;action=add&amp;id=999999" class="sel"><img src="/interface/icons/add.gif" alt="добави" align="absmiddle" /> добави новина</a></li>
</ul>
<h3>Редакция на новина</h3>
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
      <table width="100%" cellpadding="3" cellspacing="0" class="std">
      <tr>
            <td width="70%">Заглавие</td>
            <td><strong>*</strong>Дата</td>
      </tr>
      <tr>
            <td><input type="text" name="news[title]" value="{$n.title|escape:'html'}" class="in" /></td>
            <td><input type="text" name="news[date]" value="{$n.date}" class="in" /></td>
      <tr>
            <td colspan="2">Съдържание</td>
      </tr>
      <tr>
            <td colspan="2"><textarea name="news[body]" class="std" rows="20" id="ckedit">{$n.body}</textarea></td>
      </tr>
      <tr>
            <td>
                  <input type="submit" name="news[save]" value="Запиши" class="bt fixed100" />
            </td>
            <td align="right"><strong>*</strong> <em>(оставете полето за датата празно за автоматично попълване сегашната дата и час)</em></td>
      </tr>
      </table>
</fieldset>
</form>
<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="js/ckeditor/adapters/jquery.js"></script>
<script type="text/javascript" src="js/ckfinder/ckfinder.js"></script>
<script type="text/javascript">
{literal}
	$(function() {
		var editor = CKEDITOR.replace( 'ckedit' );
		CKFinder.setupCKEditor( editor, './js/ckfinder/' );
	});
{/literal}
</script>