<p class="ss">section</p>
<h2>{$pagetitle|default:'Administrators'}</h2>
<ul class="snav">
    <li><a href="?cat=administrators" class="sel">administrators list</a></li>
    <li><a href="?cat=administrators&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new administrator</a></li>
</ul>
<h3>Administrators List</h3>

<table width="100%" cellpadding="3" cellspacing="0" class="std">
<thead>
    <th>Name</th>
    <th>Username</th>
    <th>Type</th>
    <th>Registered</th>
    <th colspan="2">Last Logged</th>
</thead>
<tbody>
{foreach from=$list item=item}
<tr{cycle values=', class="even"'}>
    <td><a href="?cat=administrators&amp;action=edit&amp;id={$item.id}"><strong>{$item.name|default:'Anonymous'}</strong></a></td>
    <td>{$item.username}</td>
    <td>{$item.type}</td>
    <td width="1% "nowrap="nowrap">{include file="global/date_format.tpl" date=$item.registered}</td>
    <td width="1% "nowrap="nowrap">{include file="global/date_format.tpl" date=$item.last_active}</td>
    <td align="right" nowrap="nowrap" class="admin">
        {if $item.id!=$admin.id}
        <a href="javascript: if (confirm('Do you want to erase this administrator?')) location.href='?cat=administrators&amp;action=erase&amp;id={$item.id}';"><img src="interface/icons/erase.gif" alt="erase" align="absmiddle" title="Erase Item" /></a>
        {/if}
        <a href="?cat=administrators&amp;action=edit&amp;id={$item.id}"><img src="interface/icons/edit.gif" alt="edit" align="absmiddle" title="Edit Item" /></a>
    </td>
</tr>
{/foreach}
</tbody>
</table>
{include file="legend.tpl"}