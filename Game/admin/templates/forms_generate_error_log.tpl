<p>&nbsp;</p>
<h2>Generation Error Log</h2>
{if !empty($CLAIM_GENERATION_ERROR_LOG)}
	<form action="" method="post"><input type="hidden" name="clear" value="1" /><input type="submit" value="clear log" /></form>
	<hr />
	<pre style="height: auto; max-height: 600px; overflow: auto; word-break: normal !important; word-wrap: normal !important; white-space: pre !important;">{$CLAIM_GENERATION_ERROR_LOG}</pre>
{else}
	<p>Log file is empty.</p>
{/if}