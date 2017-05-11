{if $smarty.get.filter && $smarty.get.filter!=''}
{assign var='linkadd' value='&amp;filter='|cat:$smarty.get.filter}
{/if}
<p class="ss">section</p>
<h2>{$pagetitle|default:'Text Panels'}</h2>
<ul class="snav">
	<li><a href="?cat=texts{$linkadd}" class="sel">panel list</a></li>
	{if $smarty.get.filter=='aboutus' || $smarty.get.filter=='support'}
	<li><a href="?cat=texts&amp;filter={$smarty.get.filter}&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new panel</a></li>
	{/if}
</ul>
{if $group.id|default:0 > 0}
<h3>Group: <strong>{$group.title}</strong></h3>
<nav class="stab">
	<a href="?cat=skins&action=edit&id={$group.id}"><img src="interface/icons/pencil.png" alt="edit" align="absmiddle" title="Edit Group's Data" /> edit</a>
	<a href="?cat=skins&action=skin&id={$group.id}"><img src="interface/icons/skins.gif" alt="skin" align="absmiddle" title="Customize Group's Skin" /> skin</a>
	<a href="?cat=skins&action=articles&id={$group.id}"><img src="interface/icons/articles.png" alt="skin" align="absmiddle" title="Edit Group's Articles" /> <strong>articles</strong></a>
</nav>
<p class="ss">
	identifier: <strong>{$group.ident}</strong><br />
	active: <strong>{if $group.active==1}yes{else}no{/if}</strong><br />
	created: <strong>{include file="global/date_format.tpl" date=$group.created}</strong><br />
	updated: <strong>{include file="global/date_format.tpl" date=$group.updated}</strong>
</p>
{/if}
<h3>Panel Edit</h3>
{include file="global/message.tpl"}
<form action="" method="post" enctype="multipart/form-data">
<fieldset>
	  <table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">
	  <tr>
			<td colspan="2">Title</td>
			<td>Subtitle</td>
			<td>Short name</td>
	  </tr>
	  <tr>
			<td colspan="2"><input type="text" name="text[title]" value="{$n.title}" class="in" /></td>
			<td><input type="text" name="text[subtitle]" value="{$n.subtitle}" class="in" /></td>
			<td><input type="text" name="text[name]" value="{$n.name}" class="in" /></td>
	  </tr>
	  <tr>
			<td colspan="4">Content</td>
	  </tr>
	  <tr>
			<td colspan="4"><textarea name="text[body]" class="std" rows="20" id="ckedit">{$n.body}</textarea></td>
	  </tr>
	  <tr>
			<td>Date</td>
			<td>Position</td>
			<td>Identifier</td>
			<td>Owner</td>
	  </tr>
	  <tr>
			<td width="25%"><input type="text" name="text[date]" value="{$n.date}" class="in" /></td>
			<td width="25%"><input type="text" name="text[position]" value="{$n.position}" class="in" /></td>
			<td width="25%"><input type="text" name="text[identifier]" value="{$n.identifier}" class="in" disabled="disabled" /></td>
			<td width="25%"><input type="text" name="text[owner]" value="{$n.owner}" class="in" disabled="disabled" /></td>
	  </tr>
	  <tr>
			<td>Photos {if $n.image && $n.image!=''}(<a href="/photos/texts/{$n.image}" target="preview">view photos</a>){/if}</td>
			<td>Width (in px)</td>
			<td>Position</td>
			<td>Border</td>
	  </tr>
	  <tr>
			<td>
				<input type="file" name="text[image]" />
				{if $n.image && $n.image!=''}
				<br />
				<input type="checkbox" name="text[remove_image]" value="1" /> remove photos
				{/if}
			</td>
			<td valign="top"><input type="text" name="text[image_width]" value="{$n.image_width}" class="in" /></td>
			<td valign="top">
				<select name="text[image_position]" class="sl">
					<option value="image_left" {if $n.image_position=='image_left'}selected="selected"{/if}>in left</option>
					<option value="image_right" {if $n.image_position=='image_right'}selected="selected"{/if}>in right</option>
					<option value="gallery" {if $n.image_position=='gallery'}selected="selected"{/if}>gallery below</option>
				</select>
			</td>
			<td valign="top">
				<select name="text[image_border]" class="sl">
					<option value="std_border" {if $n.image_border=='std_border'}selected="selected"{/if}>standard</option>
					<option value="thin_border" {if $n.image_border=='thin_border'}selected="selected"{/if}>thin</option>
					<option value="no_border" {if $n.image_border=='no_border'}selected="selected"{/if}>no border</option>
				</select>
			</td>
	  </tr>
	  <tr>
			<td>Photos 2 {if $n.image2 && $n.image2!=''}(<a href="/photos/texts/{$n.image2}" target="preview">view photos</a>){/if}</td>
			<td colspan="3">Photos 3 {if $n.image3 && $n.image3!=''}(<a href="/photos/texts/{$n.image3}" target="preview">view photos</a>){/if}</td>
	  </tr>
	  <tr>
			<td>
				<input type="file" name="text[image2]" />
				{if $n.image2 && $n.image2!=''}
				<br />
				<input type="checkbox" name="text[remove_image2]" value="1" /> remove photos
				{/if}
			</td>
			<td colspan="3">
				<input type="file" name="text[image3]" />
				{if $n.image3 && $n.image3!=''}
				<br />
				<input type="checkbox" name="text[remove_image3]" value="1" /> remove photos
				{/if}
			</td>
	  </tr>
	  <tr>
			<td colspan="4">
				  <input type="submit" name="text[save]" value="Save Changes" class="bt fixed100" />
			</td>
	  </tr>
	  </table>
</fieldset>
</form>
<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="js/ckeditor/adapters/jquery.js"></script>
<script type="text/javascript" src="js/ckfinder/ckfinder.js"></script>
<script type="text/javascript">
{literal}
	$(function() {
		var editor = CKEDITOR.replace( 'ckedit' );
		CKFinder.setupCKEditor( editor, './js/ckfinder/' );
	});
{/literal}
</script>