{if $news}
<h3>{$interface.latests_news}</h3>
<div class="news_panel">
    {foreach from=$news item=item}
    {if $item.title}<h4>{$item.title}</h4>{/if}
    <p>
        {include file="global/date_format.tpl" date=$item.date}<br />
        {$item.body|strip_tags:false|truncate:190:'...':true}
        <a href="/news/{$item.id}/">{$interface.read_more|lower} &raquo;</a>
    </p>
    {/foreach}
    <br />
    <a href="/news/" class="go">{$interface.news_archive|lower}</a>
</div>
{/if}