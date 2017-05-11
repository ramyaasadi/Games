<p>&nbsp;</p>
<h2>Generate Report / Export</h2>
<hr />
<form action="" method="post" id="form_generate">
<table cellspacing="1" border="0" width="100%;">
 <tbody>
  <tr>
   <td class="bold" width="160">Location:</td>
   <td colspan="2" height="50" >
		<input type="text" name="injury_location" id="locations_search_suggest" style="width: 580px;" value="">
		<button id="clear_loc" class="dnone">Clear</button>
	</td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
	<td class="bold">Report type:</td>
	<td>
	<select name="report_id" id="report_id">
		<option value="1" class="permanent">First Report of Injury</option>
		{foreach $custom_reports as $custom_report}<option value="{$custom_report['id']}">{$custom_report['title']}</option>{/foreach}
		<option value="8" class="permanent">Export (CN XML)</option>
		<option value="6" class="permanent">Export (IVOS)</option>
		<option value="5" class="permanent">Export (MN XML)</option>
		<option value="4" class="permanent">Export (MN ZIP)</option>
		<option value="7" class="permanent">Export (MVSC)</option>
		<option value="10" class="permanent">Export (PMA)</option>
		<option value="3" class="permanent">Export (York)</option>
	</select>
	</td>
  </tr>
  <tr class="froi_state"><td>&nbsp;</td></tr>
  <tr class="froi_state">
	<td class="bold">FROI State:</td>
	<td>
	<select name="state" id="state_id" data-placeholder="Type to search...">
	{foreach $available_forms as $form}{if $form['show_on_frontend']==1}<option value="{$form['sum_state_abbrev']}">{$form['sum_usa_state_name']}</option>{/if}{/foreach}
	</select>
	</td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
	<td class="bold">Claim #:</td>
	<td><input type="text" name="claim_id" value="3" style="width: 62px; text-align: center;" maxlength="6" /></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
	<td class="bold">Ready?</td>
	<td><input type="submit" value="Go!" /></td>
  </tr>
</tbody>
</table>
	<p>&nbsp;</p>
	{include message=$errors file="global/message.tpl"}
	{if !empty($output1)}{$output1}{/if}
	{if !empty($output2)}{$output2}{/if}
	{if !empty($output3)}{$output3}{/if}
</form>
<script type="text/javascript">

var custom_reports = {$custom_reports_json};

$("#locations_search_suggest").select2({
    placeholder: "Search location",
    minimumInputLength: 1,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
	    url: "/admin/?cat=forms&action=get_locations_by_name",
	    dataType: 'json',
	    data: function (name) { return { name: name }; },
	    results: function (data) { // parse the results into the format expected by Select2.
	    	// since we are using custom formatting functions we do not need to alter remote JSON data
	    	return { results: data };
	    }
    },
    
    escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
}).on('select2-selecting', function(e){
	
	var location_id = e.val;
	$.ajax({
		  url: "/admin/?cat=forms&action=get_custom_report_by_location&id="+location_id,
		  dataType: "json",
		  success: function(data) {

	  		  //remove "old" options
			  $("#report_id option").not(".permanent").remove();
			  $("#clear_loc").show();
			  //$("#report_id option.permanent, .froi_state").hide();
			  			  
		   	  if(data.length>0){
			   	$.each(data, function(i, item) {
				     $('#report_id option:first-child').after($("<option></option>").attr("value",item.id).text(item.title));
				});//each
		   	  }//if data

		   	  //update list
			  $("#report_id option:first-child").attr("selected","selected");
			  $("#report_id").trigger("chosen:updated");
			  $(".froi_state").show();
			  
		  }//success
	});
});;

	$("#clear_loc").on("click",function(event){
		event.preventDefault();
		$('#locations_search_suggest').select2('data', null);
		$("#report_id option.permanent, .froi_state").show();

		if(custom_reports.length>0){
		   	$.each(custom_reports, function(i, item) {
			     $('#report_id option:first-child').after($("<option></option>").attr("value",item.id).text(item.title));
			});//each
	   	  }//if data

		//update list
		$("#report_id option:first-child").attr("selected","selected");
		$("#report_id").trigger("chosen:updated");
		$(this).hide();
	});
	
	$("#form_generate").on("submit",function(event){
		//event.preventDefault();
		 if($("#report_id").val()>0)
			 return true;
		 else
			 event.preventDefault();
	});
	
	$("#report_id").chosen().change(function(evt, params){
		var report_id = params.selected;

		if(report_id==1){ //FROI
			$(".froi_state").show();
		}else{
			$(".froi_state").hide();

		}
		
	});
	
	$("#state_id").chosen();
	
	$(document).ready(function() {
		
	});
</script>