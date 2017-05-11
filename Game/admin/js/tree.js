var tree_debug = false;

function hierrachyTreeInit(render) {
	// init the hierarchy tree according to his render
	var clear_data = $(".htree").html(),
		filter = $('.htree .fl input').val(),
		timeoutID = null, filterText = '';
	if (tree_debug) console.log('Initializing hierarchy tree with render = '+render);
	
	$('.htree .node').delegate('.minus', 'click', function() { hierrachyTreeClose($(this)); });
	$('.htree .node').delegate('.plus', 'click', function() { hierrachyTreeOpen($(this), render); });
	if (render == 'edit'){
		$('.htree .node button').on('click', function() { hierrachySaveNode($(this)); });
		
		//init dragg-drop (move location)
		enableDraggDrop();
	}
	if (render == 'view' || render == 'edit') {
		$('.htree .fl input').on('keyup', function() {
			var obj = $(this);
			if (filterText!=$(obj).val()) {
				filterText = $(obj).val();
				if (timeoutID) {
					if (tree_debug) console.log('There is current timeoutID ['+timeoutID+'], we are removing it.')
					clearTimeout(timeoutID);
				}
				timeoutID = setTimeout(function() { hierrachyTreeFilter(obj, $(obj).val(), $('.htree .fl select').val(), render); }, 300);
				console.log('We launched hierrachyTreeFilter() function, the new timeoutID is ['+timeoutID+']');
			} else if (tree_debug) console.log('The filter is the same ['+filterText+'] so we don\'t need to launch the hierrachyTreeFilter() function.');
			
		});
		$('.htree .fl select').on('change', function() { hierrachyTreeFilter($(this), $('.htree .fl input').val(), $(this).val(), render); });
		$('.htree .fl a.bt_clear').on('click', function() { hierrachyTreeFilterClear(clear_data, render); });
		$('.htree .fl a.all_results').on('click', function() { hierrachyTreeFilterRest($('.htree .fl input').val(), $('.htree .fl select').val(), render); });
		// applying the filter if there is a cached one
		if (filter && filter.length >= 2) hierrachyTreeFilter($('.htree .fl select'), filter, $('.htree .fl select').val(), render);
	}
	if (render == 'claim') {
		$('.htree .node select').on('change', function() { hierrachyClaimVisSave($(this)); });
		$('.htree .node a.root').on('click', function() { hierrachyMakeRoot($(this)); });
	}
	if (render == 'creport') {
		var report_id = $("#report_id").val(), owner_id =$("#owner_id").val(); 
		$('.htree .node .check').on('click',  function() { hierrachyTreeCustomReport($(this), 'check', report_id, owner_id); });
		$('.htree .node .ucheck').on('click', function() { hierrachyTreeCustomReport($(this), 'ucheck', report_id, owner_id); });
	}
	if (render == 'ccontact') {
		var contact_id = $("#contact_id").val(),
			owner_id = $("#owner_id").val(),
			contact_role = $("#contact_role").val();
		if (contact_id > 0 && owner_id > 0) {
			if (tree_debug) console.log('ccontact :: hierrachyTreeCopyContact() attached with contact_id = '+contact_id+'; owner_id = '+owner_id);
			$('.htree .node .check').on('click',  function() { hierrachyTreeCopyContact($(this), 'check', contact_id, owner_id, contact_role); });
			$('.htree .node .ucheck').on('click', function() { hierrachyTreeCopyContact($(this), 'ucheck', contact_id, owner_id, contact_role); });
		}
		else {
			if (tree_debug) console.log('ERROR: Cannot attach hierrachyTreeCopyContact() because contact_id = '+contact_id+'; owner_id = '+owner_id);
		}
	}
	if (render == 'book_import') $('.htree .node a.root').on('click', function() { hierrachySetPosition($(this), $("#import_location"), $("#import_location_data")); });
	if (render == 'rules') {
		$('.htree .node button').on('click', function() { hierrachyShowRules($(this)); }) ;
		$('.htree .node a.state').on('click', function() { hierrachyRulesSaveStatus($(this),'state'); }) ;
		$('.htree .node a.inherit').on('click', function() { hierrachyRulesSaveStatus($(this),'inherit'); }) ;
	}
}

