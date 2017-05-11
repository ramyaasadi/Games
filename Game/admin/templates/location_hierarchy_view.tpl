<div class="panel">
	<h3>Organization Hierarchy</h3>
	<section class="cont">
		<div style="float:right;">
			<button type="button" id="close">Close</button>
		</div>
		<!-- Hierarchy Tree -->
		<div class="htree">
			<div class="fr">
				<a onclick="hierrachyTreeCollapse();" title="Collapse the entire tree below" class="pointer"><img src="/i/icons/org_hierarchy/i_collapse.png" alt="icon" align="absmiddle" /> Collapse All</a>
				&nbsp;
				<a onclick="hierrachyTreeExpand();" title="Expand the one level of the nodes in the tree below" class="pointer"><img src="/i/icons/org_hierarchy/i_expand.png" alt="icon" align="absmiddle" /> Expand One Level</a>
			</div>
			<div class="cb"></div>
			<br />
			<div class="node" rel="{$location_data.id}">
				{include file="box/_tree_node.tpl" preopened=true}
				{if $location_data.children > 0 && $children}
					{include file="box/_tree_children.tpl"}
				{/if}
			</div>
		</div>
	</section><!-- cont -->
</div><!-- boxcont -->
<script type="text/javascript">
	var render = 'view';
	$(document).ready(function() {
		hierrachyTreeInit(render);
		$('#close').on('click', function(){
			$('.aPop, .md').remove();
		});
	});
</script>