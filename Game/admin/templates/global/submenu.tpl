{if $submenu && $link}
<div class="article_panel button_list">
    <h2>{$interface.submenu|default:"Повече информация"}</h2>
    <p>
    {foreach from=$submenu item=item}
    <a href="/{$link}/{$item.identifier}/" class="{if $item.identifier==$article.identifier || $item.identifier==$fuel.identifier}sel{else}{/if}">{$item.name|default:$item.subtitle|default:$item.title}</a>
    {/foreach}
    </p>
</div>
{/if}