function hierrachyRulesSaveStatus(node_obj, ofwhat) {
	// Claim Distribution Rules
	// save rule status like `inherit` or `send to state`
	var node_id = $(node_obj).parent().attr('rel'),
		status = 0;
	if ($(node_obj).hasClass('i_'+ofwhat)) status = 1;
	if (tree_debug) console.log('[saveState] CLICK detected on Node #'+node_id+' and Status: '+status+' of '+ofwhat);
	$.ajax({
		type: "POST",
		url: "/ajax/hierarchy_tree.php",
		data: "action=rulesSaveStatus&id="+node_id+"&status="+status+"&ofwhat="+ofwhat
	}).done(function(data) {
		if (data) {
			if (tree_debug) console.log(">>> we have a data: "+data);
			if (status == 1) {
				$(node_obj).removeClass('i_'+ofwhat).addClass('i_'+ofwhat+'_ok');
				$(".claim [rel="+node_id+"] a.inherit").removeClass('i_'+ofwhat).addClass('i_'+ofwhat+'_ok');
				$(".node[rel="+node_id+"]").children("a.inherit").removeClass('i_'+ofwhat).addClass('i_'+ofwhat+'_ok');
				if (ofwhat == 'inherit') {
					// we must show the inherited rules
					if ($('tr.inherit[rel='+node_obj+']').attr('rel') > 0) {
						obj = $('tr.inherit[rel='+node_obj+']');
						if (tree_debug) console.log('Node ID: '+$(obj).attr('rel')+' > Inherit from: '+$(obj).attr('alt'));
						getInheritance($(obj), $(obj).attr('rel'), $(obj).attr('alt'));
					}
				}
			} else {
				$(node_obj).removeClass('i_'+ofwhat+'_ok').addClass('i_'+ofwhat);
				$(".claim [rel="+node_id+"] a.inherit").removeClass('i_'+ofwhat+'_ok').addClass('i_'+ofwhat);
				$(".node[rel="+node_id+"]").children("a.inherit").removeClass('i_'+ofwhat+'_ok').addClass('i_'+ofwhat);
				if (ofwhat == 'inherit') {
					if ($('tr.inherit[rel='+node_obj+']').attr('rel') > 0) $('tr.inheritance').remove();
				}
			}
		} else {
			if (tree_debug) console.log(">>> NO RESULT");
		}
	});
}

function hierrachyShowRules(node_obj) {
	// Claim Distribution Rules
	// get and show the selected node rule's data
	var node_id = $(node_obj).parent().attr('rel');
	if (tree_debug) console.log('[showRules] CLICK detected on Node #'+node_id);
	$('.claim').html('<tr><th colspan="3"><strong class="i_ajax">Loading the rules...</strong></td></tr>');
	$.ajax({
		type: "POST",
		url: "/ajax/hierarchy_tree.php",
		data: "action=showRules&id="+node_id
	}).done(function(data) {
		$('.htree .is_root').hide();
		$('.htree button').show();
		if (data) {
			if (tree_debug) console.log(">>> we have a data: "+data);
			$('.claim').html(data);
			$(node_obj).hide();
			$(node_obj).siblings('strong').show();
			if ($('tr.inherit').attr('alt') > 0) {
				obj = $('tr.inherit');
				getInheritance($(obj), $(obj).attr('rel'), $(obj).attr('alt'));
			}
		} else {
			if (tree_debug) console.log(">>> NO RESULT");
			$('.claim').html('<tr><th colspan="3"><strong>ERROR! Cannot load the rules for this location!</strong></td></tr>');
		}
	});
}

function hierrachySetPosition(node_obj, pos_obj, pos_obj_data) {
	var node_id = $(node_obj).parent().attr('rel'), node = $(node_obj);
	if (tree_debug) console.log('[setPos] CLICK detected on Node #'+node_id);
	$(pos_obj).val(node_id);
	$(pos_obj_data).text($(node_obj).siblings('a.n').text());
	$('.htree .node .root').removeClass('is_root');
	$(node_obj).addClass('is_root');
}

