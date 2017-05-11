<div class="pg">
    <div class="left_controls">
        {if $paging.prev < $paging.current}<a href="#previous" onclick="location.href = urlCleanup(location.href, Array('page'))+'&amp;{$pvar|default:'page'}={$paging.prev}#new_page';"><img src="interface/{$icon_location|default:'icons'}/back.gif" alt="back" /></a>
        {else}<a class="bt_left_disabled" href="javascript: void[]"><img src="interface/{$icon_location|default:'icons'}/back-disabled.gif" alt="back" /></a>{/if}
        
        {if $paging.prev < $paging.current}<a href="#first" onclick="location.href = urlCleanup(location.href, Array('page'))+'&amp;{$pvar|default:'page'}=0#new_page';"><img src="interface/{$icon_location|default:'icons'}/back-fast.gif" alt="back-fast" /></a>
        {else}<a class="bt_left_disabled" href="javascript: void[]"><img src="interface/{$icon_location|default:'icons'}/back-fast-disabled.gif" alt="back-fast" /></a>{/if}
    </div>
    <div class="right_controls">
        {if $paging.next > $paging.current}<a href="#last" onclick="location.href = urlCleanup(location.href, Array('page'))+'&amp;{$pvar|default:'page'}={$paging.all_pages}#new_page';"><img src="interface/{$icon_location|default:'icons'}/next-fast.gif" alt="next-fast" /></a>
        {else}<a href="javascript: void[]"><img src="interface/{$icon_location|default:'icons'}/next-fast-disabled.gif" alt="next-fast" /></a>{/if}
        
        {if $paging.next > $paging.current}<a href="#next" onclick="location.href = urlCleanup(location.href, Array('page'))+'&amp;{$pvar|default:'page'}={$paging.next}#new_page';"><img src="interface/{$icon_location|default:'icons'}/next.gif" alt="next" /></a>
        {else}<a href="javascript: void[]"><img src="interface/{$icon_location|default:'icons'}/next-disabled.gif" alt="next" /></a>{/if}
    </div>
    <div class="pages">
        {$interface.pages}
        {foreach from=$paging.pages item=item name="ppp"}
            <a href="#page" onclick="location.href = urlCleanup(location.href, Array('page'))+'&amp;{$pvar|default:'page'}={$item}#new_page';"
                {if $item == $paging.current}class="sel"{/if}>{$item+1}</a>
                {if $smarty.foreach.ppp.iteration<$paging.pages|@count}|{/if}
        {/foreach}
    </div>
</div>