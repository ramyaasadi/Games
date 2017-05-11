<div class="paging">
      <div class="paging_controls">
            {if $paging.prev < $paging.current}<a class="bt_left" href="#previous" onclick="location.href = urlCleanup(location.href, Array('page'))+'&amp;{$pvar|default:'page'}={$paging.prev}#new_page';"><span><img src="/interface/arrow_left.gif" alt="&laquo;" align="absmiddle" /> предишна</span></a>
            {else}<a class="bt_left_disabled" href="javascript: void[]"><span><img src="/interface/arrow_left.gif" alt="&laquo;" align="absmiddle" /> предишна</span></a>{/if}
            
            {if $paging.next > $paging.current}<a class="bt_right" href="#next" onclick="location.href = urlCleanup(location.href, Array('page'))+'&amp;{$pvar|default:'page'}={$paging.next}#new_page';"><span>следваща <img src="/interface/arrow_right.gif" alt="&raquo;" align="absmiddle" /></span></a>
            {else}<a class="bt_right_disabled" href="javascript: void[]"><span>следваща <img src="/interface/arrow_right.gif" alt="&raquo;" align="absmiddle" /></span></a>{/if}
      </div>
      <div class="page_numbers">
            {foreach from=$paging.pages item=item name="ppp"}
                  <a href="#page" onclick="location.href = urlCleanup(location.href, Array('page'))+'&amp;{$pvar|default:'page'}={$item}#new_page';"
                        {if $item == $paging.current}class="sel"{/if}>{$item+1}</a>
                        {if $smarty.foreach.ppp.iteration<$paging.pages|@count}|{/if}
            {/foreach}
      </div>
      <div class="clear"></div>
</div>