function hierrachyTreeCopyContactAll(root, action, contact_id, owner_id, contact_role) {
	var node_id = $(root).attr('rel');
	if (tree_debug) console.log('['+action+'] function hierrachyTreeCopyContactAll() invoced for Node #'+node_id+' (contact_id: '+contact_id+'; owner_id: '+owner_id+')');
	if (tree_debug) console.log('>>> sending a request to setCContact');
	if (tree_debug) console.log(">>> action=setCContact&root=true&id="+node_id+"&do="+action+"&contact_id="+contact_id+"&owner_id="+owner_id);
	
	$('img[alt=ic_'+action+']').attr('src', '/i/ajax/ajax-loader-orange.gif');
	$.ajax({
		type: "POST",
		url: "/ajax/hierarchy_tree.php",
		data: "action=setCContact&root=true&id="+node_id+"&do="+action+"&contact_id="+contact_id+"&owner_id="+owner_id+"&contact_role="+contact_role
	}).done(function(data) {
		if (data) {
			if (tree_debug) console.log(">>> we have a data: "+data);
			if (action=='ucheck') {
				// creport: check all visible siblings
				$('div[rel='+node_id+'] .ucheck').addClass('check').removeClass('ucheck');
				$('img[alt=ic_'+action+']').attr('src', '/i/icons/org_hierarchy/i_cond_ok.png');
			} else {
				// creport: uncheck all visible siblings
				$('div[rel='+node_id+'] .check').addClass('ucheck').removeClass('check');
				$('img[alt=ic_'+action+']').attr('src', '/i/icons/org_hierarchy/i_cond_ok.png');
			}
		} else {
			if (tree_debug) console.log(">>> NO RESULT");
		}
	});
}

function hierrachyTreeCopyContact(node_obj, action, contact_id, owner_id, contact_role) {
	var node_id = $(node_obj).parent().attr('rel'),
		node = $(node_obj),
		cid = $(node_obj).parent().attr('alt');
	if (tree_debug) console.log('['+action+'] CLICK detected on Node #'+node_id+' (contact_id: '+contact_id+'; owner_id: '+owner_id+')');
	if (tree_debug) console.log('>>> sending a request to setCContact');
	if (tree_debug) console.log(">>> action=setCContact&id="+node_id+"&do="+action+"&contact_id="+contact_id+"&owner_id="+owner_id);

	$(node).addClass('ajax');
	$.ajax({
		type: "POST",
		url: "/ajax/hierarchy_tree.php",
		data: "action=setCContact&id="+node_id+"&do="+action+"&contact_id="+contact_id+"&owner_id="+owner_id+"&contact_role="+contact_role
	}).done(function(data) {
		if (data) {
			if (tree_debug) console.log(">>> we have a data: "+data);
			if (action=='ucheck') {
				// creport: check all visible siblings
				$('div[rel='+node_id+'] .ucheck').addClass('check').removeClass('ucheck');
			}
			else {
				// creport: uncheck all visible siblings
				$('div[rel='+node_id+'] .check').addClass('ucheck').removeClass('check');
			}
		}
		else {
			if (tree_debug) console.log(">>> NO RESULT");
		}
		$(node).removeClass('ajax');
	});
}

