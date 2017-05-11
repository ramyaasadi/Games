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
<h3>Add New</h3>
{include file="global/message.tpl"}
<form action="" method="post" enctype="multipart/form-data">
<fieldset>
      <table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">
      <tr>
            <td colspan="2">Title</td>
            <td>Subtitle</td>
            <td>Short name (for menus)</td>
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
            <td width="25%"><input type="text" name="text[identifier]" value="{$n.identifier|default:$identifier}" class="in" /></td>
            <td width="25%"><input type="text" name="text[owner]" value="{$n.owner|default:$owner}" class="in" /></td>
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
            <td valign="top"><input type="text" name="text[image_width]" value="{$n.image_width|default:200}" class="in" /></td>
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
            <td colspan="4">
                  <input type="submit" name="text[save]" value="Запиши" class="bt fixed100" />
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