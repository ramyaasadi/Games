<a class="{if $location_data.children|default:0 > 0}{if $preopened}minus{else}plus{/if}{else}no_children{/if}"></a>
<a href="javascript:chosenNode({$location_data.id},'{$location_data.title|escape:'javascript'}')">{$location_data.title}{if $location_data.distribution_mode==1} [T]{elseif $location_data.distribution_mode==2} [B]{elseif $location_data.distribution_mode==3} [L]{elseif $location_data.distribution_mode==4} [O]{/if}</a>{if $location_data.add|default:"false" || $location_data.add!=''}{$location_data.add}{/if}&nbsp;
{if $logged_user_priv['edit_hierarchy']}<a title="Export Organization" class="i_xml pointer" onclick="hierrachyTreeExportLocation2xml({$location_data.id});"></a>{/if}
{if $logged_user_priv['run_managment_reports']}<a href="/account_management_reports.php?location_id={$location_data.id}" title="Create a management report" class="i_rep pointer"></a>{/if}
{* if $logged_user_priv['run_managment_reports']}<a href="/account_osha_search.php?location_id={$location_data.id}" title="View OSHA" class="i_rep pointer"></a>{/if *}
{if $logged_user_priv['view_custom_reports']}<a href="/account_manage_custom_reports.php?id={$location_data.id}" title="Manage Custom Reports" class="i_jr"></a>{/if}
{if $logged_user_priv['view_users']}<a href="/account_view_users.php?id={$location_data.id}" title="View Users" class="i_users"></a>{/if}
{if $logged_user_priv['edit_claim_distribution']}<a href="/account_claim_distribution_rules.php?id={$location_data.id}" title="Edit Distribution" class="i_edit"></a>{/if}
<span class="end"></span>