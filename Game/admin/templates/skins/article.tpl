<p class="ss">section</p>
<h2>{$pagetitle|default:'Groups and Skins'}</h2>
<ul class="snav">
	<li><a href="?cat=skins">group list</a></li>
	<li><a href="?cat=skins&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new group</a></li>
</ul>
<h3>Group: <strong>{$data.title}</strong></h3>
<nav class="stab">
	<a href="?cat=skins&action=edit&id={$data.id}"><img src="interface/icons/pencil.png" alt="edit" align="absmiddle" title="Edit Group's Data" /> edit</a>
	<a href="?cat=skins&action=skin&id={$data.id}"><img src="interface/icons/skins.gif" alt="skin" align="absmiddle" title="Customize Group's Skin" /> skin</a>
	<a href="?cat=skins&action=articles&id={$data.id}"><img src="interface/icons/articles.png" alt="skin" align="absmiddle" title="Edit Group's Articles" /> <strong>articles</strong></a>
	<a href="?cat=skins&action=terms&id={$data.id}"><img src="interface/icons/terms.png" alt="skin" align="absmiddle" title="Edit Group's Terms" /> terms</a>
</nav>
<p class="ss">
	identifier: <strong>{$data.ident}</strong><br />
	active: <strong>{if $data.active==1}yes{else}no{/if}</strong><br />
	created: <strong>{include file="global/date_format.tpl" date=$data.created}</strong><br />
	updated: <strong>{include file="global/date_format.tpl" date=$data.updated}</strong>
</p>
<h3>Group Articles</h3>
{include file="global/message.tpl"}
<input type="hidden" name="group_id" value="{$data.id}" />
<form action="?cat=skins&action=articles&id={$data.id}" method="post">
<fieldset>
	<table class="std" width="100%" cellpadding="3" cellspacing="0">
	<tr>
		<th>name</th>
		<th>type</th>
		<th>identifier</th>
		<th>status and data</th>
		<th></th>
	</tr>
	{foreach from=$list item=item}
	<tr{cycle values=', class="even"'}>
		<td><strong>
			{if $item.type=='page'}
			<img src="interface/icons/note-todo-list-24.png" alt="icon" align="absmiddle" />
			{elseif $item.type=='panel'}
			<img src="interface/icons/note-todo-24.png" alt="icon" align="absmiddle" />
			{else}
			<img src="interface/icons/note-star-24.png" alt="icon" align="absmiddle" />
			{/if}
			{$item.name}
		</strong></td>
		<td>{$item.type}</td>
		<td>{$item.ident}</td>
		<td width="320">
			<select rel="{$item.id}" class="sl status" style="width: 150px; font-size: 8pt;">
				<option value="default"{if $item.status=='default'} selected="selected"{/if}>System Default</option>
				{if $item.type!='link'}<option value="group"{if $item.status=='group'} selected="selected"{/if}>Group Custom</option>{/if}
				{if $item.type!='page'}<option value="hidden"{if $item.status=='hidden'} selected="selected"{/if}>Hidden (Off)</option>{/if}
			</select>
			{if $item.editable > 0}<input name="data[{$item.ident}]" type="text" class="in" value="{$item.data}" style="width: 150px; font-size: 8pt;"/>{/if}
		</td>
		<td align="right" width="1" nowrap="nowrap">
		{if $item.type!='link'}
			{if $item.texts_ident}<a rel="{$item.texts_ident}" alt="{$item.texts_owner}" class="edit">
				{if $item.texts_id>0}<img src="interface/icons/pencil.png" alt="edit" align="absmiddle"/> edit
				{else}<img src="interface/icons/add.png" alt="add" align="absmiddle"/> add{/if}
			</a>{/if}
		{/if}
		</td>
	</tr>
	{/foreach}
	<tr>
		<td colspan="2"><input name="data[save]" type="submit" value="Save Changes" class="bt" /></td>
		<td colspan="3" align="right"><strong>Note:</strong> The "Save Changes" button saves all the data fields at once.</td>
	</tr>
	</table>
</fieldset>
</form>

<script type="text/javascript">
	var debug = true,
		group_id = $("input[name=group_id]").val();
	$(document).ready(function() {
		$('select.status').bind('change', function() {
			var id = $(this).attr('rel'), value = $(this).val();
			if (debug) console.log('[change] on select with ID: '+id+' and value: '+value);
			location.href='?cat=skins&action=articles&id='+group_id+'&gitem_id='+id+'&status='+value;
		});
		$('a.edit').bind('click', function() {
			var ident = $(this).attr('rel'),
				owner = $(this).attr('alt');
			if (debug) console.log('[click] on link with ident: '+ident+', owner: '+owner+' and group_id: '+group_id);
			location.href='?cat=texts&action=edit&ident='+ident+'&owner='+owner+'&group_id='+group_id;
		});
	});
</script>