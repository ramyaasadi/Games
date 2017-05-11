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
<form action="" method="post" enctype="multipart/form-data" style="background-color: #F0F0F0">
<h2>State Summary</h2>
<table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">    
      <tr>
            <td valign="top" class="bold">State Name</td>
            <td valign="top" class="bold">State Abbrev.</td>
            <td valign="top" class="bold">WC Department Name</td>           
            {if $pdf_file}<td valign="top" class="bold">Preview</td>{/if}  
            
      </tr>
      <tr>                    
            <td valign="top"><input type="text" name="form[sum_usa_state_name]" value="{$n.sum_usa_state_name}" /></td>
            <td valign="top"><input type="text" name="form[sum_state_abbrev]" value="{$n.sum_state_abbrev}" maxlength="2"  /></td>            
            <td valign="top"><input type="text" name="form[sum_wc_department_name]" value="{$n.sum_wc_department_name}" /></td>            
            {if $pdf_file}<td valign="top"><a href="{$pdf_review}" id="pdf_preview" title="{$n.sum_usa_state_name}: {$n.rep_form_name}"><img src="{$pdf_preview}" alt="{$n.sum_usa_state_name}: {$n.rep_form_name}"></a><br><a href="{$pdf_file}" target="_blank">Download PDF</a></td>{/if}         
      </tr>
      <tr>
      		<td valign="top" colspan="4" class="bold">
      			<div style="padding:10px 0;">
      				<input type="checkbox" name="form[show_on_frontend]" {if $n.show_on_frontend==1}checked="true"{/if}/>Show in Front-End
      			</div>
      		</td>
      </tr>
      <tr><td valign="top" colspan="4" class="bold">State Specific Details</td></tr>
      <tr><td valign="top" colspan="4" class="bold"><textarea name="form[sum_each_state_different]" style="width:100%; height: 50px;">{$n.sum_each_state_different}</textarea></td></tr>
      <tr><td valign="top">&nbsp;</td></tr>
      
       <tr>
            <td valign="top" colspan="2" class="bold">State Contact Information</td>
            <td valign="top" colspan="2" class="bold">News and Events</td>           
      </tr>
       <tr>
           <td valign="top" colspan="2"><textarea style="width: 98%; height: 50px;" name="form[sum_wc_details]">{$n.sum_wc_details}</textarea></td>
           <td valign="top" colspan="2"><textarea style="width: 98%; height: 50px;" name="form[sum_news_and_events]">{$n.sum_news_and_events}</textarea></td>
      </tr>
       <tr><td valign="top">&nbsp;</td></tr>
      </table>
      
