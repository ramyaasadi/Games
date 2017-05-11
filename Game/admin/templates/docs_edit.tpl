<p class="ss">section</p>
<h2>Documents</h2>

<ul class="snav">
    <li><a href="?cat=docs&action=list&filter=uploaded"{if $filter=='uploaded'} class="sel"{/if}><em>{$stats.docs.uploaded|default:0}</em> for conversion</a></li>
	<li><a href="?cat=docs&action=list&filter=for-review"{if $filter=='for-review'} class="sel"{/if}><em>{$stats.docs.for_review|default:0}</em> for review</a></li>
	<li><a href="?cat=docs&action=list&filter=for-sale"{if $filter=='for-sale'} class="sel"{/if}><em>{$stats.docs.for_sale|default:0}</em> for sale</a></li>
	<li><a href="?cat=docs&action=list&filter=for-erase"{if $filter=='for-erase'} class="sel"{/if}><em>{$stats.docs.for_erase|default:0}</em> marked for erase</a></li>
	<li><a href="#edit" class="sel"><img src="interface/icons/edit.gif" alt="edit" align="absmiddle" /> document edit</a></li>
</ul>
<br />
{include file="global/message.tpl" message=$docm}
{if $doc.for_erase>0}
<p class="for_erase">
	The document is marked for erase, but is not erased yet, you can
	<a href="#erase" onclick="if (confirm('Are you sure you want to erase this document?')) location.href='?cat=docs&amp;action=erase&amp;id={$doc.id}';">erase it right away</a>.
</p>
{/if}
{if $doc.status=='uploaded'}
	<h2>This document is awaiting conversion</h2>
	<h3><strong>1.</strong> Download the original file from link below</h3>
	<p><button class="bti" onclick="location.href='/uploads/{$doc.filename}';">Download Original</button></p>
	<h3><strong>2.</strong> Convert the document.</h3>
	<h3><strong>3.</strong> Then upload the converted copy.</h3>
	<form action="" method="post" enctype="multipart/form-data">
	<fieldset>
		<input type="file" name="upload" value="" />
		<input type="submit" name="upload_copy" class="bt" value="Upload Converted Copy" />
	</fieldset>
	</form>
{elseif $doc.status=='for-review'}
	<h2>This document is awaiting approval from the author</h2>
	<h3>Document was uploaded {include file="global/time_passed.tpl" date=$doc.date_uploaded}, and converted {include file="global/time_passed.tpl" date=$doc.date_converted}</h3>
	<p>
		<br />
		<button class="bt" onclick="location.href='?cat=docs&action=download&type=original&id={$doc.id}';">Download Original</button>
		<button class="bti" onclick="location.href='?cat=docs&action=download&type=review&id={$doc.id}';">Download Review Copy</button>
	</p>
{elseif $doc.status=='reviewed'}
	<h2>This document is on sale</h2>
	<h3>From here you will be able to make real sales, when for now we have mock up sales for presentational purposes only.</h3>
	<form action="" method="post">
	<fieldset>
		<table class="std" width="300" cellpadding="3" cellspacing="0">
		<tbody>
			<tr>
				<td colspan="2"><label>buyer ID <em>(number only)</em></label></td>
			</tr>
			<tr>
				<td><input type="input" name="sale[buyer_id]" class="in" value="{$sale.buyer_id|default:1}" /></td>
				<td><input type="submit" name="sale[now]" class="bt" value="Make Sale" /></td>
			</tr>
		</tbody>
		</table>
	</fieldset>
	</form>
{/if}
<hr />
<table width="100%" cellpadding="5" cellspacing="0">
<tbody>
	<tr valign="top">
		<td width="50%">
			<h3>{$intitle|default:'Document Edit'}</h3>
			{include file="global/message.tpl"}
			<form action="" method="post">
			<fieldset>
				<table cellpadding="3" cellspacing="0" class="std">
				<tbody>
					<tr><th>title</th></tr>
					<tr><td><input type="text" name="form[title]" value="{$doc.title|escape:'html'}" class="in" style="width: 500px;" /></td></tr>
					<tr><th>description</th></tr>
					<tr><td><textarea name="form[description]" rows="10" class="std" style="width: 500px;">{$doc.description|escape:'html'}</textarea></td></tr>
					<tr><td><input type="submit" name="form[save]" value="Save Changes" class="bt" /></td></tr>
				</tbody>
				</table>
			</fieldset>
			</form>
		</td>
		<td>
			<h3>Document Statistics</h3>
			<br />
			<table width="300" cellpadding="3" cellspacing="0" class="simple">
			<tbody>
				<tr><th>document author</th></tr>
				<tr><td><a href="?cat=members&action=stats&id={$doc.user_id}">{$doc.first_name} {$doc.last_name}</a></td></tr>
				<tr><th>uploaded</th></tr>
				<tr><td>{if $doc.date_uploaded}{include file="global/time_passed.tpl" date=$doc.date_uploaded}{else}N/A{/if}</td></tr>
				<tr><th>converted</th></tr>
				<tr><td>{if $doc.date_converted}{include file="global/time_passed.tpl" date=$doc.date_converted}{else}N/A{/if}</td></tr>
				<tr><th>reviewed</th></tr>
				<tr><td>{if $doc.date_reviewed}{include file="global/time_passed.tpl" date=$doc.date_reviewed}{else}N/A{/if}</td></tr>
				<tr><th>download links</th></tr>
				<tr>
					<td>{if $doc.filename}<img src="/interface/ic_download.png" alt="icon" align="absmiddle" /> <a href="?cat=docs&action=download&type=original&id={$doc.id}">original</a><br />{/if}
						{if $doc.converted}<img src="/interface/ic_download.png" alt="icon" align="absmiddle" /> <a href="?cat=docs&action=review&type=original&id={$doc.id}">review copy</a>{/if}</td>
				</tr>
				<tr><th>status</th></tr>
				<tr>
					<td nowrap="nowrap">
						{if $doc.status=='for-review'}
						<em>For Review</em>
						{elseif $doc.status=='uploaded'}
						<em>Waiting Conversion</em>
						{elseif $doc.status=='reviewed'}
						<em>In Sale</em>
						<img src="/interface/ic_sold.gif" alt="sold" align="absmiddle" />
						<strong>{$doc.sold|default:0}</strong> copies
						{else}
						<em>Unknown</em>
						{/if}
					</td>
				</tr>
			</tbody>
			</table>
		</td>
	</tr>
</tbody>
</table>
{if $doc.sold>0}
<h3>Document Sales</h3>
<table width="100%" cellpadding="3" cellspacing="0" class="std">
<thead>
	<tr>
		<th>buyer ID</th>
		<th>sale date</th>
	</tr>
</thead>
<tbody>
	{foreach from=$doc.sales item=item}
	<tr>
		<td><strong>#{$item.buyer_id}</strong></td>
		<td>{if $item.buy_date}{include file="global/time_passed.tpl" date=$item.buy_date}{else}N/A{/if}</td>
	</tr>
	{/foreach}
</tbody>
</table>
{/if}
<br />