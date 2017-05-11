<p class="ss">section</p>
<h2>{$pagetitle|default:'Reports Graphs and Charts'}</h2>
{include file="global/message.tpl"}
	<table class="table table-striped" id="categoryList">
	   <thead>
		  <tr>
			 <th width="1%" class="nowrap center hidden-phone"></th>
			 <th width="1%" class="nowrap center">Status</th>
             <th width="1%" class="nowrap center"></th>
			 <th>Title</th>
			 <th width="5%" class="nowrap hidden-phone">Order</a>
			 </th>
		  </tr>
	   </thead>
	   <tbody>
	   <form id="adminForm" name="adminForm" action="" method="post">
	      {foreach from=$charts key=term item=replacement name="t"}
		  <tr item-id="{$replacement.id}" sortable-group-id="1">
			 <td class="order nowrap center">
			 <span class="sortable-handler"><span class="icon-menu"></span></span>
				<input type="text" style="display:none" name="order[]" value="{$replacement.ordering}" />
			 </td>
			 <td class="center">
				{if $replacement.status == 1}
				<a class="btn btn-micro" href="javascript:void(0);" id="{$replacement.id}" rel='0'>
					<span class="icon-publish"> </span>
				</a>
				{else}
				<a class="btn btn-micro" href="javascript:void(0);" id="{$replacement.id}" rel='1'>
					<span class="icon-unpublish"> </span>
				</a>
				{/if}
 							
			 </td>
			 <td class="center">
				<b title="Edit" class="editbuttons btn btn-micro" href="javascript:void(0);" id="edit{$replacement.id}" rel='edit'>
					<span class="icon-edit"> </span>
				</b>
			 </td>             
			 <td><input style="display:none" type="checkbox" id="cb{$replacement.ordering}" name="cid[]" value="{$replacement.id}" onclick="Joomla.isChecked(this.checked);" /><span id="">{$replacement.aliastitle}</span>
             <span class="editgroups" id="form-edit{$replacement.id}" style="width:100%; float:left; display:none">
             	<input id="inc{$replacement.id}" style="width:30%" type="text" class="in" value="{$replacement.aliastitle}" name="facilitytype[title]">
                <input rel="{$replacement.id}" type="button" class="savebutton bt fixed50" value="Save" name="savebutton">
             </span>
             </td>
			 <td class="center hidden-phone">
				<span title="1-2">{$replacement.id}</span>
			 </td>
		  </tr>
		{/foreach}
		</form>
	   </tbody>
	</table>    
<p class="legend">
    <strong>Important:</strong> The order value determines in which order the terms will be replaced, so be careful. <br />
    Try to avoid something like this: "Claimant" > "Employee" and next to be "Employee" > "Our Employee" because this will replace all the previous "Claimant" terms as well.
</p>
      <link rel="stylesheet" href="css/sortablelist.css" type="text/css" />
	  <script src="js/jquery.min.js" type="text/javascript"></script>
	  <script src="js/jquery.ui.core.min.js" type="text/javascript"></script>
      <script src="js/jquery.ui.sortable.min.js" type="text/javascript"></script>
      <script src="js/sortablelist.js" type="text/javascript"></script>
       <script type="text/javascript">
				$("#checkall").change(function () {
					$("input:checkbox").prop('checked', $(this).prop("checked"));
				});	   
				(function ($){
					$(document).ready(function (){
						$.JSortableList('#categoryList tbody','adminForm','asc' ,'ajax/charts-ordering.php','','0');
					});
				})($);       
				$(document).ready(function() {
					$(".ui-sortable a").click(function(){
					id = $(this).attr('id');
					var status = $(this).attr('rel');
					var temphtml = $(this).html(); 
					$(this).html('..');
					$.ajax({ url: 'ajax/charts.php', type: 'POST', data: { chartid: id, status:status}, success: function(data){
						if(data == 1){
							if(status == '0'){ 
								$("#"+id).html('<span class="icon-unpublish"></span>');
								$("#"+id).attr("rel","1");
							}else { 
								$("#"+id).html('<span class="icon-publish"></span>');
								$("#"+id).attr("rel","0");
							}
						}
					}
				   });
					return false;		
					});
				
				$(".ui-sortable b").click(function(){
					id = $(this).attr('id');
					var status = $(this).attr('rel');
					if(status == "edit"){
						
						$(".editgroups").fadeOut("slow");
						$(".editbuttons").attr('rel',"edit");
						$("#form-"+id).fadeIn("slow");
						$(this).attr('rel',"edited");
					}else{
						$("#form-"+id).fadeOut("slow");
						$(this).attr('rel',"edit");						
					}
					});
				$(".savebutton").click(function(){
					id = $(this).attr('rel');
					var invalue = $("#inc"+id).val();
					var status = 'edit';
					$.ajax({ url: 'ajax/charts.php', type: 'POST', data: { chartid: id, aliastitle:invalue, status : status}, success: function(data){   location.reload(); } });					

					});						


				
				$(".ui-sortable b").click(function(){});					
					return false;		
				});				
			
				//});
      </script>	  