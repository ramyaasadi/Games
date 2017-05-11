<p class="ss">section</p>
<h2>Members</h2>

<ul class="snav">
    <li><a href="?cat=members&action=list"{if $filter=='all'} class="sel"{/if}><em>{$stats.members.all|default:0}</em> all members</a></li>
	<li><a href="?cat=members&action=list&filter=for-approval"{if $filter=='for-approval'} class="sel"{/if}><em>{$stats.members.for_approval|default:0}</em> awaiting approval</a></li>
	<li><a href="?cat=members&action=list&filter=approved"{if $filter=='approved'} class="sel"{/if}><em>{$stats.members.approved|default:0}</em> approved</a></li>
	<li><a href="?cat=members&action=add&id=99999999" class="sel"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add member</a></li>
</ul>
<h3>{$intitle|default:'Members List'}</h3>

<form action="" method="post">
<fieldset>
	{if $message.type=='success'}
	{include file="global/message.tpl"}
	{else}
	{include file="global/message.tpl"}
	<table cellpadding="3" cellspacing="0" class="std">
	<tbody>
		<tr>
			<th>First Name <strong><em>*</em></strong></th>
			<td><input type="text" name="form[first_name]" value="{$form.first_name}" class="in" /></td>
		</tr>
		<tr>
			<th>Last Name <strong><em>*</em></strong></th>
			<td><input type="text" name="form[last_name]" value="{$form.last_name}" class="in" /></td>
		</tr>
		<tr>
			<th>Email <strong><em>*</em></strong></th>
			<td><input type="text" name="form[email]" value="{$form.email}" class="in" /></td>
		</tr>
		<tr>
			<th>Phone <strong><em>*</em></strong></th>
			<td><input type="text" name="form[phone]" value="{$form.phone}" class="in" /></td>
		</tr>
		<tr>
			<th>School</th>
			<td><input type="text" name="form[school]" value="{$form.school}" class="in" /></td>
		</tr>
		<tr>
			<td colspan="2"><hr /></td>
		</tr>
		<tr>
			<th>Username <strong><em>*</em></strong></th>
			<td><input type="text" name="form[username]" value="{$form.username}" class="in" /></td>
		</tr>
		<tr>
			<th>Password <strong><em>**</em></strong></th>
			<td><input type="password" name="form[new_pass]" value="" class="in" /></td>
		</tr>
		<tr>
			<th>Password Confirmation <strong><em>***</em></strong></th>
			<td><input type="password" name="form[pass_confirm]" value="" class="in" /></td>
		</tr>
		<tr>
			<td colspan="2"><input type="submit" name="form[save]" value="Register User" class="bt" /></td>
		</tr>
	</tbody>
	</table>
	{/if}
</fieldset>
</form>
<div class="clear"></div>
<p class="legend">
	<strong><em>*</em></strong> all this fields are recommended, but not required in order to complete registration.<br />
	<strong><em>**</em></strong> password must be atleast 6 symbols, latin characters or numbers only.<br />
	<strong><em>***</em></strong> confirmation must match the password.
</p>