<h2><a href="?cat=guidelines" style="text-decoration: none;" > Guidelines </a> > Questions</h2>
<ul class="snav">
	<li><a href="?cat=questions" >Questions List</a></li>
    <li><a href="javascript:void(0);" class="sel"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> Update Question </a></li>
</ul>
<h3>Questions</h3><br />
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
      <table width="50%" cellpadding="3" cellspacing="0" border="0" class="std">
		<tr class='tble_header'>
            <td width="25%">Question</td>
            <td><textarea type="text" name="question[question]" class="in" rows="5" style="width:93%">{$t.question|escape:'html'}</textarea></td>
		</tr>
		<tr>
            <td>Severity</td>
            <td>
			<select name="question[severity]" class="sl">
			<option value=""> Select Severity </option>
			{foreach from=$severitylist item=item}
				<option value='{$item.id}' {if $t.severity == $item.id}selected='selected'{/if}> {$item.title} </option>
			{/foreach}
			</select>
			</td>
		</tr>
		<tr>
            <td>Guideline</td>
            <td>
			<select name="question[guideline_id]" class="sl">
			<option value=""> Select Guideline </option>
			{foreach from=$guidelinelist item=itemg}
				<option value='{$itemg.id}' {if $t.guideline_id == $itemg.id}selected='selected'{/if}> {$itemg.title} </option>
			{/foreach}
			</select>
			</td>
		</tr>
        <tr>
            <td>Status</td>
            <td>
			<select name="question[status]" class="sl">
				<option value='y' {if $t.status == 'y'}selected='selected'{/if}> Active </option>
				<option value='n' {if $t.status == 'n'}selected='selected'{/if}> Inactive </option>
			</select>
			</td>
		</tr>
		<tr>
		<td> &nbsp; </td>
		<td>
			  <input type="submit" name="question[save]" value="Save Changes" class="bt fixed100" />
		</td>
      </tr>
      </table>
</fieldset>
</form>