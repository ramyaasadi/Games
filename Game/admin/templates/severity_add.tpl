<h2>Severity</h2>
<ul class="snav">
	<li><a href="?cat=severity" >Severity List</a></li>
    <li><a href="?cat=severity&amp;action=add&amp;id=999999" class="sel"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> Add Severity </a></li>
</ul>
<h3>Severity</h3><br />
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
      <table width="50%" cellpadding="3" cellspacing="0" border="0" class="std">
		<tr>
            <td>Title</td>
            <td><input type="text" name="severity[title]" value="{$t.title|escape:'html'}" class="in" width="50%" /></td>
		</tr>
        <tr>
            <td>Status</td>
            <td>
			<select name="severity[status]" class="sl">
				<option value='y' {if $t.status == 'y'}selected='selected'{/if}> Active </option>
				<option value='n' {if $t.status == 'n'}selected='selected'{/if}> Inactive </option>
			</select>
			</td>
		</tr>
		<tr>
		<td> &nbsp; </td>
		<td>
			  <input type="submit" name="severity[save]" value="Save Changes" class="bt fixed100" />
		</td>
      </tr>
      </table>
</fieldset>
</form>