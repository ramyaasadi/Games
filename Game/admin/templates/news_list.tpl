<p class="ss">секция</p>
<h2>Новини</h2>

<ul class="snav">
    <li><a href="?cat=news" class="sel">списък новини</a></li>
    <li><a href="?cat=news&amp;action=add&amp;id=999999"><img src="/interface/icons/add.gif" alt="добави" align="absmiddle" /> добави новина</a></li>
</ul>
<h3>Списък новини</h3>
<table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">
<thead>
<tr>
    <th>дата</th>
    <th>заглавие</th>
    <th>съдържание</th>
    <th></th>
</tr>
</thead>
<tbody>
{foreach from=$news item=item}
<tr{cycle values=', class="even"'}>
    <td width="1% "nowrap="nowrap">{include file="global/date_format.tpl" date=$item.date}</td>
    <td><a href="?cat=news&amp;action=edit&amp;id={$item.id}"><strong>{$item.title|default:'--- новина без заглавие ---'}</strong></a></td>
    <td>{$item.body|strip_tags:false|truncate:50:'...':true}</td>
    <td align="right" nowrap="nowrap" class="admin">
        <a href="javascript: if (confirm('Сигурни ли сте, че искате да изтриете тази новина?')) location.href='?cat=news&amp;action=erase&amp;id={$item.id}';"><img src="/interface/icons/erase.gif" alt="изтрий" align="absmiddle" title="Изтрий обекта" /></a>
        <a href="?cat=news&amp;action=edit&amp;id={$item.id}"><img src="/interface/icons/edit.gif" alt="редактирай" align="absmiddle" title="Редактирай съдържанието" /></a>
        <a href="/news/{$item.id}/"><img src="/interface/icons/preview.gif" alt="прегледай" align="absmiddle" title="Прегледай съдържанието" /></a>
    </td>
</tr>
{/foreach}
</tbody>
</table>
{include file="global/pg.tpl" paging=$paging}
{include file="admin/legend.tpl"}