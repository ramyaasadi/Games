<p class="ss">section</p>
<h2>{$pagetitle|default:'Files'}</h2>

<h3>File Browser</h3>

<script type="text/javascript" src="js/ckfinder/ckfinder.js"></script>
<script type="text/javascript">
{literal}
	// This is a sample function which is called when a file is selected in CKFinder.
	function showFileInfo( fileUrl, data ) {
		var msg = 'The selected URL is: <a href="' + fileUrl + '">' + fileUrl + '</a><br /><br />';
		// Display additional information available in the "data" object.
		// For example, the size of a file (in KB) is available in the data["fileSize"] variable.
		if ( fileUrl != data['fileUrl'] ) msg += '<b>File url:</b> ' + data['fileUrl'] + '<br />';
		msg += '<b>File size:</b> ' + data['fileSize'] + 'KB<br />';
		msg += '<b>Last modified:</b> ' + data['fileDate'];
		// this = CKFinderAPI object
		this.openMsgDialog( "Selected file", msg );
	}
	
	// You can use the "CKFinder" class to render CKFinder in a page:
	var finder = new CKFinder();
	// The path for the installation of CKFinder (default = "/ckfinder/").
	finder.basePath = '../';
	finder.height = 600;
	// This is a sample function which is called when a file is selected in CKFinder.
	finder.selectActionFunction = showFileInfo;
	finder.create();
{/literal}
</script>