<p class="ss">section</p>
<h2>{$pagetitle|default:'Groups and Skins -> Mail Config'}</h2>
<ul class="snav">
	<li><a href="?cat=skins">group list</a></li>
	<li><a href="?cat=skins&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new group</a></li>
</ul>
<h3>Group: <strong>{$group.title}</strong></h3>
{include file="global/message.tpl"}
<p>&nbsp;</p>
<form action="" method="post" id="sfn">
<fieldset><!-- ######################################################################################################################################################################################### -->

	<table cellpadding="3" cellspacing="0" class="std">
	<tr>
		<th><h3>Primary Mail Settings</h3></th>
	</tr>
	<tr>
		<td>Mail Config:<select name="form[group][mail_config_id]" class="fl">
		{foreach $mail_config_list as $c}<option value="{$c['id']}"{if $c['id']==$group['mail_config_id']} selected="selected"{/if}>{$c['name']}</option>{/foreach}
		</select>
		</td>
		<td>Use Config:<select name="form[group][use_mail_template]" >
			<option value="0">inactive</option>
			<option value="1"{if $group.use_mail_template} selected="selected"{/if}>active</option>
		</select></td>
	</tr>
	<tr><td colspan="2"><span>Send all errors not defined below to:</span><input name="form[group][email_admins]" value="{$group.email_admins}" style="width: 100%" /><br />example: info@claimcompass.com; admin@claimcompass.com; office@claimcompass.com</td></tr>
	<tr><td colspan="2"><i>Note: if &quot;Use Config&quot; is set to <u>inactive</u> none of the following notifications will fire!</i></td></tr>
	</table>
	<hr />
	<!-- !END Admin Emails  -->

<!-- ######################################################################################################################################################################################### -->

	<!-- No Rules Distributed  -->
	<table cellpadding="3" cellspacing="0" class="std" width="100%" id="">
	<tr>
		<th><h3>Rules Distribution</h3></th>
	</tr>
	{if !empty($rd)}{foreach $rd as $i}
	<tr class="{cycle values="even,odd"}">
		<td>Status:<br><select class="fl" name="form[rd][update][{$i.id}][status]">{foreach $claim_distribution_log_status as $k => $v}<option value="{$k}"{if $k==$i.status} selected="selected"{/if}>{$v}</option>{/foreach}</select></td>
		<td>Message:<br><select class="fl" name="form[rd][update][{$i.id}][message]">{foreach $claim_distribution_log_messages as $k => $v}<option value="{$k}"{if $k==$i.message} selected="selected"{/if}>{$v}</option>{/foreach}</select></td>
		<td>Email Template:<br><select class="fl" name="form[rd][update][{$i.id}][email_template]">{foreach $templates_list as $template}<option value="{$template['id']}"{if $template['id']==$i.email_template} selected="selected"{/if}>{$template['name']}</option>{/foreach}</select></td>
		<td>State:<br><select name="form[rd][update][{$i.id}][active]"><option value="0">inactive</option><option value="1"{if $i.active==1} selected="selected"{/if}>active</option></select></td>
		<td>Send To:<br><textarea name="form[rd][update][{$i.id}][send_to]" style="width: 90%" placeholder="ex: info@claimcompass.com; admin@claimcompass.com;">{$i.send_to}</textarea></td>
		<td><input type="button" value="Remove" class="rmrd" rd="{$i.id}" /></td>
	</tr>
	{/foreach}
	{else}
	<tr><td>No records.</td></tr>
	{/if}
	<tr id="ndrw"><td>&nbsp;</td></tr>
	<tr style="display: none" id="dnr">
		<td>Status:<br><select class="fl nd1">{foreach $claim_distribution_log_status as $k => $v}<option value="{$k}">{$v}</option>{/foreach}</select></td>
		<td>Message:<br><select class="fl nd2">{foreach $claim_distribution_log_messages as $k => $v}<option value="{$k}">{$v}</option>{/foreach}</select></td>
		<td>Email Template:<br><select class="fl nd3">{foreach $templates_list as $template}<option value="{$template['id']}">{$template['name']}</option>{/foreach}</select></td>
		<td>State:<br><select class="nd4"><option value="0">inactive</option><option value="1">active</option></select></td>
		<td>Send To:<br><textarea style="width: 90%" class="nd5" placeholder="ex: info@claimcompass.com; admin@claimcompass.com;"></textarea></td>
		<td><input type="button" value="Remove" class="drrm" /></td>
	</tr>
	<tr><td id="ndAddtdx"><input type="button" id="ndAdd" value="Add New Record" /></td></tr>
	</table>
	<hr />
	<!-- !END No Rules Distributed  -->

