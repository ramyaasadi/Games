{include file="header_footer/header.tpl"}
<div id="cont">
	<div class="article">
		<h1>{$article.title}</h1>
		{if $article.subtitle}<h4>{$article.subtitle}</h4>{/if}
		{assign var='width' value=$article.image_width|default:200}
		{assign var='height' value=$width/4*3|round}
		
		{if $article.image_position!='gallery' && ($article.image || $article.image2 || $article.image3)}
			<div class="image_holder {$article.image_position|default:'image_left'}" style="width: {$width+5}px; ">
			{if $article.image}
				<a href="/draw.php?do=max&amp;size=800&amp;path=photos/texts/{$article.image}" class="lightbox"><img src="/draw.php?do=resize&amp;w={$width}&amp;h=x&amp;path=photos/texts/{$article.image}" alt="{$article.title}" width="{$width}" class="{$article.image_position|default:'image_left'} {$article.image_border|default:'std_border'}" /></a>
			{/if}
			{if $article.image2}
				<a href="/draw.php?do=max&amp;size=800&amp;path=photos/texts/{$article.image2}" class="lightbox"><img src="/draw.php?do=resize&amp;w={$width}&amp;h=x&amp;path=photos/texts/{$article.image2}" alt="{$article.title}" width="{$width}" class="{$article.image_position|default:'image_left'} {$article.image_border|default:'std_border'}" /></a>
			{/if}
			{if $article.image3}
				<a href="/draw.php?do=max&amp;size=800&amp;path=photos/texts/{$article.image3}" class="lightbox"><img src="/draw.php?do=resize&amp;w={$width}&amp;h=x&amp;path=photos/texts/{$article.image3}" alt="{$article.title}" width="{$width}" class="{$article.image_position|default:'image_left'} {$article.image_border|default:'std_border'}" /></a>
			{/if}
			</div>
		{/if}
		<br class="cb">
		{$article.body}
		
		{if $article.image_position=='gallery' && ($article.image || $article.image2 || $article.image3)}
			{if $article.image}
				<a href="/draw.php?do=max&amp;size=800&amp;path=photos/texts/{$article.image}" class="lightbox"><img src="/draw.php?do=fixed&amp;w={$width}&amp;h={$height}&amp;path=photos/texts/{$article.image}" alt="{$article.title}" width="{$width}" height="{$height}" class="{$article.image_border|default:'std_border'}" /></a>
			{/if}
			{if $article.image2}
				<a href="/draw.php?do=max&amp;size=800&amp;path=photos/texts/{$article.image2}" class="lightbox"><img src="/draw.php?do=fixed&amp;w={$width}&amp;h={$height}&amp;path=photos/texts/{$article.image2}" alt="{$article.title}" width="{$width}" height="{$height}" class="{$article.image_border|default:'std_border'}" /></a>
			{/if}
			{if $article.image3}
				<a href="/draw.php?do=max&amp;size=800&amp;path=photos/texts/{$article.image3}" class="lightbox"><img src="/draw.php?do=fixed&amp;w={$width}&amp;h={$height}&amp;path=photos/texts/{$article.image3}" alt="{$article.title}" width="{$width}" height="{$height}" class="{$article.image_border|default:'std_border'}" /></a>
			{/if}
		{/if}
		<div class="cb"></div>
	</div>
</div>
{include file="header_footer/footer.tpl"}