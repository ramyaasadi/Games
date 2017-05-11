{literal}
<style>
.status_onhold,.status_closed{color:#d60000}
.status_ended{color:#555}
.status_callback{color:#d60000}
.status_willcall{color:green}
.status{font-family:Tahoma,Verdana,sans-serif;font-size:8pt;font-weight:bold}
.status.success{color:green}
.status.error{color:#d60000}
.bt1 { border-bottom:none!important; cursor:pointer; font-size: 8pt!important; padding:4px 7px!important;}
.bt1:hover { color: #ccc;}
</style>

<script>
function check()
{
	var chk_arr =  document.getElementsByName("chkids[]");
	var txt = "";
		var i;    
			
	for (i = 0; i < chk_arr.length; i++) {
			if (chk_arr[i].checked) {
				txt = txt + chk_arr[i].value + " ";
			}
		}

	if(txt=='') { alert('You must select atleast one checkbox.'); return false;}
	return confirm('Are you sure you want to erase selected calls ?');

}
</script>

{/literal}
<div class="panel">
<form action="?cat=triage_queue&action=eraseselected" method="post" name="form1" id="form1" onsubmit="return check()">
	<br><p class="ss">Recent Calls</p><br>
		<h2>
			<strong style="color: #d60000; font-size: 16pt;">{$stats_hold|default:0}</strong> Calls On Hold /
			<strong style="color: #000; font-size: 16pt;">{$stats_pending|default:0}</strong> In Queue
		</h2>
		<ul class="snav">
			<li><a href="?cat=triage_queue" class="sel">Recent Calls</a></li>
			<li style='float:right'><input type='submit' name='deleteselected' class='bt bt1' id='deleteselected' value='Delete Selected' /></li>
		</ul>
		{if $message}
			<strong style="color: #{if $message.type=='error'}FF0000{else}00FF00{/if};">{$message.text}</strong>
			<br />
		{/if}
		
		<table width="100%" cellpadding="3" cellspacing="0" class="std">
			<thead>
				<tr>
					<th>Employee Name</th>
					<th>Current Call Status</th>
					<th>Phone Number</th>
					<th>Injury Type | POB | Nature</th>
					<th>Benefit State</th>
					<th>Incident #</th>
					<th>Incident Type</th>
					<th>Time in Queue</th>
					<th>&nbsp;</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
			{if $calls}
			{foreach $calls as $call}
				{if $call.deleted == 0}
				<tr class="state_{$call.benefit_state|lower} {if $call@first}lastone{/if}" call_id="{$call.call_id|default:0}">
					<td> <input type="checkbox" id="checkids" name="chkids[]" value='{$call.call_id}'>
						{if $call@first}
						
							<a target="_blank" href="/triage_wizard.php?id={$call.call_id}" rel="call_audit">{$call.claimant_first_name} {$call.claimant_last_name}</a>
						
						{else}
						<a target="_blank" href="/triage_wizard.php?id={$call.call_id}" rel="call_audit">{$call.claimant_first_name} {$call.claimant_last_name}</a>
						{/if}
					</td>
					<td>
						<strong class="status_{$call.call_status|default:''}">{$calls_status[$call.call_status]|default:'Unknown'}</strong>
					</td>
					<td>{$call.call_number}</td>
					<td>
						{capture assign="tmpRow"}
						{$call.injury_description|default:'N/A'|truncate:20} | {$call.injury_part_of_body_description|default:'N/A'|truncate:20} | {$call.injury_cause_description|default:'N/A'|truncate:20}
						{/capture}
						{$tmpRow|truncate:60}
					</td>
					<td>{$call.benefit_state}</td>
					<td>
						{if $call.id|default:0 > 0}
						{$smarty.session.group.ref_prefix|default:''}{$call.id}
						{else}N/A
						{/if}
					</td>
					<td>{$call.claim_result_description}</td>
					<td>
						<strong>{$call.lag}</strong>
					</td>
					<td>
						<a href="javascript: if (confirm('Are you sure you want to erase this call?')) location.href='?cat=triage_queue&amp;action=erase&amp;id={$call.call_id}';"><img src="interface/icons/erase.gif" alt="erase" align="absmiddle" title="Erase Call" /></a>
					</td>
					<td>
						&nbsp;
					</td>
				</tr>
				{/if}
			{/foreach}
			{/if}
			</tbody>
		</table>
		</form>
</div>
{include file="global/pg.tpl" paging=$paging}