function hierrachyTreeCustomReport(node_obj, action, report_id, owner_id) {
	var node_id = $(node_obj).parent().attr('rel'), node = $(node_obj);
	$(node).addClass('ajax');
	if (tree_debug) console.log('['+action+'] CLICK detected on Node #'+node_id+' (report_id: '+report_id+'; owner_id: '+owner_id+')');
	if (tree_debug) console.log('>>> sending a request to setCReport');
	if (tree_debug) console.log(">>> action=setCReport&id="+node_id+"&do="+action+"&report_id="+report_id+"&owner_id="+owner_id);
	$.ajax({
		type: "POST",
		url: "/ajax/hierarchy_tree.php",
		data: "action=setCReport&id="+node_id+"&do="+action+"&report_id="+report_id+"&owner_id="+owner_id
	}).done(function(data) {
		if (data) {
			if (tree_debug) console.log(">>> we have a data: "+data);
			if (action=='ucheck') {
				// creport: check all visible siblings
				$('div[rel='+node_id+'] .ucheck').addClass('check').removeClass('ucheck');
			} else {
				// creport: uncheck all visible siblings
				$('div[rel='+node_id+'] .check').addClass('ucheck').removeClass('check');
			}
		} else {
			if (tree_debug) console.log(">>> NO RESULT");
		}
		$(node).removeClass('ajax');
	});
}

function enableDraggDrop(){
	$(".dragg-dropp").draggable({ snap: true, snapMode: "both", revert: "invalid", axis: "y", zIndex: 9999, distance: 5, scrollSensitivity: 80, scrollSpeed: 50, 
		drag: function(event, ui) { $(this).addClass("ui-state-highlight"); },
		stop: function(event, ui) { $(this).removeClass("ui-state-highlight"); }});
	
	$(".dragg-dropp, #etreewrap").droppable({ greedy: true,
		  drop: function(event, ui) {
			    $.get("/ajax/move_organization.php", { source: ui.draggable.attr('rel'), destination: $(this).attr('rel') },
			       function(data){
			    	  window.location.reload();
			    });
		  }
	});
}

function hierrachyTreeOpen(node_obj, render) {
	var node_id = $(node_obj).parent().attr('rel'), node = $(node_obj), user_id = $("input[name=user_id]").val(),
		url = "action=getChildren&parent="+node_id+"&render="+render;
	if (render=='creport') url+="&report_id="+$("#report_id").val()+"&owner_id="+$("#owner_id").val();
	else if (render=='ccontact') url+="&contact_id="+$("#cid").val()+"&owner_id="+$("#owner_id").val();
	else if (render=='book_import') url+="&cpos="+$("#import_location").val();
	else url+="&user_id="+user_id;
	
	$(node).removeClass('plus').addClass('ajax');
	if (tree_debug) {
		console.log('[plus] CLICK detected on Node #'+node_id);
		console.log('>>> sending a request to getChildren');
		console.log('>>> url: '+url);
	}
	$.ajax({
		type: 'POST',
		url: "/ajax.php?do=hierarchyGetChildren",
		dataType: 'html',
		data: url,
		success: function(data){
			if (data) {
				if (tree_debug) console.log(">>> we have a data, adding the sub-nodes now");
				// insert all the inside nodes
				$(node).siblings('.end').after(data);
				$(node).removeClass('ajax').addClass('minus');
				if(render=='edit'){
					//init dragg-drop (move location)
					enableDraggDrop();
				}
			}
			else {
				if (tree_debug) console.log(">>> NO RESULT");
					$(node).removeClass('ajax').addClass('plus');
			}
		}
	});
}

function hierrachyTreeClose(node_obj) {
	
	var node_id = $(node_obj).parent().attr('rel'), node = $(node_obj);
	
	if (tree_debug) console.log('[minus] CLICK detected on Node #'+node_id);
	if (tree_debug) console.log('>>> removing all .node items inside');
	$(node).removeClass('minus').addClass('ajax');
	$(node).siblings('.node').remove();
	$(node).removeClass('ajax').addClass('plus');
}

function hierrachyTreeCollapse() {
	$('.htree .node .minus').click();
}

function hierrachyTreeExpand() {
	$('.htree .node .plus').click();
}

