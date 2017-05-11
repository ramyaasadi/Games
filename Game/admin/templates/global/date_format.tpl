{if $date!='0000-00-00 00:00:00' AND $date!=''}
{if $plain==true}{$date|date_format:"%m/%d/%Y"}
{else}
<span class="info_date">
	{if $smarty.now|date_format:"%d-%m-%Y" == $date|date_format:"%d-%m-%Y"} 
		today at <strong>{$date|date_format:"%H:%M"}h</strong>
	{else}
		<strong>{$date|date_format:"%m/%d/%Y"}</strong>
	{/if}
</span>
{/if}
{/if}