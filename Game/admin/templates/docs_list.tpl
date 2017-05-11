<p class="ss">section</p>
<h2>Documents</h2>

<ul class="snav">
    <li><a href="?cat=docs&action=list&filter=uploaded"{if $filter=='uploaded'} class="sel"{/if}><em>{$stats.docs.uploaded|default:0}</em> for conversion</a></li>
	<li><a href="?cat=docs&action=list&filter=for-review"{if $filter=='for-review'} class="sel"{/if}><em>{$stats.docs.for_review|default:0}</em> for review</a></li>
	<li><a href="?cat=docs&action=list&filter=for-sale"{if $filter=='for-sale'} class="sel"{/if}><em>{$stats.docs.for_sale|default:0}</em> for sale</a></li>
	<li><a href="?cat=docs&action=list&filter=for-erase"{if $filter=='for-erase'} class="sel"{/if}><em>{$stats.docs.for_erase|default:0}</em> marked for erase</a></li>
</ul>
<h3>{$intitle|default:'Documents for Conversion'}</h3>
<form action="" method="post" style="float: right;">
<fieldset>
	<table class="std" cellpadding="3" cellspacing="0">
	<tbody>
		<tr>
			<td><label>Filter documents by their author</label></td>
			<td>
				<select name="filter[author]" class="sls">
					<option value="0">--- All Authors ---</option>
					{foreach from=$authors item=item}
					<option value="{$item.id}"{if $item.id==$author_id} selected="selected"{/if}>{$item.first_name} {$item.last_name}</option>
					{/foreach}
				</select>
			</td>
			<td><input type="submit" name="filter[send]" value="Filter" class="bts" /></td>
			<td>
				<input type="checkbox" name="filter[save]" value="1" id="filter_save" {if $smarty.session.author_id>0}checked="checked"{/if} />
				<label for="filter_save">save the filter in session</label>
			</td>
		</tr>
	</tbody>
	</table>
</fieldset>
</form>
<div class="clear"></div>
{include file="global/message.tpl"}
<table width="100%" cellpadding="3" cellspacing="0" class="simple">
<thead>
	<tr>
		<th></th>
		<th{if $sort=='title'} class="veven"{/if}><a href="?cat=docs&filter={$filter}&sort=title&order={if $sort=='title' && $order=='asc'}desc{else}asc{/if}">title <img src="interface/sort-icon.gif" alt="sort" align="absmiddle" /></a></th>
		<th{if $sort=='author'} class="veven"{/if} nowrap="nowrap"><a href="?cat=docs&filter={$filter}&sort=author&order={if $sort=='author' && $order=='asc'}desc{else}asc{/if}">author <img src="interface/sort-icon.gif" alt="sort" align="absmiddle" /></a></th>
		<th{if $sort=='uploaded'} class="veven"{/if} nowrap="nowrap"><a href="?cat=docs&filter={$filter}&sort=uploaded&order={if $sort=='uploaded' && $order=='asc'}desc{else}asc{/if}">uploaded <img src="interface/sort-icon.gif" alt="sort" align="absmiddle" /></a></th>
		<th{if $sort=='converted'} class="veven"{/if} nowrap="nowrap"><a href="?cat=docs&filter={$filter}&sort=converted&order={if $sort=='converted' && $order=='asc'}desc{else}asc{/if}">converted <img src="interface/sort-icon.gif" alt="sort" align="absmiddle" /></a></th>
		<th colspan="2">download links</th>
		<th colspan="2">status</th>
	</tr>
</thead>
<tbody>
	{foreach from=$docs item=item}
	<tr class="{if $item.for_erase>0}for_erase{else}{cycle values=',even'}{/if}" valign="top">
		<td width="1%"><a href="?cat=docs&amp;action=edit&amp;id={$item.id}"><img src="/interface/icon_{if $item.status=='uploaded'}uploaded{else}for_review{/if}.gif" alt="icon" align="absmiddle" /></a></td>
		<td{if $sort=='title'} class="veven"{/if}>
			<a href="?cat=docs&amp;action=edit&amp;id={$item.id}">{$item.title}</a><br />
			<em>{$item.description|truncate:200:'...':true}</em>
		</td>
		<td{if $sort=='author'} class="veven"{/if}><a href="?cat=members&action=stats&id={$item.user_id}">{$item.first_name} {$item.last_name}</a></td>
		<td{if $sort=='uploaded'} class="veven"{/if} nowrap="nowrap">{if $item.date_uploaded}{include file="global/time_passed.tpl" date=$item.date_uploaded}{else}N/A{/if}</td>
		<td{if $sort=='converted'} class="veven"{/if} nowrap="nowrap">{if $item.date_converted}{include file="global/time_passed.tpl" date=$item.date_converted}{else}N/A{/if}</td>
		<td nowrap="nowrap">{if $item.filename}<img src="/interface/ic_download.png" alt="icon" align="absmiddle" /> <a href="?cat=docs&action=download&type=original&id={$item.id}">original</a>{/if}</td>
		<td nowrap="nowrap">{if $item.converted}<img src="/interface/ic_download.png" alt="icon" align="absmiddle" /> <a href="?cat=docs&action=download&type=review&id={$item.id}">review copy</a>{/if}</td>
		<td nowrap="nowrap">
			{if $item.for_erase>0}
			marked for erase
			{else}
			{$item.status}
			{/if}
		</td>
		<td nowrap="nowrap" width="1%">
			<a href="?cat=docs&amp;action=edit&amp;id={$item.id}"><img src="interface/icons/edit.gif" alt="edit" /></a>
			<a href="#erase" onclick="if (confirm('Are you sure you want to erase this document?')) location.href='?cat=docs&amp;action=erase&amp;id={$item.id}';"><img src="interface/icons/erase.gif" alt="erase" /></a>
		</td>
	</tr>
	{/foreach}
</tbody>
</table>
{include file="global/pg.tpl"}