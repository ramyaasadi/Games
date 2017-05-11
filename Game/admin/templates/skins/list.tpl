<p class="ss">section</p>
<h2>{$pagetitle|default:'Groups and Skins'}</h2>
<ul class="snav">
	<li><a href="?cat=skins" class="sel">group list</a></li>
	<li><a href="?cat=skins&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new group</a></li>
</ul>
<h3>Group List</h3>
{include file="global/message.tpl"}

<table width="100%" cellpadding="3" cellspacing="0" class="std">
<tr>
	<td>title</td>
	<td>url</td>
	<td>active</td>
	<td>created</td>
	<td>last change</td>
	<td></td>
</tr>
{foreach from=$list item=item}
<tr{cycle values=', class="even"'}>
    <td>
    	{if $item.active}<a href="?cat=skins&activate={$item.id}" title="deactivate it"><img src="interface/icons/circle-green.png" alt="active" align="absmiddle" /></a>
		{else}<a href="?cat=skins&activate={$item.id}" title="activate it"><img src="interface/icons/circle-grey.png" alt="not active" align="absmiddle" /></a>{/if}
    	<a href="?cat=skins&amp;action=edit&amp;id={$item.id}"><strong>{$item.title|default:'Unknown'}</strong></a>
    </td>
    <td>[url]/?set_group={$item.ident}</td>
    <td>{if $item.active}<a href="?cat=skins&deactivate={$item.id}">deactivate it</a>
	{else}<a href="?cat=skins&activate={$item.id}">activate it</a>{/if}</td>
	<td width="1%" nowrap="nowrap">{include file="global/date_format.tpl" date=$item.created}</td>
    <td width="1%" nowrap="nowrap">{include file="global/date_format.tpl" date=$item.updated}</td>
    <td align="right" nowrap="nowrap" class="admin">
    	{if $item.active==0}<a href="javascript: if (confirm('Are you sure you want to erase this group?')) location.href='?cat=skins&amp;action=erase&amp;id={$item.id}';"><img src="interface/icons/i_remove.png" alt="erase" align="absmiddle" title="Erase Template" /></a>{/if}
    	<a href="?cat=skins&amp;action=edit&amp;id={$item.id}"><img src="interface/icons/pencil.png" alt="edit" align="absmiddle" title="Edit Group's Data" /></a>
    	<a href="?cat=skins&amp;action=skin&amp;id={$item.id}"><img src="interface/icons/skins.gif" alt="skin" align="absmiddle" title="Customize Group's Skin" /></a>
    	<a href="?cat=skins&amp;action=articles&amp;id={$item.id}"><img src="interface/icons/articles.png" alt="skin" align="absmiddle" title="Edit Group's Articles" /></a>
    	<a href="?cat=skins&amp;action=terms&amp;id={$item.id}"><img src="interface/icons/terms.png" alt="skin" align="absmiddle" title="Edit Group's Custom Terms" /></a>
    </td>
</tr>
{/foreach}
</table>