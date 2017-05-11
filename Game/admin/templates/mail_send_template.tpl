<h2>Изпращане на писма: Стъпка 2</h2>
<h4>Избери темплейта, който ще използваш за писмото</h4>
<br />
<form action="" method="post">
<fieldset>
    <table width="100%" cellpadding="3" cellspacing="0" class="std">
    <tr class="even">
        <td width="1%">
            <input type="radio" name="template[id]" value="new" />
        </td>
        <td colspan="3"><strong>Създай нов темплейт</strong> (новия темплейт ще бъде записан автоматично)</td>
    </tr>
    {foreach from=$list item=item}
    <tr{cycle values=', class="even"'}>
        <td width="1%">
            <input type="radio" name="template[id]" value="{$item.id}" {if $smarty.session.mail_send.template==$item.id}checked="checked"{/if} />
        </td>
        <td><strong>{$item.name|default:'--- темплейт без заглавие ---'}</strong></td>
        <td>{$item.template|strip_tags:false|truncate:100:'...':true}</td>
        <td width="1% "nowrap="nowrap">{include file="global/date_format.tpl" date=$item.date}</td>
        <td align="right" nowrap="nowrap" class="admin">
            <a href="?cat=mail_templates&amp;action=full&amp;id={$item.id}"><img src="/interface/icons/preview.gif" alt="прегледай" align="absmiddle" title="Прегледай съдържанието" /></a>
        </td>
    </tr>
    {/foreach}
    </table>
    <hr />
    <input type="submit" name="template[save]" class="bt fixed100" value="Продължи &raquo;" />
</fieldset>
</form>
{include file="global/pg.tpl" paging=$paging}
<hr />
<p>
    <a href="?cat=mail_send">&laquo; върни се да добавиш или премахнеш някой потребител</a>
</p>