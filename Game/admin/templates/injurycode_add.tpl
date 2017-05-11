<h2>Injury code</h2>
<ul class="snav">
	<li><a href="?cat=injurycode" >Injury code List</a></li>
    <li><a href="?cat=injurycode&amp;action=add&amp;id=999999" class="sel"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> Add Injury code </a></li>
</ul>
<h3>Injury code</h3><br />
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
      <table width="70%" cellpadding="3" cellspacing="0" border="0" class="std">
		<tr>
            <td width="140">Title</td>
            <td><input type="text" name="injurycode[title]" value="{$t.title|escape:'html'}" class="in" width="50%" /></td>
		</tr>
		<tr>
            <td>Nature of Injury Code</td>
            <td>
			<select name="injurycode[code]" class="sl">
			{for $lop=1 to 125}
				<option value='{$lop}'> Nature of Injury Code - {$lop} </option>
			{/for}
			</select>
			</td>
		</tr>
		<tr class='tble_header'>
            <td>Medical Guidelines</td>
            <td>
			{foreach from=$list item=item}
			<div style="width:300px; float:left;">
			<input type="checkbox" name="injurycode[guidelines][]" id="guidelines" value="{$item.id}"> {$item.title}
			</div>
			{/foreach}
			</td>
		</tr>
        <tr>
            <td>Status</td>
            <td>
			<select name="injurycode[status]" class="sl">
				<option value='y' {if $t.status == 'y'}selected='selected'{/if}> Active </option>
				<option value='n' {if $t.status == 'n'}selected='selected'{/if}> Inactive </option>
			</select>
			</td>
		</tr>
		<tr>
		<td> &nbsp; </td>
		<td>
			  <input type="submit" name="injurycode[save]" value="Save Changes" class="bt fixed100" />
		</td>
      </tr>
      </table>
</fieldset>
</form>