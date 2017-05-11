<p class="ss">section</p>
<h2>{$pagetitle|default:'Groups and Skins'}</h2>
<ul class="snav">
    <li><a href="?cat=skins">group list</a></li>
    <li><a href="?cat=skins&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new group</a></li>
</ul>
<h3>Group: <strong>{$data.title}</strong></h3>
<nav class="stab">
    <a href="?cat=skins&action=edit&id={$data.id}"><img src="interface/icons/pencil.png" alt="edit" align="absmiddle" title="Edit Group's Data" /> edit</a>
    <a href="?cat=skins&action=skin&id={$data.id}"><img src="interface/icons/skins.gif" alt="skin" align="absmiddle" title="Customize Group's Skin" /> skin</a>
    <a href="?cat=skins&action=articles&id={$data.id}"><img src="interface/icons/articles.png" alt="skin" align="absmiddle" title="Edit Group's Articles" /> articles</a>
    <a href="?cat=skins&action=terms&id={$data.id}"><img src="interface/icons/terms.png" alt="skin" align="absmiddle" title="Edit Group's Terms" /> <strong>terms</strong></a>
</nav>
<p class="ss">
    identifier: <strong>{$data.ident}</strong><br />
    active: <strong>{if $data.active==1}yes{else}no{/if}</strong><br />
    created: <strong>{include file="global/date_format.tpl" date=$data.created}</strong><br />
    updated: <strong>{include file="global/date_format.tpl" date=$data.updated}</strong>
</p>
<h3>Group Terms</h3>
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
    <table class="std" cellpadding="3" cellspacing="0">
    <thead>
        <tr>
            <th>order</th>
        	<th>original value</th>
        	<th>replace it with</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$terms key=term item=replacement name="t"}
        <tr>
            <td><input type="text" class="in" name="term[{$term}][order]" value="{$smarty.foreach.t.iteration}" style="width: 30px" /></td>
        	<td>{$term}</td>
        	<td><input type="text" class="in" name="term[{$term}][value]" value="{$replacement}" /></td>
        </tr>
        {/foreach}
        <tr>
        	<td colspan="2"><input type="submit" name="term[save]" value="Save Changes" class="bt" /></td>
        </tr>
    </tbody>
    </table>
</fieldset>
</form>

<p class="legend">
    <strong>Important:</strong> The order value determines in which order the terms will be replaced, so be careful. <br />
    Try to avoid something like this: "Claimant" > "Employee" and next to be "Employee" > "Our Employee" because this will replace all the previous "Claimant" terms as well.
</p>