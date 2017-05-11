<h2>Банер</h2>
{include file="global/message.tpl"}
<form action="" method="post">
<fieldset>
    <table width="100%" cellpadding="3" cellspacing="0" class="std">
    <tr><td colspan="2">
        {if $d.pos=='header_1'}
            {assign var='width' value=728}
            {assign var='height' value=132}
        {elseif $d.pos=='header_2'}
            {assign var='width' value=728}
            {assign var='height' value=75}
        {else}
            {assign var='width' value=250}
            {assign var='height' value=250}
        {/if}
        {include file="global/image_flash.tpl" item=$d width=$width height=$height}
    </td></tr>
    <tr>
        <td>Тип</td>
        <td>Позиция <em>всички банери е препоръчително да бъдат в указаните резолюции</em></td>
    </tr>
    <tr>
        <td>
            <select name="banner[type]" class="sl">
                <option value="image"{if $d.type=='image'} selected="selected"{/if}>картинка [image]</option>
                <option value="flash"{if $d.type=='flash'} selected="selected"{/if}>флаш [flash]</option>
            </select>
        </td>
        <td>
            <select name="banner[pos]" class="sl">
                <option value="header_1"{if $d.pos=='header_1'} selected="selected"{/if}>Основна Заглавка - 728x132px</option>
                <option value="header_2"{if $d.pos=='header_2'} selected="selected"{/if}>Допълнителна Заглавка - 728x75px</option>
                <option value="presentation_1"{if $d.pos=='presentation_1'} selected="selected"{/if}>Презентация - 250x250px</option>
            </select>
        </td>
    </tr>
    <tr><td colspan="2">Адрес</td></tr>
    <tr><td colspan="2"><input type="text" name="banner[url]" value="{$d.url}" class="in" /></td></tr>
    <tr><td colspan="2">Описание</td></tr>
    <tr><td colspan="2"><textarea name="banner[desc]" class="std" rows="3">{$d.desc}</textarea></td></tr>
    <tr><td colspan="2">Файл<br /> <em>(не можете да променяте вече каченият файл)</em></td></tr>
    <tr><td colspan="2"><input type="text" name="banner[path]" value="{$d.path}" class="in" disabled="disabled" /></td></tr>
    <tr><td colspan="2"><hr /><input type="submit" name="banner[save]" value="Запиши" class="bt fixed100" /></td></tr>
    </table>
</fieldset>
</form>