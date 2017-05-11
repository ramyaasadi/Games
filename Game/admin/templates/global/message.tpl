{if $message|default:false}
<div class="{$message.type}_message">
	{if $message.title}<strong class="title">{$message.title}</strong>{/if}
	{if $message.body}<p>{$message.body}</p>{/if}
	{if $message.url}
	<p class="redirect">
		{if $message.redirect>0}
		(you will be redirected in {$message.redirect/1000|round} seconds)
		<script type="text/javascript">
			setTimeout("location.href='{if $message.url}{$message.url}{else}/{/if}';", {$message.redirect});
		</script>
		{else}
		<script type="text/javascript">location.href='{if $message.url}{$message.url}{else}/{/if}';</script>
		{/if}
	</p>
	{/if}
</div>
{/if}