{if $smarty.get.filter && $smarty.get.filter!=''}
{assign var='linkadd' value='&amp;filter='|cat:$smarty.get.filter}
{/if}
<p class="ss">section</p>
<h2>{$pagetitle|default:'Text Panels'}</h2>
<ul class="snav">
    <li><a href="?cat=texts{$linkadd}" class="sel">panel list</a></li>
    {if $smarty.get.filter=='hints' || $smarty.get.filter=='news'}
    <li><a href="?cat=texts&amp;filter={$smarty.get.filter}&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new panel</a></li>
    {/if}
</ul>
<h3>Panel List</h3>
<table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">
<tr>
    <th>Pos.</th>
    <th>Title</th>
    <th>Subtitle</th>
    <th>Identifier</th>
    <th colspan="2">Last Change Date</th>
</tr>
{foreach from=$texts item=item}
<tr{cycle values=', class="even"'}>
      <td width="1% "nowrap="nowrap" align="right">{$item.position}.</td>
      <td><a href="?cat=texts&amp;action=edit&amp;id={$item.id}{$linkadd}"><strong>{$item.title|truncate:60:'...':true}</strong></a></td>
      <td>{$item.subtitle|truncate:60:'...':true}</td>
      <td>{$item.identifier|truncate:60:'...':true}</td>
      <td width="1% "nowrap="nowrap">{include file="global/date_format.tpl" date=$item.date}</td>
      <td align="right" nowrap="nowrap" class="admin">
            {if $smarty.get.filter=='aboutus' || $smarty.get.filter=='support'}
            <a href="javascript: if (confirm('Are you sure you want to erase this item?')) location.href='?cat=texts&amp;action=erase&amp;id={$item.id}&amp;filter={$smarty.get.filter}';"><img src="interface/icons/erase.gif" alt="erase" align="absmiddle" title="Erase Item" /></a>
            {/if}
            <a href="?cat=texts&amp;action=edit&amp;id={$item.id}{$linkadd}"><img src="interface/icons/edit.gif" alt="edit" align="absmiddle" title="Edit Item" /></a>
      </td>
</tr>
{/foreach}
</table>
{include file="legend.tpl"}