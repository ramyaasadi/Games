<p class="ss">section</p>
<h2>{$pagetitle|default:'Meta Data (Search Engine Optimizations)'}</h2>
<ul class="snav">
    <li><a href="?cat=pages" class="sel">page list</a></li>
    {*<li><a href="?cat=pages&amp;action=add&amp;id=999999" class="sel"><img src="interface/icons/add.gif" alt="добави" align="absmiddle" /> add new page</a></li>*}
</ul>
<h3>Page List</h3>
<table width="100%" cellpadding="3" cellspacing="0" class="std">
<tr>
      <th>Order.</th>
      <th>Name</th>
      <th>Identifier</th>
      <th>Meta Title</th>
      <th>Page Position</th>
      <th colspan="2">url</th>
</tr>
{foreach from=$pages item=item}
<tr{cycle values=', class="even"'}>
      <td nowrap="nowrap" align="right" width="1%">{$item.position}.</td>
      <td nowrap="nowrap"><a href="?cat=pages&amp;action=edit&amp;id={$item.id}">{$item.name}</a></td>
      <td nowrap="nowrap">{$item.identifier}</td>
      <td nowrap="nowrap">{$item.title}</td>
      <td nowrap="nowrap"><strong>{$item.pos}</strong></td>
      <td><a href="http://www.exxon.dev{$item.url}">www.{$site_host}{$item.url}</a></td>
      <td align="right" nowrap="nowrap" class="admin">
            {if $item.pos=='ext'}
            <a href="javascript: if (confirm('Do you want to erase this page?')) location.href='?cat=pages&amp;action=erase&amp;id={$item.id}';"><img src="interface/icons/erase.gif" alt="erase" align="absmiddle" title="Erase Item" /></a>
            {/if}
            <a href="?cat=pages&amp;action=edit&amp;id={$item.id}"><img src="interface/icons/edit.gif" alt="edit" align="absmiddle" title="Edit Item" /></a>
      </td>
</tr>
{/foreach}
</table>
{include file="legend.tpl"}