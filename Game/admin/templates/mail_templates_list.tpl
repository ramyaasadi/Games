<p class="ss">section</p>
<h2>Mail Templates</h2>
<ul class="snav">
	<li><a href="?cat=mail_templates" class="sel">templates list</a></li>
    <li><a href="?cat=mail_templates&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add mail template</a></li>
</ul>
<h3>Templates List</h3>
<br />
{if $list}
<table width="100%" cellpadding="3" cellspacing="0" class="std">
<tr>
	<td>subject</td>
	<td>type</td>
	<td>identifier</td>
	<td>description</td>
	<td>last update</td>
	<td></td>
</tr>
{foreach from=$list item=item}
<tr{cycle values=', class="even"'}>
    <td><a href="?cat=mail_templates&amp;action=edit&amp;id={$item.id}"><strong>{$item.name|default:'--- темплейт без заглавие ---'}</strong></a></td>
    <td><strong>{$item.type}</strong></td>
	<td nowrap="nowrap">{$item.identifier|default:'N/A'}</td>
    <td>{$item.template|strip_tags:false|truncate:30:'...':true}</td>
    <td width="1% "nowrap="nowrap">{include file="global/date_format.tpl" date=$item.date}</td>
    <td align="right" nowrap="nowrap" class="admin">
        {if $item.type!='system'}<a href="javascript: if (confirm('Are you sure you want to erase this template?')) location.href='?cat=mail_templates&amp;action=erase&amp;id={$item.id}';"><img src="interface/icons/erase.gif" alt="erase" align="absmiddle" title="Erase Template" /></a>{/if}
        <a href="?cat=mail_templates&amp;action=edit&amp;id={$item.id}"><img src="interface/icons/edit.gif" alt="edit" align="absmiddle" title="Edit Template" /></a>
        <a href="?cat=mail_templates&amp;action=full&amp;id={$item.id}"><img src="interface/icons/preview.gif" alt="preview" align="absmiddle" title="Preview Template" /></a>
    </td>
</tr>
{/foreach}
</table>
{include file="global/pg.tpl" paging=$paging}
{/if}

{include file="legend.tpl"}