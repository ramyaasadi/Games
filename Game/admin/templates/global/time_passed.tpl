{date_diff date1=$date date2=$smarty.now interval="days" assign="days"}
{if $days>0}
	{if $days==1}
		yesterday at <strong>{$date|date_format:'%H:%M'}h</strong>
	{elseif $days<=30}
		<strong>{$days}</strong> days ago
	{else}
	{include file="global/date_format.tpl" date=$date}
	{/if}
{else}
	{include file="global/date_format.tpl" date=$date}
{/if}