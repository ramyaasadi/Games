{if $services}
<div class="service_buttons">
    {foreach from=$services item=item}
    <a href="/services/{$item.identifier}/" class="bt_{$item.color|default:'blue'}">{$item.name|default:$item.title}</a>
    {/foreach}
</div>
{/if}