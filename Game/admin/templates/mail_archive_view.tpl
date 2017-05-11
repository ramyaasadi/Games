<p class="ss">section</p>
<h2>{$pagetitle|default:'Mail Archive'}</h2>
<ul class="snav">
	<li><a href="?cat=mail_archive">mail list</a></li>
    <li><a href="?cat=mail_archive&amp;action=view&amp;id={$id}" class="sel"><img src="interface/icons/preview.gif" alt="preview" align="absmiddle" /> viewer</a></li>
</ul>
<h3>Mail Viewer</h3>
<br />
<iframe src="?cat=mail_archive&action=preview&id={$id}" width="100%" height="600">
    <p>Your browser does not support iframes.</p>
</iframe>