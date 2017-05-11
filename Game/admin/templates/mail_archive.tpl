<p class="ss">section</p>
<h2>{$pagetitle|default:'Mail Archive'}</h2>
<ul class="snav">
	<li><a href="?cat=mail_archive" class="sel">mail list</a></li>
</ul>
<h3>Mail Archive List</h3>
<br />
<form action="" method="post">
<fieldset>
    <table cellpadding="3" cellspacing="0" class="std" border="0">
    <tr>
        <td>Search message using</td>
        <td>
            <select name="filter[by]" class="sl">
                <option value="to">e-mail address</option>
            </select>
        </td>
        <td><input type="text" name="filter[string]" class="in" /></td>
        <td><input type="submit" name="filter[apply]" value="Search" class="bt" /></td>
    </tr>
	</table>
	<table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">
    <tr>
          <th>subject</th>
          <th>send to</th>
          <th>date</th>
          <th></th>
    </tr>
    {foreach from=$list item=item}
    <tr{cycle values=', class="even"'}>
          <td nowrap="nowrap"><a href="?cat=mail_archive&amp;action=view&amp;id={$item.id}">{$item.subject}</a></td>
          <td>{$item.to}</td>
          <td>{$item.date}</td>
          <td align="right" nowrap="nowrap" class="admin">
                <a href="javascript: if (confirm('Are you sure you want to erase this message from the archive?')) location.href='?cat=mail_archive&amp;action=erase&amp;id={$item.id}';"><img src="interface/icons/erase.gif" alt="erase" align="absmiddle" title="Erase Message" /></a>
                <a href="?cat=mail_archive&amp;action=view&amp;id={$item.id}"><img src="interface/icons/preview.gif" alt="preview" align="absmiddle" title="Preview Message" /></a>
          </td>
    </tr>
    {/foreach}
    </table>
</fieldset>
</form>
{include file="global/pg.tpl" paging=$paging}
{include file="legend.tpl"}