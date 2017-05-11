<p class="ss">section</p>
<h2>{$pagetitle|default:'Meta Data (Search Engine Optimizations)'}</h2>
<ul class="snav">
    <li><a href="?cat=pages" class="sel">page list</a></li>
    {*<li><a href="?cat=pages&amp;action=add&amp;id=999999" class="sel"><img src="interface/icons/add.gif" alt="добави" align="absmiddle" /> add new page</a></li>*}
</ul>
<h3>Page Edit</h3>
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
    <table width="100%" cellpadding="3" cellspacing="0" class="std">
    <tr>
        <td width="35%">Identifier</td>
        <td width="35%">Position in Page</td>
        <td width="30%">Order</td>
    </tr>
    <tr>
        <td><input type="text" name="page[identifier]" value="{$p.identifier}" class="in" disabled="disabled" /></td>
        <td>
            <select name="page[pos]" class="sl">
                <option value="top"{if $p.pos=='top'} selected="selected"{/if}>main navigation [top]</option>
                <option value="footer"{if $p.pos=='footer'} selected="selected"{/if}>footer navigation [footer]</option>
                <option value="ext"{if $p.pos=='ext'} selected="selected"{/if}>external link [ext]</option>
                <option value="hidden"{if $p.pos=='hidden'} selected="selected"{/if}>hidden page [hidden]</option>
                {*<option value="left"{if $p.pos=='left'} selected="selected"{/if}>в менюто вляво [left]</option>
                <option value="forums"{if $p.pos=='forums'} selected="selected"{/if}>връзка за форумите [forums]</option>
                <option value="register"{if $p.pos=='register'} selected="selected"{/if}>връзка за регистрацията [register]</option>
                *}
            </select>
        </td>
        <td><input type="text" name="page[position]" value="{$p.position}" class="in" /></td>
    </tr>
      
    <tr>
        <td>URL (change is non recommended)</td>
        <td>Name</td>
        <td>Name Addition</td>
    </tr>
    <tr>
        <td><input type="text" name="page[url]" value="{$p.url}" class="in" /></td>
        <td><input type="text" name="page[name]" value="{$p.name}" class="in" /></td>
        <td><input type="text" name="page[add]" value="{$p.add}" class="in" /></td>
    </tr>
    <tr><td colspan="3">Meta Title</td></tr>
    <tr><td colspan="3"><input type="text" name="page[title]" value="{$p.title}" class="in" /></td></tr>
      
    <tr>
        <td colspan="2">Meta Description</td>
        <td>Meta Keywords</td>
    </tr>
    <tr>
        <td colspan="2"><textarea name="page[description]" class="std" rows="3">{$p.description}</textarea></td>
        <td><textarea name="page[keywords]" class="std" rows="3">{$p.keywords}</textarea></td>
    </tr>
      
    <tr><td colspan="3"><input type="submit" name="page[save]" value="Save Changes" class="bt fixed100" /></td></tr>
    </table>
</fieldset>
</form>