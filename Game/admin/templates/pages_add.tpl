<p class="ss">секция</p>
<h2>{$pagetitle|default:'Мета данни (Search Engine Optimizations)'}</h2>
<ul class="snav">
    <li><a href="?cat=pages">списък страници</a></li>
    <li><a href="?cat=pages&amp;action=add&amp;id=999999" class="sel"><img src="/interface/icons/add.gif" alt="добави" align="absmiddle" /> добави нова страница</a></li>
</ul>
<h3>Добави нова страница</h3>
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
    <table width="100%" cellpadding="3" cellspacing="0" class="std">
    <tr>
        <td width="35%">Идентификатор</td>
        <td width="35%">Позиция в страницата</td>
        <td width="30%">Подредба</td>
    </tr>
    <tr>
        <td><input type="text" name="page[identifier]" value="{$p.identifier|default:'new-page'}" class="in" /></td>
        <td>
            <select name="page[pos]" class="sl">
                <option value="ext" selected="selected">допълнителна страница [ext]</option>
            </select>
        </td>
        <td><input type="text" name="page[position]" value="{$p.position|default:99}" class="in" /></td>
    </tr>
      
    <tr>
        <td>Адрес (непрепоръчително да се променя)</td>
        <td>Име на страницата</td>
        <td>Допълнение към името</td>
    </tr>
    <tr>
        <td><input type="text" name="page[url]" value="/pg/избрания-от-вас-индетификатор/" class="in" disabled="disabled" /></td>
        <td><input type="text" name="page[name]" value="{$p.name|default:'Нова Страница'}" class="in" /></td>
        <td><input type="text" name="page[add]" value="{$p.add}" class="in" /></td>
    </tr>
    <tr><td colspan="3">Мета Заглавие</td></tr>
    <tr><td colspan="3"><input type="text" name="page[title]" value="{$p.title}" class="in" /></td></tr>
      
    <tr>
        <td colspan="2">Мета Описание</td>
        <td>Мета Ключови думи</td>
    </tr>
    <tr>
        <td colspan="2"><textarea name="page[description]" class="std" rows="3">{$p.description}</textarea></td>
        <td><textarea name="page[keywords]" class="std" rows="3">{$p.keywords}</textarea></td>
    </tr>
      
    <tr><td colspan="3"><input type="submit" name="page[save]" value="Запиши" class="bt fixed100" /></td></tr>
    </table>
</fieldset>
</form>