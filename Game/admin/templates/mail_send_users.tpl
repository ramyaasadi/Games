<h2>Изпращане на писма: Стъпка 1</h2>
<h4>Избери потребителите, на които искаш да изпратиш писмо</h4>
<br />
<form action="" method="post">
<fieldset>
    <table width="100%" cellpadding="3" cellspacing="0" class="std">
    <tr>
          <th colspan="2">име</th>
          <th>e-mail</th>
          <th>продуктов номер</th>
          <th>писма</th>
          <th>анкета</th>
          <th></th>
    </tr>
    {foreach from=$list item=item}
    <tr{cycle values=', class="even"'}>
          <td width="1%">
                {assign var='item_id' value=$item.id}
                <input type="checkbox" name="reg[{$item.id}]" value="{$item.id}" {if $smarty.session.mail_send.reg.$item_id>0}checked="checked"{/if} />
          </td>
          <td nowrap="nowrap"><a href="?cat=registrations&amp;action=edit&amp;id={$item.id}">{$item.name}</a></td>
          <td>{$item.email}</td>
          <td>No. <strong>{$item.product_id}</strong></td>
          <td width="1" nowrap="nowrap">
            {if $item.messages>0}
                <a href="?cat=mail_archive&reg_id={$item.id}"><img src="/interface/icons/mail.gif" alt="писма" align="absmiddle" align="брой изпратени писма на този потребител"/></a>
                {$item.messages}
            {/if}
          </td>
          <td width="1" nowrap="nowrap">{if $item.pool_points}<img src="/interface/star-gold.png" alt="*" align="absmiddle" title="резултат от анкетата" /> {$item.pool_points}%{/if}</td>
          <td align="right" nowrap="nowrap" class="admin">
                {if $item.pool_points>0}<a href="?cat=registrations&amp;action=pool&amp;id={$item.id}"><img src="/interface/icons/note.gif" alt="анкета" align="absmiddle" title="Виж резултата от анкетата" /></a>{/if}
                <a href="javascript: if (confirm('Сигурни ли сте, че искате да изтриете този потребител?')) location.href='?cat=registrations&amp;action=erase&amp;id={$item.id}';"><img src="/interface/icons/erase.gif" alt="изтрий" align="absmiddle" title="Изтрий обекта" /></a>
                <a href="?cat=registrations&amp;action=edit&amp;id={$item.id}"><img src="/interface/icons/edit.gif" alt="редактирай" align="absmiddle" title="Редактирай съдържанието" /></a>
          </td>
    </tr>
    {/foreach}
    </table>
    <hr />
    <input type="submit" name="reg[save]" class="bt fixed100" value="Продължи &raquo;" />
</fieldset>
</form>
{include file="global/pg.tpl" paging=$paging}
{include file="admin/legend.tpl"}