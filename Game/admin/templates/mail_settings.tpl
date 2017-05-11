<p class="ss">section</p>
<h2>{$pagetitle|default:'Notifications Settings'}</h2>

{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
    <table cellpadding="5" cellspacing="0" class="std">
	<tbody>
		<tr><td colspan="2"><h3>Mail Settings</h3></td></tr>
		<tr>
			<td>email address</td>
			<td>description</td>
		</tr>
		<tr>
			<td width="200"><input type="text" name="mail[mail_to_auto]" value="{$settings.mail_to_auto}" class="in" /></td>
			<td>Mailbox, that will receive <strong>auto-notifications</strong> (for new/complete quotes)</td>
		</tr>
		<tr>
			<td width="200"><input type="text" name="mail[mail_to_feedback]" value="{$settings.mail_to_feedback}" class="in" /></td>
			<td>Mailbox, that will receive <strong>feedback</strong> form's messages</td>
		</tr>
		<tr>
			<td width="200"><input type="text" name="mail[mail_from]" value="{$settings.mail_from}" class="in" /></td>
			<td>Mailbox, from which will be <strong>send all the messages</strong></td>
		</tr>
		<tr><td colspan="2"><h3>Notifications Settings</h3></td></tr>
		<tr><td colspan="2"><input type="checkbox" name="mail[send_for_new_quote]" value="1"{if $settings.send_for_new_quote>0} checked="checked"{/if} /> Send mail messages for every <strong>newely opened quote</strong>.</td></tr>
		<tr><td colspan="2"><input type="checkbox" name="mail[send_for_complete_quote]" value="1"{if $settings.send_for_complete_quote>0} checked="checked"{/if} /> Send mail messages for every <strong>completed quote</strong>.</td></tr>
		<tr><td colspan="2"><input type="checkbox" name="mail[send_for_complete_quote_user]" value="1"{if $settings.send_for_complete_quote_user>0} checked="checked"{/if} /> Send mail messages to the USER for every <strong>completed quote</strong>.</td></tr>
		<tr><td colspan="2"><input type="checkbox" name="mail[send_for_feedback]" value="1"{if $settings.send_for_feedback>0} checked="checked"{/if} /> Send mail messages for every <strong>feedback request</strong>.</td></tr>
		<tr><td colspan="2"><input type="submit" name="mail[save]" value="Save Settings" class="bt fixed100" /></td></tr>
	</tbody>
	</table>
	{*
	<tr><td colspan="2">Поща, на която ще се изпращат запитванията</td></tr>
	<tr>
		<td><input type="text" name="mail[mail_to]" value="{$settings.mail_to}" class="in" /></td>
		<td><input type="checkbox" name="mail[mail_send]" value="1"{if $settings.mail_send>0} checked="checked"{/if} /> изпращай тези писма</td>
	</tr>
	
	<tr>
	<td colspan="2">Служебна поща, на която фирмата ще получава известия за нови регистрации</td>
	</tr>
	<tr>
	<td><input type="text" name="mail[mail_notify]" value="{$settings.mail_notify}" class="in" /></td>
	<td><input type="checkbox" name="mail[mail_notify_send]" value="1"{if $settings.mail_notify_send>0} checked="checked"{/if} /> изпращай автоматично тези писма</td>
	</tr>
	*}
</fieldset>
</form>