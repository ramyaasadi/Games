<div style="width: 770px; padding: 0 20px 0 20px;">
<h1>{$article.title}</h1>
<div class="cb"><!--  --></div>
{if $article.image_position!='gallery' && $article.image>0}<a href="/draw.php?do=max&amp;size=800&amp;path=photos/texts/{$article.image}" class="lightbox"><img src="/draw.php?do=resize&amp;path=photos/texts/{$article.image}" alt="{$article.title}" class="fr rthumb rthumbint" /></a>{/if}
{$article.body}
</div>
<div class="cb"><!-- --></div>