function hierrachySaveNode(node_obj) {
	
	var node_id = $(node_obj).parent().attr('rel'), node = $(node_obj).parent(),
		title = $(node).children('input[name=title]').val(), add = $(node).children('input[name=add]').val(), criteria = $('.htree .fl select').val();
	if (tree_debug) console.log('[button] CLICK detected on Node #'+node_id);
	
	if (title.length > 0 && ((criteria!='name' && add.length >0) || criteria=='name')) {
		// we can save it
		if (tree_debug) console.log('>>> the new organization title is: '+title+' ('+title.length+' symbols)');
		if (tree_debug) console.log('>>> sending request to saveNode ajax');
		$(node).children(':first').addClass('ajax');
		$.ajax({
			type: "POST",
			url: "/ajax/hierarchy_tree.php",
			data: "action=saveNode&id="+node_id+"&title="+title+"&criteria="+criteria+"&add="+(add ? add : '')
		}).done(function(data) {
			if (data) {
				if (tree_debug) console.log(">>> we have a data, showing the message");
				if (tree_debug) console.log(">>> message: "+data);
				$(node).children(':last').after('<span class="m success">'+data+'</span>');
			} else {
				if (tree_debug) console.log(">>> NO RESULT");
				$(node).children(':last').after('<span class="m error">Unknown Error</span>');
			}
			$(node).children(':first').removeClass('ajax');
		});
		setTimeout("$('.htree .node[rel="+node_id+"]').children('span.m').remove();", 5000);
	} else {
		// showing an error message
		if (tree_debug) console.log('>>> there is no valid title!');
		$(node).children(':last').after('<span class="m error">Please fill the title field</span>');
	}
	return false;
}

function hierrachyClaimVisSave(node_obj) {
	// Claim Visibility Hierarchy
	// saves the visibility rule for selected node (select[name=vis])
	
	var node_id = $(node_obj).parent().attr('rel'), node = $(node_obj).parent(),
		vis = $(node).children('select[name=vis]').val(), user_id = $("input[name=user_id]").val();
	if (tree_debug) console.log('[select] CHANGE detected on Node #'+node_id);
	
	if (vis && vis>=0 && user_id && user_id>0) {
		// we can save it
		if (tree_debug) console.log('>>> the claim visibility is: '+vis);
		if (tree_debug) console.log('>>> sending request to saveVisibility ajax');
		$(node).children(':first').addClass('ajax');
		$.ajax({
			type: "POST",
			url: "/ajax/hierarchy_tree.php",
			data: "action=saveVisibility&id="+node_id+"&user_id="+user_id+"&vis="+vis
		}).done(function(data) {
			if (data) {
				if (tree_debug) console.log(">>> we have a data, showing the message");
				if (tree_debug) console.log(">>> message: "+data);
				$(node).children('span.end').after('<span class="m success">'+data+'</span>');
				$(node).children('.node').children('select[name=vis]').val(vis);
			} else {
				if (tree_debug) console.log(">>> NO RESULT");
				$(node).children('span.end').after('<span class="m error">Unknown Error</span>');
			}
			$(node).children(':first').removeClass('ajax');
			setTimeout("$('.htree .node[rel="+node_id+"]').children('span.m').remove();", 5000);
		});
	} else {
		// showing an error message
		if (tree_debug) console.log('>>> there is no valid user_id or visibility!');
		$(node).children('span.end').after('<span class="m error">Unknown Error</span>');
		setTimeout("$('.htree .node[rel="+node_id+"]').children('span.m').remove();", 5000);
	}
	return false;
}

function hierrachyMakeRoot(node_obj) {
	// Claim Visibility Hierarchy
	// saves selected node as root for the user
	var node_id = $(node_obj).parent().attr('rel'), node = $(node_obj).parent(),
		user_id = $("input[name=user_id]").val();
	if (tree_debug) console.log('[make root] button CLICKED in node ID# '+node_id);
	if (tree_debug) console.log('>>> sending a request to makeRoot');
	$.ajax({
		type: "POST",
		url: "/ajax/hierarchy_tree.php",
		data: "action=makeRoot&id="+node_id+"&user_id="+user_id
	}).done(function(data) {
		//console.log(data);
		if (tree_debug) console.log('>>> ROOT for user #'+user_id+' now is node #'+node_id);
		$('.htree .node .root').removeClass('is_root');
		$(node_obj).addClass('is_root');
	});
}

