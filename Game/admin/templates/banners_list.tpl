<h2>Банери</h2>
<p class="admin">
    <img src="/interface/icons/add.gif" alt="добави" align="absmiddle" />  <a href="?cat=banners&amp;action=add&amp;id=999999">добави банер</a>
</p>
<table width="100%" cellpadding="3" cellspacing="0" class="std">
{foreach from=$banners item=item}
<tr{cycle values=', class="even"'}>
      <td valign="top" nowrap="nowrap">{$item.type}</td>
      <td valign="top"><a href="?cat=banners&amp;action=edit&amp;id={$item.id}"><strong>{$item.path}</strong></a></td>
      <td valign="top">{$item.desc|truncate:80:'...':true}</td>
      <td valign="top"><strong>{$item.pos}</strong></td>
      <td valign="top" align="right" nowrap="nowrap" class="admin">
            <a href="javascript: if (confirm('Сигурни ли сте, че искате да изтриете този банер?')) location.href='?cat=banners&amp;action=erase&amp;id={$item.id}';"><img src="/interface/icons/erase.gif" alt="изтрий" align="absmiddle" title="Изтрий обекта" /></a>
            <a href="?cat=banners&amp;action=edit&amp;id={$item.id}"><img src="/interface/icons/edit.gif" alt="редактирай" align="absmiddle" title="Редактирай съдържанието" /></a>
      </td>
</tr>
{/foreach}
</table>
{include file="global/pg.tpl" paging=$paging}
{include file="admin/legend.tpl"}