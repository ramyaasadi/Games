{literal}
<style>
table.std { border:1px solid #002d93!important; padding: 1px;}
.tble_header, .tble_header:hover { background: #002d93!important; color: #fff;}
.activeclr{color:green}
.inactiveclr{color:#d60000}
img.change_status { cursor:pointer;}
.ui-menu-item a{ font-size: 12px!important; font-family: "Trebuchet MS",Arial,Verdana,sans-serif!important; width: 450px!important;}
.sorticondisplay { float: none; clear: both; display: flex; height: 8px; font-size:24px; text-decoration: none; color:#e2e2e2; padding-left:10px; line-height:24px; }
.ui-state-focus { background: none!important;border: 1px solid #002d93!important;color: #002d93!important;font-weight: normal;}
.ui-widget-content { border: 2px solid #ccc!important; background: #fff!important}
.color_default { color: #b9b9b9!important; }
</style>
{/literal}
<h2>Accident code</h2>
<ul class="snav">
	<li><a href="?cat=accidentcode" class="sel">Accident code List</a></li>
    <li><a href="?cat=accidentcode&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> Add accident code </a></li>
</ul>
<h3>Accident code<div style='float:right'> <span class='color_default'> Total accident codes </span>: {if $paging['records_all']} {$paging['records_all']}{else}{$list|@count} {/if}</div></h3>
<br />
{if $list}
<form action="" method="post" style="padding-bottom:20px;">
<table cellpadding="3" cellspacing="0" class="std" border="0" width="100%" align="center" style='padding:10px 0; background: #f2f2f2'>
    <tr>
        <td style='text-align:right;'> Search by Accident title :  </td>
        <td><input type="text" id='tags' name="filter[string]" class="in" value="{$search}" /></td>
        <td><input type="submit" name="filter[apply]" value="Search" class="bt" /> {if $search != ""} <a href='?cat=accidentcode'> Reset Search </a> {/if}</td>
    </tr>
	</table>
</form>
<table width="100%" cellpadding="3" cellspacing="0" class="std">
<tr class='tble_header'>
	<td width="5%">
	<div style='float:left;'>Id.</div>
	<div style='float:left;'>
	{if $order == 'id_desc'}
	<a href="?cat=accidentcode&amp;action=list&amp;order=id_asc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay" style='padding-top:3px'>&caron;</a>
	{elseif $order == 'id_asc'}
	<a href="?cat=accidentcode&amp;action=list&amp;order=id_desc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay" style='padding-top:3px'>&circ;</a>
	{else}
	<a href="?cat=accidentcode&amp;action=list&amp;order=id_desc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay color_default">&circ;</a>
	<a href="?cat=accidentcode&amp;action=list&amp;order=id_asc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay color_default">&caron;</a>
	{/if}
	</div>
	</td>
	<td>
	<div style='float:left;'>Title</div>
	<div style='float:left;'>
	{if $order == 'title_desc'}
	<a href="?cat=accidentcode&amp;action=list&amp;order=title_asc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay" style='padding-top:3px'>&caron;</a>
	{elseif $order == 'title_asc'}
	<a href="?cat=accidentcode&amp;action=list&amp;order=title_desc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay" style='padding-top:3px'>&circ;</a>
	{else}
	<a href="?cat=accidentcode&amp;action=list&amp;order=title_desc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay color_default">&circ;</a>
	<a href="?cat=accidentcode&amp;action=list&amp;order=title_asc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay color_default">&caron;</a>
	{/if}
	</div>
	</td>
	
	
	<td>
	<div style='float:left;'>Description</div>
	<div style='float:left;'>
	{if $order == 'description_desc'}
	<a href="?cat=accidentcode&amp;action=list&amp;order=description_asc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay" style='padding-top:3px'>&caron;</a>
	{elseif $order == 'description_asc'}
	<a href="?cat=accidentcode&amp;action=list&amp;order=description_desc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay" style='padding-top:3px'>&circ;</a>
	{else}
	<a href="?cat=accidentcode&amp;action=list&amp;order=description_desc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay color_default">&circ;</a>
	<a href="?cat=accidentcode&amp;action=list&amp;order=description_asc{if $search != ""}&amp;searchterm={$search}{/if}" class="sorticondisplay color_default">&caron;</a>
	{/if}
	</div>
	</td>
	
	
	<td>Actions</td>
</tr>
{foreach from=$list item=item}
<tr{cycle values=', class="even"'}>
	<td nowrap="nowrap">{$item.id}</td>
    <td><strong><a href="?cat=accidentcode&amp;action=edit&amp;id={$item.id}">{$item.title} - [CODE : {$item.code}]</a></strong></td>
	
	<td>{$item.description}</td>
	
    <td align="right" nowrap="nowrap" class="admin" width="5%">
	<div style="float:left; margin:2px;">{if $item.status == 'y'}<img src="interface/icons/i_star.png" title="Change Status" alt="Change Status" align="absmiddle" class="change_status" id="{$item.id}_n" /> {else} <img src="interface/icons/i_istar.png" title="Change Status" alt="Change Status" align="absmiddle" class="change_status" id="{$item.id}_y" />{/if}
		</div>
        <div style="float:left;margin:2px;">
        <a href="?cat=accidentcode&amp;action=edit&amp;id={$item.id}"><img src="interface/icons/edit.gif" alt="edit" align="absmiddle" title="Edit Accident code" /></a>
		</div>
    </td>
</tr>
{/foreach}
</table>
{include file="global/pg.tpl" paging=$paging}
{/if}
{include file="legend.tpl"}

<script language="javascript">

$(document).ready(function(){
$(document).on('click', '.change_status', function(){
	
	if(confirm('Are you sure you want to change status ?'))
	{
	var idval = $(this).attr('id'); var fullstr = idval.split('_');
	if((fullstr[0]!='') && (fullstr[1]!=''))
	{
		$.ajax({
					url: '?cat=accidentcode&action=changestatus',
					type: 'POST',
					data: { selectedvalue: idval },
					success: function(data)
					{
						if(data == 2){ alert("Something wrong"); }
						else if(data == 1){
						
							if(fullstr[1] == 'y')
							{
							var replaceval = '<img src="interface/icons/i_star.png" title="Change Status" alt="Change Status" align="absmiddle" class="change_status" id="'+fullstr[0]+'_n" />';
							}
							if(fullstr[1] == 'n')
							{
							var replaceval = '<img src="interface/icons/i_istar.png" title="Change Status" alt="Change Status" align="absmiddle" class="change_status" id="'+fullstr[0]+'_y" />';
							}

							$('img#'+idval).parent().html(replaceval);
														 
							alert("Status Changed Successfully");
						}
						else{ alert("Something wrong"); }
					}
		}); 
	} }
});
});

$(function() {
    $( "#tags" ).autocomplete({
      source: "?cat=accidentcode&action=showlist",
      minLength: 2,
	  change: function(event,ui){
		$(this).val((ui.item ? ui.item.value : "")); 
		}
    });
  });
</script>