function hierrachyTreeFilter(obj, filter, criteria, render) {
	
	if (filter.length >= 2) {
		if (tree_debug) console.log('[filter] Current filter: '+filter);
		if (tree_debug) console.log('[filter] Current criteria: '+criteria);
		if (tree_debug) console.log('>>> sending a request to applyFilter');
		$(".htree .fl label").removeClass('i_filter').removeClass('i_filter_error').addClass('i_loading');
		$.ajax({
			type: "POST",
			url: "/ajax/hierarchy_tree.php",
			data: "action=applyFilter&filter="+filter+"&criteria="+criteria+"&render="+render
		}).done(function(data) {
			$('.htree .node').remove();
			if (data) {
				result = jQuery.parseJSON(data);
				if (result.matches) {
					if (tree_debug) console.log(">>> we have a data, showing the message and the nodes");
					var html = 'showed <strong>'+(result.limit > result.matches ? result.matches : result.limit)+'</strong> of <strong>'+result.matches+'</strong> matched results';
					if (result.limit < result.matches) html+=' (<a class="pointer all_results"><strong>show rest of the results</strong></a>)';
					$('.htree .fl p.message').html(html).removeClass('error');
					$('.htree br').after(result.data);
				} else {
					if (tree_debug) console.log(">>> CANNOT DECODE JSON RESULT");
					if (tree_debug) console.log(">>> data: "+data);
					$('.htree .fl p.message').html('there is <strong>no result using this filter</strong>, please try another one').addClass('error');
				}
			} else {
				if (tree_debug) console.log(">>> NO RESULT IN DATA");
				$('.htree .fl p.message').html('there is <strong>no result using this filter</strong>, please try another one').addClass('error');
			}
			$(".htree .fl label").removeClass('i_loading').addClass('i_filter');
		});
	} else {
		if (tree_debug) console.log('[filter] NO FILTER');
		if (filter.length == 0 && $(obj).is("input")) {
			// we reset the form using the same function as the `clear` button
			$(".htree .fl label").removeClass('i_loading').removeClass('i_filter_error').addClass('i_filter');
			$('.htree .fl a.bt_clear').click();
			$('.htree .fl input').focus();
			$('.htree .fl select').val(criteria);
		} else {
			$('.htree .fl p.message').html('please fill <strong>at least 2 symbols</strong> for filter to be applied').addClass('error');
			$(".htree .fl label").removeClass('i_filter').addClass('i_filter_error');
		}
	}
}

function hierrachyTreeFilterRest(filter, criteria, render) {
	
	if (tree_debug) console.log('[filter rest] Current filter: '+filter);
	if (filter.length >= 2) {
		if (tree_debug) console.log('>>> sending a request to restFilter');
		$(".htree .fl label").removeClass('i_filter').removeClass('i_filter_error').addClass('i_loading');
			$.ajax({
				type: "POST",
				url: "/ajax/hierarchy_tree.php",
				data: "action=restFilter&filter="+filter+"&render="+render+"&criteria="+criteria
			}).done(function(data) {
				if (data) {
					if (tree_debug) console.log(">>> we have a data, showing the rest of the nodes");
					$('.htree .fl p.message').html('showed <strong>all matched</strong> results').removeClass('error');
					$(".htree .node:last").after(data);
				} else {
					if (tree_debug) console.log(">>> NO RESULT IN DATA");
				}
				$(".htree .fl label").removeClass('i_loading').addClass('i_filter');
		});
	}
}

function hierrachyTreeFilterClear(clear_data, render) {
	$(".htree").html(clear_data);
	$.ajax({
		type: "POST",
		url: "/ajax/hierarchy_tree.php",
		data: "action=clearFilter&render="+render
	}).done(function(data) {
		console.log(data);
		$(".htree .fl input").val('');
		$(".htree .fl select").val('name');
	});
}

function hierrachyTreeExportLocation2xml(location_id) {
	window.location = "/ajax/export_organization2xml.php?id="+location_id;
	//$.ajax({
		//type: "GET",
		//url: "/ajax/export_organization2xml.php",
		//data: "id="+location_id
	//});
}