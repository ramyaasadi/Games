{if !$email}
<p class="ss">section</p>
<h2>{$pagetitle|default:'Statistic Page'}</h2>
<ul class="snav">
	<li><a href="?cat=statistic&display" class="sel">Statistic Page</a></li>
	<li><a href="?cat=statistic" class="sel">Send Statistic Page to Email</a></li>
</ul>
{/if}
<h3>{$pagetitle|default:'Statistic Page'} ({$startDate} - {$endDate})</h3>
<br />
{if $columns}
<table border=1>
	<tr>
	{foreach $columns as $key => $val}
		<td nowrap>{$val|default:'&nbsp;'}</td>
	{/foreach}
	</tr>
	{if $data}
	{foreach $data as $key => $val}
	<tr>
		{foreach $val as $key2 => $val2}
		<td nowrap>{$val2}</td>
		{/foreach}
	</tr>
	{/foreach}
	{/if}
</table>
{/if}