function urlCleanup(url, arr) {
	console.log('here');
	var new_url = '';
	url_org = url.split('?');
	
	if (url_org[1]) {
		url = url_org[1].split('#');
		url = url[0].split('&');
		if (arr && (arr.length > 0)) {
			for(var u=0; u<url.length; u++) {
				if (typeof(url[u]) != 'undefined' && url[u] != '') {
					val = url[u].split('=');
					da_eba_javascript = false;
					for(var i=0; i<arr.length; i++) {
						da_eba_javascript = (val[0] == arr[i]) && (val[1] != '');
						if (da_eba_javascript === true) break;
					}
					if (da_eba_javascript !== true) {
						new_url = new_url + '&' + val[0] + '=' + val[1];
						i=arr.length;
					}
				}
			}
		}
	}
	
	new_url = url_org[0] +  (new_url != '' ? '?' + new_url.substring(1) : '?'); //
	console.log(new_url);
	return new_url;
}

function hierarchyChooser(){
	$('body').append('<div class="md"></div>');
	
	$.ajax({
		url : '/ajax.php?do=hierarchyChooser',
		method : 'POST',
		async: false ,
		success: function(data){
			var d = '<div class="aPop"><div class="popupContainer">' + 
			data + 
			'</div</div>';
			$('body').append(d);
			var win_width 	= $(window).width(),
			win_height 	= $(window).height(),
			scroll_top 	= $(document).scrollTop(),
			scroll_left = $(document).scrollLeft();
			$('.aPop').css('overflow-y', 'scroll');
			$('.aPop').css('width', 600);
			$('.aPop').css('height', 400);
			$('.aPop').css('top', ((win_height-400)/2)+scroll_top);
			$('.aPop').css('left', ((win_width-600)/2)+scroll_left);
		}
	});
}

function syncCKEditorInstances()
{
    for (instance in CKEDITOR.instances) {
            CKEDITOR.instances[instance].updateElement();
    }
}