<h2>aPanel <strong>v2.4.1</strong></h2>
<h3>Welcome to administrative panel,<br /> please select a section you want to administrate.</h3>
<br />
{if $admin}
<div class="apanel a350">
	{include file="global/message.tpl"}
	<h3>Administrative Log-in</h3>
	<p class="info">
		Welcome back,<br />
		<strong>{$admin.name}</strong>.
	</p>
	<p class="info">
		Last login:<br />
		<strong>{$admin.last_active|default:"N/A"}</strong>.
	</p>
	<p class="info">
		Rights:<br />
		<strong>{$admin.type}</strong>.
	</p>
	<p class="info">
		<a href="?cat=home&amp;action=logout">Log-out</a>
	</p>
</div>
{else}
<div class="apanel a350">
	{include file="global/message.tpl"}
	<h3>Administrative Log-in</h3>
	<form method="post" action="" class="aform">
	<fieldset>
		<label>Username</label>
		<input type="text" name="login[username]" value="" class="ainput" />
		<br />
		<label>Password</label>
		<input type="password" name="login[password]" value="" class="ainput" />
		<br />
		<div class="bpanel">
			<input type="submit" name="login[now]" class="abutton" value="Login" />
		</div>
	</fieldset>
	</form>
	<p class="info">
		Please protect your username and password, and<br />
		DO NOT give them to third party!
	</p>
</div>
{/if}