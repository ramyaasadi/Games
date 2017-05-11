<h2>Accident code</h2>
<ul class="snav">
	<li><a href="?cat=accidentcode" >Accident code List</a></li>
    <li><a href="javascript:void(0);" class="sel"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> Update accident code </a></li>
</ul>
<h3>Accident code</h3><br />
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
      <table width="70%" cellpadding="3" cellspacing="0" border="0" class="std">
		<tr class='tble_header'>
            <td width="140">Title</td>
            <td><input type="text" name="accidentcode[title]" value="{$t.title|escape:'html'}" class="in" width="50%" /></td>
		</tr>
		<tr class='tble_header'>
            <td width="140">Description</td>
            <td><input type="text" name="accidentcode[desc]" value="{$t.description}" class="in" width="50%" /></td>
		</tr>
		<tr>
            <td>Nature of Accident Code</td>
            <td>
			<select name="accidentcode[code]" class="sl">
			{for $lop=1 to 125}
				<option value='{$lop}' {if ($t.code == $lop)} selected {/if}> Nature of Accident Code - {$lop} </option>
			{/for}
			</select>
			</td>
		</tr>
		<tr class='tble_header'>
            <td>Medical Guidelines</td>
            <td>
			
			{foreach from=$list item=item}			
			<div style="width:300px; float:left;">
			<input type="checkbox" name="accidentcode[guidelines][]" id="guidelines" value="{$item.id}" {if in_array($item.id,$guidelinecodes)} checked {/if}> {$item.title}
			</div>
			{/foreach}
			
			</td>
		</tr>
        <tr>
            <td>Status</td>
            <td>
			<select name="accidentcode[status]" class="sl">
				<option value='y' {if $t.status == 'y'}selected='selected'{/if}> Active </option>
				<option value='n' {if $t.status == 'n'}selected='selected'{/if}> Inactive </option>
			</select>
			</td>
		</tr>
		<tr>
		<td> &nbsp; </td>
		<td>
			  <input type="submit" name="accidentcode[save]" value="Save Changes" class="bt fixed100" />
		</td>
      </tr>
      </table>
</fieldset>
</form>