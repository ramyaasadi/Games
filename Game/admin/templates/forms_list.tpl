{if $smarty.get.filter && $smarty.get.filter!=''}
{assign var='linkadd' value='&amp;filter='|cat:$smarty.get.filter}
{/if}
<p class="">section</p>
<h2>{$pagetitle|default:'UI Forms'}</h2>
<ul class="snav">
    <li><a href="?cat=forms{$linkadd}" class="sel">list</a></li>
    <li><a href="?cat=forms&amp;filter={$smarty.get.filter}&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new</a></li>
</ul>
{if $forms}
<table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">
<tr>
    <th>ID</th>
    <th>Type</th>
    <th>Form Name</th>
    <th>State Name</th>
    <th>State Abbrev.</th>
    <th colspan="2">Last Change Date</th>
</tr>
{foreach from=$forms item=item}
<tr{cycle values=', class="even"'}>
      <td width="1%" nowrap="nowrap" align="right">{$item.id}.</td>
      <td width="1%" nowrap="nowrap" align="right">{if $item.rep_type==1}FROI{else}N/A{/if}</td>
      <td><a href="?cat=forms&amp;action=edit&amp;id={$item.id}{$linkadd}"><strong>{$item.rep_form_name|truncate:60:'...':true}</strong></a></td>
      <td><a href="?cat=forms&amp;action=edit&amp;id={$item.id}{$linkadd}"><strong>{$item.sum_usa_state_name|truncate:60:'...':true}</strong></a></td>
      <td><a href="?cat=forms&amp;action=edit&amp;id={$item.id}{$linkadd}"><strong>{$item.sum_state_abbrev|truncate:60:'...':true}</strong></a></td>

      <td width="1% "nowrap="nowrap">{include file="global/date_format.tpl" date=$item.last_update}</td>
      <td align="right" nowrap="nowrap" class="admin">
      <a href="javascript: if (confirm('Are you sure you want to erase this item?')) location.href='?cat=forms&amp;action=erase&amp;id={$item.id}&amp;filter={$smarty.get.filter}';"><img src="interface/icons/erase.gif" alt="erase" align="absmiddle" title="Erase Item" /></a>
      <a href="?cat=forms&amp;action=edit&amp;id={$item.id}{$linkadd}"><img src="interface/icons/edit.gif" alt="edit" align="absmiddle" title="Edit Item" /></a>
      </td>
</tr>
{/foreach}
</table>
{else}<br>no records found{/if}
{include file="legend.tpl"}