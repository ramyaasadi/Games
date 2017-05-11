{if $smarty.get.filter && $smarty.get.filter!=''}
{assign var='linkadd' value='&amp;filter='|cat:$smarty.get.filter}
{/if}
<p class="">section</p>
<h2>{$pagetitle|default:'UI Forms'}</h2>
<ul class="snav">
	<li><a href="?cat=forms{$linkadd}" class="sel">list</a></li>	
</ul>
<h3>Add New Panel</h3>
{include file="global/message.tpl"}
<form action="" method="post" enctype="multipart/form-data" style="background-color: #F0F0F0">
<br><h2>State Summary</h2>
<table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">    
      <tr>
            <td valign="top" class="bold">State Name</td>
            <td valign="top" class="bold">State Abbrev.</td>
            <td valign="top" class="bold" width="80%">WC Department Name</td>           
            
      </tr>
      <tr>                    
            <td valign="top"><input type="text" name="form[sum_usa_state_name]" value="{$n.sum_usa_state_name}" /></td>
            <td valign="top"><input type="text" name="form[sum_state_abbrev]" value="{$n.sum_state_abbrev}" maxlength="2"  /></td>            
            <td valign="top" width="80%"><input type="text" name="form[sum_wc_department_name]" value="{$n.sum_wc_department_name}" /></td>            
      </tr>
      
      <tr>
      		<td valign="top" colspan="4" class="bold">
      			<div style="padding:10px 0;">
      				<input type="checkbox" name="form[show_on_frontend]"/>Show in Front-End
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
<hr><br><h2>State Statistics</h2>
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
			<td valign="top" colspan="2" class="bold">JRXML File</td>			
      </tr>
      <tr>
            <td valign="top" colspan="2">
                <input type="file" name="rep_xml_file" />
                {if $n.rep_xml_file_size>0}<br><strong style="color: green">Uploaded: {round($n.rep_xml_file_size/1024,2)} Kbytes</strong>{/if}                
            </td>
             <td valign="top" colspan="2">
                <input type="file" name="rep_jrxml_file" />
                {if $n.rep_jrxml_file_size>0}<br><strong style="color: green">Uploaded: {round($n.rep_jrxml_file_size/1024,2)} Kbytes</strong>{/if} 
            </td>
      </tr>
      <tr><td valign="top">&nbsp;</td></tr>
      <tr>
            <td valign="top" colspan="4">
                  <input type="submit" name="form[save]" value="Save" class="bt fixed100" />
            </td>
      </tr>
      </table>
</form>
<br>
<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="js/ckeditor/adapters/jquery.js"></script>
<script type="text/javascript">
{literal}
	$(function() {
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