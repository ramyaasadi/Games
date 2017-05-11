<h3>Server</h3>
{include file="global/message.tpl"}
{if $action}

{if $action=='force_dist_queue'}
<iframe style="width: 100%; height: 500px;" src="/cron/distribution_queue.php"></iframe>
{/if}

{if $action=='force_ftp_upload'}
<iframe style="width: 100%; height: 500px;" src="/cron/ec_ftp.php"></iframe>
{/if}

{if $action=='flush_memcached'}
<p>&nbsp;</p>
<p>Memcahced flushed!</p>
{/if}


{/if}