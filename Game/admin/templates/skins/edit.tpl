<p class="ss">section</p>
<h2>{$pagetitle|default:'Groups and Skins'}</h2>
<ul class="snav">
	<li><a href="?cat=skins">group list</a></li>
	<li><a href="?cat=skins&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new group</a></li>
</ul>
<h3>Group: <strong>{$data.title}</strong></h3>
<nav class="stab">
	<a href="?cat=skins&action=edit&id={$data.id}"><img src="interface/icons/pencil.png" alt="edit" align="absmiddle" title="Edit Group's Data" /> <strong>edit</strong></a>
	<a href="?cat=skins&action=skin&id={$data.id}"><img src="interface/icons/skins.gif" alt="skin" align="absmiddle" title="Customize Group's Skin" /> skin</a>
	<a href="?cat=skins&action=articles&id={$data.id}"><img src="interface/icons/articles.png" alt="skin" align="absmiddle" title="Edit Group's Articles" /> articles</a>
	<a href="?cat=skins&action=email&id={$data.id}"><img src="interface/icons/mail.gif" alt="email config" align="absmiddle" title="Edit Email Settings" /> email config</a>
	<a href="?cat=skins&action=terms&id={$data.id}"><img src="interface/icons/terms.png" alt="skin" align="absmiddle" title="Edit Group's Terms" /> terms</a>
	<a href="?cat=skins&action=advanced&id={$data.id}"><img src="interface/icons/database.gif" alt="advanced config" align="absmiddle" title="Advanced Config" /> advanced config</a>
</nav>
<p class="ss">
	created: <strong>{include file="global/date_format.tpl" date=$data.created}</strong><br />
	updated: <strong>{include file="global/date_format.tpl" date=$data.updated}</strong>
</p>
<h3>Edit Group</h3>
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
	<table cellpadding="3" cellspacing="0" class="std">
	<tr>
		<th>title</th>
		<th>identifier</th>
		<th>home link url (default must be '/')</th>
		<th>group auto-apply url</th>
		<th>auto-redirect url</th>
		<th>reference # prefix</th>
		<th>active</th>
	</tr>
	<tr>
		<td><input type="text" class="in" name="form[title]" value="{$data.title}" /></td>
		<td><input type="text" class="in" name="form[ident]" value="{$data.ident}" /></td>
		<td><input type="text" class="in" name="form[home_url]" value="{$data.home_url|default:'/'}" /></td>
		<td><input type="text" class="in" name="form[auto_url]" value="{$data.auto_url|default:''}" /></td>
		<td><input type="text" class="in" name="form[redirect_url]" value="{$data.redirect_url|default:''}" /></td>
		<td><input type="text" class="in" name="form[ref_prefix]" value="{$data.ref_prefix|default:''}" /></td>
		<td><select name="form[active]" class="sl">
			<option value="0"{if $data.active==0} selected="selected"{/if}>inactive</option>
			<option value="1"{if $data.active==1} selected="selected"{/if}>active</option>
		</select></td>
	</tr>
	<tr><td colspan="7"><input type="submit" class="bt" name="form[save]" value="Save Changes" /></td></tr>
	</table>
</fieldset>
</form>

<p class="legend">
    <strong>Important:</strong><br />
    &bull; the identifier must be unique <br />
    &bull; from the "home link url" you can point out different url for the "Home" button, you can use url's like that "/contact.php" or even "http://yahoo.com" <br />
    &bull; "auto url" field gives you the option to determine on which url this group setting's will be applied automatically. Fill up just the url (ie "claimcompass.com"), don't put "http://" at front <br />
    &bull; if you put ANY url in the "auto-redirect" field then if the browser hits an address "/" will auto-redirect to the address in the field
</p>