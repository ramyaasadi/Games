{foreach $children as $child}
<div class="node" rel="{$child.id}">
	{include file="box/_tree_node.tpl" location_data = $child}
</div>
{/foreach}