<hr><br>
<br><h2>State Statistics</h2>
<table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">    
      <tr>
            <td valign="top" class="bold">Year of the statistics</td>            
            <td valign="top" class="bold">Average Annual Employment</td>
            <td valign="top" class="bold"># Of Recordable Work Comp Cases</td>           
            <td valign="top" class="bold"># Of Cases With Lost Work Days</td>     
      </tr>
      <tr>
            <td valign="top"><input type="text" name="form[stat_year_of_stat]" value="{$n.stat_year_of_stat}" class="in" /></td>            
            <td valign="top"><input type="text" name="form[stat_num_average_anual]" value="{$n.stat_num_average_anual}" class="in" /></td>
            <td valign="top"><input type="text" name="form[stat_num_recordable_work_comp]" value="{$n.stat_num_recordable_work_comp}" class="in" maxlength="10" /></td>                        
            <td valign="top"><input type="text" name="form[stat_num_cases_with_lost]" value="{$n.stat_num_cases_with_lost}" class="in" maxlength="10" /></td>                        
      </tr>
      <tr><td valign="top">&nbsp;</td></tr>
      <tr>
           <td valign="top" class="bold">% Of Cases With Lost Work Days</td>           
           <td valign="top" class="bold">% Of Cases Per # of Employees</td>           
            <td valign="top" class="bold">Rev. Date</td>     
            <td valign="top">&nbsp;</td>     
      </tr>
       <tr>
            <td valign="top" valign="top"><input type="text" name="form[stat_perc_cases_with_lost]" value="{$n.stat_perc_cases_with_lost}" class="in" /></td>
            <td valign="top" valign="top"><input type="text" name="form[stat_perc_cases_per_num_of_employees]" value="{$n.stat_perc_cases_per_num_of_employees}" class="in" /></td>
            <td><input type="text" name="form[stat_rev_date]" value="{$n.stat_rev_date}" class="in" /></td>
            <td>&nbsp;</td>
      </tr>      
      <tr><td valign="top">&nbsp;</td></tr>
      <tr><td valign="top" colspan="4" class="bold">Memo</td></tr>
      <tr><td valign="top" colspan="4"><textarea name="form[stat_memo]" style="width: 100%; height: 50px;">{$n.stat_memo}</textarea></td></tr>
      <tr><td valign="top">&nbsp;</td></tr>
      </table>
   <hr><br>
   <h2>State Report</h2>
      <table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">    
      <tr>
            <td valign="top" colspan="2" class="bold">Form Name</td>            
            <td valign="top" class="bold">Form #</td>
            <td valign="top" class="bold">Preferred Method</td>     
            <td valign="top" class="bold">Type</td>      
            
      </tr>
      <tr>
            <td valign="top" colspan="2"><input type="text" name="form[rep_form_name]" value="{$n.rep_form_name}" class="in" /></td>            
            <td valign="top"><input type="text" name="form[rep_form_id]" value="{$n.rep_form_id}"  maxlength="12" width="50" /></td>
            <td valign="top"><input type="text" name="form[rep_preferred_method]" value="{$n.rep_preferred_method}" /></td>
            <td valign="top"><select name="form[rep_type]"><option value="1">FROI</option></select></td>                        
      </tr>      
      <tr><td valign="top">&nbsp;</td></tr>
      <tr>
            <td valign="top" colspan="2" class="bold">UI Form XML File</td>
			<td valign="top" colspan="1" class="bold">JRXML File</td>	
			<td valign="top" colspan="2" class="bold">EPDF</td>		
      </tr>
      <tr>
            <td valign="top" colspan="2">
                <input type="file" name="rep_xml_file" />
                {if $n.rep_xml_file_size>0}<br><strong style="color: green">Uploaded: {round($n.rep_xml_file_size/1024,2)} Kbytes</strong>{/if}                
            </td>
             <td valign="top" colspan="1">
                <input type="file" name="rep_jrxml_file" />
                {if $n.rep_jrxml_file_size>0}<br><strong style="color: green">Uploaded: {round($n.rep_jrxml_file_size/1024,2)} Kbytes</strong>{/if} 
            </td>
            <td valign="top" colspan="2">
                <input type="file" name="rep_epdf_file" />
                {if $n.rep_epdf_file}<br><strong style="color: green">Uploaded</strong>{/if}
            </td>
      </tr>
      {if $n.rep_xml_file_size>0}
      <tr><td valign="top">&nbsp;</td></tr>      
      <tr>
            <td valign="top" colspan="4">             
                <a href="/report2blank.php?id={$n.id}">Download Blank</a>                
            </td>           
      </tr>
      {/if}
       <tr><td valign="top">&nbsp;</td></tr>
      </table>
      <hr><br>
   <h2>State Delivery</h2>
      <table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">
      
      <tr>
            <td valign="top" class="bold">Actual Delivery Method</td>            
            <td valign="top" class="bold">WC Dept Fax # (Private EE)</td>
            <td valign="top" class="bold">WC Dept Fax # (Public EE)</td>     
            <td valign="top" class="bold">WC Dept Email Addresss</td>      
            <td valign="top" class="bold">WC Dept Email Config</td>      
            
      </tr>
      
      <tr>
      	<td valign="top">
      	<select name="form[delivery_method]">      		
      		<option value="1"{if $n.delivery_method==1} selected="selected"{/if}>Fax</option>
      		<option value="2"{if $n.delivery_method==2} selected="selected"{/if}>Email</option>
      		<option value="3"{if $n.delivery_method==3} selected="selected"{/if}>EDI R1</option>
      		<option value="4"{if $n.delivery_method==4} selected="selected"{/if}>EDI R2</option>
      		<option value="5"{if $n.delivery_method==5} selected="selected"{/if}>EDI R3</option>
      		<option value="6"{if $n.delivery_method==6} selected="selected"{/if}>US Mail</option>
      	</select>
      	</td>
      	<td><input type="text" name="form[delivery_wc_dep_fax_private]" value="{$n.delivery_wc_dep_fax_private}"  width="50" /></td>
      	<td><input type="text" name="form[delivery_wc_dep_fax_public]" value="{$n.delivery_wc_dep_fax_public}"  width="50" /></td>
      	<td><input type="text" name="form[delivery_wc_dep_email]" value="{$n.delivery_wc_dep_email}"  width="50" /></td>
      	<td><select name="form[delivery_wc_dep_email_config]"><option value="0">Default</option>{section name=mail_config loop=$mconfig}<option value="{$mconfig[mail_config].id}"{if $mconfig[mail_config].id==$n.delivery_wc_dep_email_config} selected="selected"{/if}>{$mconfig[mail_config].name}</option>{/section}</select></td>
      	
      </tr>    
      
      <tr><td valign="top">&nbsp;</td></tr>
      
      <tr>
         <td valign="top" class="bold">FTP Host</td>            
         <td valign="top" class="bold">FTP Port</td>
         <td valign="top" class="bold">FTP Username</td>     
         <td valign="top" class="bold">FTP Password</td>      
         <td valign="top" class="bold">FTP Subfolder</td>
      </tr>      
      <tr>
      	<td><input type="text" name="form[delivery_ftp_host]" value="{$n.delivery_ftp_host}" width="50" /></td>
      	<td><input type="text" name="form[delivery_ftp_port]" value="{$n.delivery_ftp_port}"  width="50" /></td>
      	<td><input type="text" name="form[delivery_ftp_username]" value="{$n.delivery_ftp_username}"  width="50" /></td>
      	<td><input type="text" name="form[delivery_ftp_password]" value="{$n.delivery_ftp_password}"  width="50" /></td>      	
      	<td><input type="text" name="form[delivery_ftp_folder]" value="{$n.delivery_ftp_folder}"  width="50" /></td>
      </tr>
      
      <tr><td valign="top">&nbsp;</td></tr>
      
      <tr>
         <td valign="top" class="bold">US Mail Admin Email Address </td>
         <td valign="top" class="bold">US Mail Address 1</td>     
         <td valign="top" class="bold">US Mail Address 2</td>      
         <td valign="top" class="bold">US Mail City</td>
         <td valign="top" class="bold">US Mail State</td>             
      </tr>      
      <tr>
      	<td><input type="text" name="form[delivery_us_mail_admin_email]" value="{$n.delivery_us_mail_admin_email}" width="50" /></td>
      	<td><input type="text" name="form[delivery_us_mail_address1]" value="{$n.delivery_us_mail_address1}" width="50" /></td>
      	<td><input type="text" name="form[delivery_us_mail_address2]" value="{$n.delivery_us_mail_address2}" width="50" /></td>
      	<td><input type="text" name="form[delivery_us_mail_city]" value="{$n.delivery_us_mail_city}" width="50" /></td>
      	<td><input type="text" name="form[delivery_us_mail_state]" value="{$n.delivery_us_mail_state}" width="50" /></td>
      </tr>        
      
      <tr><td valign="top">&nbsp;</td></tr>
      
      <tr>       
         <td valign="top" class="bold">US Mail Zip</td>
         <td valign="top" class="bold">US Mail Admin Email Config</td>
      </tr>      
      <tr>
      	<td><input type="text" name="form[delivery_us_mail_zip]" value="{$n.delivery_us_mail_zip}" width="50" /></td>
      	<td colspan="3"><select name="form[delivery_us_mail_admin_email_config]"><option value="0">Default</option>{section name=mail_config loop=$mconfig}<option value="{$mconfig[mail_config].id}"{if $mconfig[mail_config].id==$n.delivery_us_mail_admin_email_config} selected="selected"{/if}>{$mconfig[mail_config].name}</option>{/section}</select></td>      	
      </tr>        
      
      <tr><td valign="top">&nbsp;</td></tr>
      <tr>
            <td valign="top" colspan="4">
                  <input type="submit" name="form[save]" value="Save" class="bt fixed100" />
            </td>
      </tr>
       <tr><td valign="top">&nbsp;</td></tr> <tr><td valign="top">&nbsp;</td></tr>
      </table>
</form>
<br />
	
<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="js/ckeditor/adapters/jquery.js"></script>
<script type="text/javascript">
{literal}
	$(function() {
		$('a#pdf_preview').colorbox();
		
		var config = {
			toolbar: [
				{ name: 'basicstyles', items : [ 'Source','RemoveFormat','-','Bold','Italic','Underline','Strike'] },
				{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
				{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
				{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule', 'Styles'] },
				'/',
				{ name: 'styles', items : [ 'Format','Font','FontSize' ] },
				{ name: 'colors', items : [ 'TextColor','BGColor' ] }
			],

			skin:'kama'
		};
	
		$('textarea').ckeditor(config);
	});
{/literal}
</script>