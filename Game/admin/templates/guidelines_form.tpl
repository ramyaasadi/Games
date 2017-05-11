<h2>Guidelines</h2>
<ul class="snav">
	<li><a href="?cat=guidelines" >Guidelines List</a></li>
    <li><a href="javascript:void(0);" class="sel"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> Update Guideline </a></li>
</ul>
<h3>Guidelines</h3><br />
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
      <table width="50%" cellpadding="3" cellspacing="0" border="0" class="std">
		<tr class='tble_header'>
            <td>Title</td>
            <td><input type="text" name="guideline[title]" value="{$t.title|escape:'html'}" class="in" width="50%" /></td>
		</tr>
        <tr>
            <td>Status</td>
            <td>
			<select name="guideline[status]" class="sl">
				<option value='y' {if $t.status == 'y'}selected='selected'{/if}> Active </option>
				<option value='n' {if $t.status == 'n'}selected='selected'{/if}> Inactive </option>
			</select>
			</td>
		</tr>
		<tr>
		<td> &nbsp; </td>
		<td>
			  <input type="submit" name="guideline[save]" value="Save Changes" class="bt fixed100" />
		</td>
      </tr>
      </table>
</fieldset>
</form>