<!-- ######################################################################################################################################################################################### -->

	<!-- Claim Import Failures  -->
	<table cellpadding="3" cellspacing="0" class="std" width="100%">
		<th><h3>Claim Import Failures</h3></th>
	</tr>
	{if !empty($cif)}{foreach $cif as $i}
	<tr class="{cycle values="even,odd"}">
		<td>Message:<br><select class="fl" name="form[cif][update][{$i.id}][message]">{foreach $import_errors_list as $k => $v}<option value="{$k}"{if $k==$i.message} selected="selected"{/if}>{$v}</option>{/foreach}</select></td>
		<td>Email Template:<br><select class="fl" name="form[cif][update][{$i.id}][email_template]">{foreach $templates_list as $template}<option value="{$template['id']}"{if $template['id']==$i.email_template} selected="selected"{/if}>{$template['name']}</option>{/foreach}</select></td>
		<td>State:<br><select name="form[cif][update][{$i.id}][active]"><option value="0">inactive</option><option value="1"{if $i.active==1} selected="selected"{/if}>active</option></select></td>
		<td>Send To:<br><textarea name="form[cif][update][{$i.id}][send_to]" style="width: 90%" placeholder="ex: info@claimcompass.com; admin@claimcompass.com;">{$i.send_to}</textarea></td>
		<td><input type="button" value="Remove" class="cfrm" rd="{$i.id}" /></td>
	</tr>
	{/foreach}
	{else}
	<tr><td>No records.</td></tr>
	{/if}
	<tr id="cifw"><td>&nbsp;</td></tr>
	<tr style="display: none" id="cfr">
		<td>Message:<br><select class="fl cf1">{foreach $import_errors_list as $k => $v}<option value="{$k}">{$v}</option>{/foreach}</select></td>
		<td>Email Template:<br><select class="fl cf2">{foreach $templates_list as $template}<option value="{$template['id']}">{$template['name']}</option>{/foreach}</select></td>
		<td>State:<br><select class="cf3"><option value="0">inactive</option><option value="1">active</option></select></td>
		<td>Send To:<br><textarea style="width: 90%" class="cf4" placeholder="ex: info@claimcompass.com; admin@claimcompass.com;"></textarea></td>
		<td><input type="button" value="Remove" class="cfarm" /></td>
	</tr>
	<tr><td id="ndAddtdx"><input type="button" id="cifAdd" value="Add New Record" /></td></tr>
	</table>
	<hr />
	<!-- !END No Rules Distributed  -->

<!-- ######################################################################################################################################################################################### -->

	<!-- Org Import Failures  -->
	<table cellpadding="3" cellspacing="0" class="std" width="100%">
	<tr>
		<th><h3>Org Import Failures</h3></th>
	</tr>
	{if !empty($oif)}{foreach $oif as $i}
	<tr class="{cycle values="even,odd"}">
		<td>Message:<br><select class="fl" name="form[oif][update][{$i.id}][message]">{foreach $import_organizations_errors_list as $k => $v}<option value="{$k}"{if $k==$i.message} selected="selected"{/if}>{$v}</option>{/foreach}</select></td>
		<td>Email Template:<br><select class="fl" name="form[oif][update][{$i.id}][email_template]">{foreach $templates_list as $template}<option value="{$template['id']}"{if $template['id']==$i.email_template} selected="selected"{/if}>{$template['name']}</option>{/foreach}</select></td>
		<td>State:<br><select name="form[oif][update][{$i.id}][active]"><option value="0">inactive</option><option value="1"{if $i.active==1} selected="selected"{/if}>active</option></select></td>
		<td>Send To:<br><textarea name="form[oif][update][{$i.id}][send_to]" style="width: 90%" placeholder="ex: info@claimcompass.com; admin@claimcompass.com;">{$i.send_to}</textarea></td>
		<td><input type="button" value="Remove" class="cfrm" rd="{$i.id}" /></td>
	</tr>
	{/foreach}
	{else}
	<tr><td>No records.</td></tr>
	{/if}
	<tr id="oifw"><td>&nbsp;</td></tr>
	<tr style="display: none" id="ofr">
		<td>Message:<br><select class="fl of1">{foreach $import_organizations_errors_list as $k => $v}<option value="{$k}">{$v}</option>{/foreach}</select></td>
		<td>Email Template:<br><select class="fl of2">{foreach $templates_list as $template}<option value="{$template['id']}">{$template['name']}</option>{/foreach}</select></td>
		<td>State:<br><select class="of3"><option value="0">inactive</option><option value="1">active</option></select></td>
		<td>Send To:<br><textarea style="width: 90%" class="of4" placeholder="ex: info@claimcompass.com; admin@claimcompass.com;"></textarea></td>
		<td><input type="button" value="Remove" class="cfarm" /></td>
	</tr>
	<tr><td id="ndAddtdx"><input type="button" id="oifAdd" value="Add New Record" /></td></tr>
	</table>
	<!-- !END Org Import Failures  -->

