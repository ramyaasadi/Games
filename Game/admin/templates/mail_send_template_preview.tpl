<h2>Изпращане на писма: Стъпка 4</h2>
<h4>Прегледай дали писмото изглежда както се очаква и го изпрати</h4>
<br />
{include file="global/message.tpl"}
<table width="100%" cellpadding="5" cellspacing="0" class="std">
<tr>
    <td width="70%">
        <iframe src="?cat=mail_templates&action=preview&id={$t.id}&reg_id={$t.reg_id}" width="100%" height="500">
            <p>Your browser does not support iframes.</p>
        </iframe>
        <form action="" method="post">
        <fieldset>
            <input type="submit" name="mail[send]" class="bt fixed200" value="Изпрати писмата" />
        </fieldset>
        </form>
    </td>
    <td align="left" valign="top">
        <strong>Списък на адресите, на които ще бъде изпратено писмото:</strong>
        <br /><br />
        <ul>
        {foreach from=$r item=item}
            <li>{$item.email}</li>
        {/foreach}
        </ul>
        {*
        <br />
        <strong>Списък на потребителите, на които ще бъде изпратено писмото:</strong>
        <br /><br />
        <ul>
        {foreach from=$r item=item}
            <li>{$item.name}</li>
        {/foreach}
        </ul>
        *}
    </td>
</tr>
</table>