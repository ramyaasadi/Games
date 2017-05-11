{if $noframe|default:false || $smarty.get.noframe|default:false}
	{if $template_to}{include file="$template_to"}{/if}
{else}
	{include file="header.v2.4.1.tpl"}
	{include file="$template_to"}
	{include file="footer.tpl"}
{/if}