<!-- ######################################################################################################################################################################################### -->

	<table cellpadding="3" cellspacing="0" class="std" width="90%">
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3"><input type="button" class="bt" name="form[save]" value="Revert" onclick="if(confirm('Loose all changes?!'))location.href='{$url}'" />&nbsp;&nbsp;&nbsp;<input type="submit" class="bt" name="form[save]" value="Save Changes" /></td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>

	</table>
</fieldset>
</form>
<script>
var ndAdd=0, cifAdd=0, oifAdd=0;
$('.drrm').on('click', function(event){
	$(this).parents('tr').remove();
});
$('.rmrd').on('click', function(event){
	$(this).parents('tr').remove();
	$('#sfn').append('<input type="hidden" name="form[rd][delete][]" value="'+$(this).attr('rd')+'" />');
});

$('#ndAdd').on('click', function(event){

	$('#dnr .nd1').attr('name','form[rd][add]['+ndAdd+'][status]');
	$('#dnr .nd2').attr('name','form[rd][add]['+ndAdd+'][message]');
	$('#dnr .nd3').attr('name','form[rd][add]['+ndAdd+'][email_template]');
	$('#dnr .nd4').attr('name','form[rd][add]['+ndAdd+'][active]');
	$('#dnr .nd5').attr('name','form[rd][add]['+ndAdd+'][send_to]');

	$($('#ndrw').before('<tr>'+$('#dnr').html()+'</tr>'));

	$('#dnr .nd1').attr('name','');
	$('#dnr .nd2').attr('name','');
	$('#dnr .nd3').attr('name','');
	$('#dnr .nd4').attr('name','');
	$('#dnr .nd5').attr('name','');
	ndAdd++;

});



$('.cfarm').on('click', function(event){
	$(this).parents('tr').remove();
});
$('.cfrm').on('click', function(event){
	$(this).parents('tr').remove();
	$('#sfn').append('<input type="hidden" name="form[cif][delete][]" value="'+$(this).attr('rd')+'" />');
});

$('#cifAdd').on('click', function(event){

	$('#cfr .cf1').attr('name','form[cif][add]['+cifAdd+'][message]');
	$('#cfr .cf2').attr('name','form[cif][add]['+cifAdd+'][email_template]');
	$('#cfr .cf3').attr('name','form[cif][add]['+cifAdd+'][active]');
	$('#cfr .cf4').attr('name','form[cif][add]['+cifAdd+'][send_to]');

	$($('#cifw').before('<tr>'+$('#cfr').html()+'</tr>'));

	$('#cfr .cf1').attr('name','');
	$('#cfr .cf2').attr('name','');
	$('#cfr .cf3').attr('name','');
	$('#cfr .cf4').attr('name','');
	cifAdd++;

});


$('.ofarm').on('click', function(event){
	$(this).parents('tr').remove();
});
$('.ofrm').on('click', function(event){
	$(this).parents('tr').remove();
	$('#sfn').append('<input type="hidden" name="form[oif][delete][]" value="'+$(this).attr('rd')+'" />');
});

$('#oifAdd').on('click', function(event){

	$('#ofr .of1').attr('name','form[oif][add]['+oifAdd+'][message]');
	$('#ofr .of2').attr('name','form[oif][add]['+oifAdd+'][email_template]');
	$('#ofr .of3').attr('name','form[oif][add]['+oifAdd+'][active]');
	$('#ofr .of4').attr('name','form[oif][add]['+oifAdd+'][send_to]');

	$($('#oifw').before('<tr>'+$('#ofr').html()+'</tr>'));

	$('#ofr .cf1').attr('name','');
	$('#ofr .cf2').attr('name','');
	$('#ofr .cf3').attr('name','');
	$('#ofr .cf4').attr('name','');
	oifAdd++;

});
</script>