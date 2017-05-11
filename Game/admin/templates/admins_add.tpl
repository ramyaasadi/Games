<p class="ss">section</p>
<h2>{$pagetitle|default:'Administrators'}</h2>
<ul class="snav">
    <li><a href="?cat=administrators">administrators list</a></li>
    <li><a href="?cat=administrators&amp;action=add&amp;id=999999" class="sel"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new administrator</a></li>
</ul>
<h3>Add New Administrators</h3>
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
    <table width="100%" cellpadding="3" cellspacing="0" class="std" border="0">
    <tr>
        <td width="33%">Full name</td>
        <td width="33%">Username</td>
        <td>Type</td>
    </tr>
    <tr>
        <td><input type="text" name="admin[name]" value="{$n.name|escape:'html'}" class="in" /></td>
        <td><input type="text" name="admin[username]" value="{$n.username|escape:'html'}" class="in" /></td>
        <td>
            <select name="admin[type]" class="sl">
                <option value="visitor"{if $n.type=='visitor'} selected="selected"{/if}>Visitor</option>
                <option value="sales"{if $n.type=='sales'} selected="selected"{/if}>Sales Person</option>
                <option value="manager"{if $n.type=='manager'} selected="selected"{/if}>Manager</option>
                <option value="administrator"{if $n.type=='administrator'} selected="selected"{/if}>Administrator</option>
            </select>
        </td>
    </tr>
    <tr>
        <td>New Password</td>
        <td>Password Confirmation</td>
        <td rowspan="2">
            <p class="info">
            	The password and confirmation must MATCH!
            </p>
        </td>
    </tr>
    <tr>
        <td><input type="password" name="admin[password]" value="" class="in" /></td>
        <td><input type="password" name="admin[password_confirm]" value="" class="in" /></td>
    </tr>
    <tr>
        <td colspan="3">
              <input type="submit" name="admin[save]" value="Save Changes" class="bt fixed100" />
        </td>
    </tr>
    </table>
</fieldset>
</form>

<p class="legend">
    <strong>Legend:</strong><br />
    Type: <strong>Visitor</strong> - he can visit the page even is closed.<br />
    Type: <strong>Manager</strong> - moderate access, can change all the site information, but cannot add/edit administrators.<br />
    Type: <strong>Administrator</strong> - full access, can change everything.
</p>