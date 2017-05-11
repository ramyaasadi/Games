{if $smarty.get.filter && $smarty.get.filter!=''}
{assign var='linkadd' value='&amp;filter='|cat:$smarty.get.filter}
{/if}
<p class="">section</p>
<h2>{$pagetitle|default:'Edit Form'}</h2>
<ul class="snav">
	<li><a href="?cat=forms{$linkadd}" class="sel">list</a></li>
	{if $smarty.get.filter=='aboutus' || $smarty.get.filter=='support'}
	<li><a href="?cat=forms&amp;filter={$smarty.get.filter}&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new panel</a></li>
	{/if}
</ul>
<h3>Panel Edit</h3>
{include file="global/message.tpl"}
<form action="" method="post" enctype="multipart/form-data">
<table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">
       <tr><td>&nbsp;</td></tr>
      <tr>
            <td valign="top" width="20%">PHP Formula File (.php)</td>
			<td>Source Code Preview</td>			
      </tr>
      <tr>
            <td valign="top">
                <input type="file" name="php_file" />
                {if $filesize>0}<br><strong style="color: brown">Uploaded: {round($filesize/1024,2)} Kbytes</strong>{/if}
                {if !$file_syntax}<br><br><strong style="color: red;">Warning!!!<br>File contains syntax errors and WILL NOT BE INCLUDED!</strong>{else}<br><br><strong style="color: green;">OK<br>File syntax check passed.</strong>{/if}
                <br><br>
                <b>Example file:</b><br>
                <p style="width: 120px; padding:0; margin: 0;">
                &lt;?php<br><br>[formulas here]<br><br>?&gt;<br><br><b>Assign param:</b> $jrxml_params['EmployerName']=somedata;<br><br><b>Extract Claim Data:</b> $froi_data['EmployerName'];
				</p>                
            </td>
             <td>
               {$preview}<br><br><br><br>
            </td>
      </tr>
      <tr><td>&nbsp;</td></tr>
      <tr>
            <td colspan="4">
                  <input type="submit" name="form[save]" value="Save" class="bt fixed100" />
            </td>
      </tr>
      </table>
</form>