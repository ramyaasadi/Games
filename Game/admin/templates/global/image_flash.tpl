{if $item.type=='image'}
<img src="/banners/{$item.path}" alt="{$item.desc}" width="{$width}" height="{$height}" />
{elseif $item.type=='flash'}
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="{$width}" height="{$height}" title="{$item.desc}">
      <param name="movie" value="/banners/{$item.path}" />
      <param name="quality" value="high" />
      <embed src="/banners/{$item.path}" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="{$width}" height="{$height}"></embed>
</object>
{/if}