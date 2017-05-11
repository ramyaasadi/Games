<script type="text/javascript" src="js/colorpicker.js"></script>
<script type="text/javascript" src="js/eye.js"></script>
<script type="text/javascript" src="js/utils.js"></script>

<p class="ss">section</p>
<h2>{$pagetitle|default:'Groups and Skins'}</h2>
<ul class="snav">
	<li><a href="?cat=skins">group list</a></li>
	<li><a href="?cat=skins&amp;action=add&amp;id=999999"><img src="interface/icons/add.gif" alt="add" align="absmiddle" /> add new group</a></li>
</ul>
<h3>Group: <strong>{$data.title}</strong></h3>
<nav class="stab">
	<a href="?cat=skins&action=edit&id={$data.id}"><img src="interface/icons/pencil.png" alt="edit" align="absmiddle" title="Edit Group's Data" /> edit</a>
	<a href="?cat=skins&action=skin&id={$data.id}"><img src="interface/icons/skins.gif" alt="skin" align="absmiddle" title="Customize Group's Skin" /> <strong>skin</strong></a>
	<a href="?cat=skins&action=articles&id={$data.id}"><img src="interface/icons/articles.png" alt="skin" align="absmiddle" title="Edit Group's Articles" /> articles</a>
	<a href="?cat=skins&action=terms&id={$data.id}"><img src="interface/icons/terms.png" alt="skin" align="absmiddle" title="Edit Group's Terms" /> terms</a>
</nav>
<p class="ss">
	identifier: <strong>{$data.ident}</strong><br />
	active: <strong>{if $data.active==1}yes{else}no{/if}</strong><br />
	created: <strong>{include file="global/date_format.tpl" date=$data.created}</strong><br />
	updated: <strong>{include file="global/date_format.tpl" date=$data.updated}</strong>
</p>

<form action="" method="post" enctype="multipart/form-data">
<fieldset>
	<h3>Skin Preview</h3>
	<section class="preview">
		<header>
			<section class="cont">
				<a href="/" id="logo"><img src="../i/logos/{$data.logo_file|default:'logo.png'}" alt="logo" /></a>
				<nav id="main">
					<a href="" class="sel">Home</a>
					<a href="">Account</a>
					<a href="">Solutions</a>
					<a href="" class="sm"><strong>Login</strong></a>
				</nav>
				<div class="clear"></div>
			</section>
		</header>
		<div id="home">
			{if $data.slide_files|default:false}
			<div class="slide c2" style="margin-right: 20px;" id="rotator_wrap">
				<div id="rotator">
					{foreach $data.slide_files as $slide}
					<img src="../i/slides/{$slide}" alt="Slide" />
					{/foreach}
				</div><!-- rotator -->
				<div class="cb"><!--  --></div>
				<div id="rotator_switch"></div><!-- rotator_switch -->
			</div><!-- rotator_wrap -->
			{else}
			<div class="panel c2" style="margin-right: 20px;">
				<h3>SlideShow</h3>
				<section class="cont">
					<p>You don't have the files for the slideshow yet.</p>
					<p>Please use the <strong><a href="#s_slideshow">SlideShow</a></strong> section below and upload up to 5 images for a slideshow.</p>
				</section>
			</div>
			{/if}
			<div class="c1">
				<div class="panel">
					<h3>Standard Panel</h3>
					<section class="cont">
						<p>This is how the buttons look, point at them to see the hover colors</p>
						<button class="std">Standard Button</button>
						<button class="emp">Emphasis Button</button><br />
					</section>
				</div>
				<div class="panel im">
					<h3>Non-Important Panel</h3>
					<section class="cont">
						<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</p>
					</section>
				</div>
			</div>
			<div class="clear"></div>
			<div class="clear"></div>
		</div><!-- home -->
	</section>
	<table class="std" width="" cellpadding="3" cellspacing="0" border="0">
	<tbody>
		<tr>
			<td colspan="6"><h3>Global</h3></td>
		</tr>
		<tr>
			<th><strong>background</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.global.background|default:'F0F0F0'}"></div>
					<input type="hidden" name="form[global][background]" value="{$data.skin.global.background|default:'F0F0F0'}" />
				</div>
			</td>
			<th><strong>text</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.global.text|default:'847C74'}"></div>
					<input type="hidden" name="form[global][text]" value="{$data.skin.global.text|default:'847C74'}" />
				</div>
			</td>
			<th><strong>accent</strong><br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.global.accent|default:'f4a319'}"></div>
					<input type="hidden" name="form[global][accent]" value="{$data.skin.global.accent|default:'f4a319'}" />
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="6"><h3>Header</h3></td>
		</tr>
		<tr>
			<th colspan="6"><h4>BACKGROUND</h4></th>
		</tr>
		<tr>
			<th><strong>primary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.header.background.primary|default:'40372c'}"></div>
					<input type="hidden" name="form[header][background][primary]" value="{$data.skin.header.background.primary|default:'40372c'}" />
				</div>
			</td>
			<th><strong>secondary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.header.background.secondary|default:'000000'}"></div>
					<input type="hidden" name="form[header][background][secondary]" value="{$data.skin.header.background.secondary|default:'000000'}" />
				</div>
			</td>
			<th><strong>shadow</strong><br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.header.shadow|default:'aaaaaa'}"></div>
					<input type="hidden" name="form[header][shadow]" value="{$data.skin.header.shadow|default:'aaaaaa'}" />
				</div>
			</td>
		</tr>
		<tr>
			<th colspan="6"><h4>MAIN MENU :normal</h4></th>
			<th colspan="6"><h4>MAIN MENU :hover</h4></th>
			<th colspan="6"><h4>MAIN MENU :selected</h4></th>
		</tr>
		<tr>
			<th>:normal <br /><strong>background</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.main.normal.background|default:'2c2a26'}"></div>
					<input type="hidden" name="form[menu][main][normal][background]" value="{$data.skin.menu.main.normal.background|default:'2c2a26'}" />
				</div>
			</td>
			<th>:normal <br /><strong>text</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.main.normal.text|default:'ffffff'}"></div>
					<input type="hidden" name="form[menu][main][normal][text]" value="{$data.skin.menu.main.normal.text|default:'ffffff'}" />
				</div>
			</td>
			<th>:normal <br /><strong>shadow</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.main.normal.shadow|default:'000000'}"></div>
					<input type="hidden" name="form[menu][main][normal][shadow]" value="{$data.skin.menu.main.normal.shadow|default:'000000'}" />
				</div>
			</td>
			<th>:hover <br /><strong>background</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.main.hover.background|default:'383632'}"></div>
					<input type="hidden" name="form[menu][main][hover][background]" value="{$data.skin.menu.main.hover.background|default:'383632'}" />
				</div>
			</td>
			<th>:hover <br /><strong>text</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.main.hover.text|default:'ffffff'}"></div>
					<input type="hidden" name="form[menu][main][hover][text]" value="{$data.skin.menu.main.hover.text|default:'ffffff'}" />
				</div>
			</td>
			<th>:hover <br /><strong>shadow</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.main.hover.shadow|default:'000000'}"></div>
					<input type="hidden" name="form[menu][main][hover][shadow]" value="{$data.skin.menu.main.hover.shadow|default:'000000'}" />
				</div>
			</td>
			<th>:selected <br /><strong>background</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.main.selected.background|default:'44423e'}"></div>
					<input type="hidden" name="form[menu][main][selected][background]" value="{$data.skin.menu.main.selected.background|default:'44423e'}" />
				</div>
			</td>
			<th>:selected <br /><strong>text</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.main.selected.text|default:'ffffff'}"></div>
					<input type="hidden" name="form[menu][main][selected][text]" value="{$data.skin.menu.main.selected.text|default:'ffffff'}" />
				</div>
			</td>
			<th>:selected <br /><strong>shadow</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.main.selected.shadow|default:'000000'}"></div>
					<input type="hidden" name="form[menu][main][selected][shadow]" value="{$data.skin.menu.main.selected.shadow|default:'000000'}" />
				</div>
			</td>
		</tr>
		<tr>
			<th colspan="6"><h4>MEMBER SUBMENU</h4></th>
		</tr>
		<tr>
			<th><strong>background</strong><br />color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.sub.background|default:'000000'}"></div>
					<input type="hidden" name="form[menu][sub][background]" value="{$data.skin.menu.sub.background|default:'44423e'}" />
				</div>
			</td>
			<th><strong>text</strong><br />color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.menu.sub.color|default:'000000'}"></div>
					<input type="hidden" name="form[menu][sub][color]" value="{$data.skin.menu.sub.color|default:'ffffff'}" />
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="6"><h3>Panels</h3></td>
		</tr>
		<tr>
			<th colspan="6"><h4>STANDARD PANEL</h4></th>
			<th colspan="6"><h4>NON-IMPORTANT PANEL</h4></th>
		</tr>
		<tr>
			<th><strong>background<br />primary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.panel.background.primary|default:'faab18'}"></div>
					<input type="hidden" name="form[panel][background][primary]" value="{$data.skin.panel.background.primary|default:'faab18'}" />
				</div>
			</td>
			<th><strong>background<br />secondary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.panel.background.secondary|default:'e3881e'}"></div>
					<input type="hidden" name="form[panel][background][secondary]" value="{$data.skin.panel.background.secondary|default:'e3881e'}" />
				</div>
			</td>
			<th><strong>text</strong><br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.panel.text|default:'40372c'}"></div>
					<input type="hidden" name="form[panel][text]" value="{$data.skin.panel.text|default:'40372c'}" />
				</div>
			</td>
			<th><strong>background<br />primary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.impanel.background.primary|default:'ebebeb'}"></div>
					<input type="hidden" name="form[impanel][background][primary]" value="{$data.skin.impanel.background.primary|default:'ebebeb'}" />
				</div>
			</td>
			<th><strong>background<br />secondary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.impanel.background.secondary|default:'dadada'}"></div>
					<input type="hidden" name="form[impanel][background][secondary]" value="{$data.skin.impanel.background.secondary|default:'dadada'}" />
				</div>
			</td>
			<th><strong>text</strong><br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.impanel.text|default:'847c74'}"></div>
					<input type="hidden" name="form[impanel][text]" value="{$data.skin.impanel.text|default:'847c74'}" />
				</div>
			</td>
		</tr>
		<tr><td colspan="6"><h3>Buttons</h3></td></tr>
		<tr>
			<th colspan="6"><h4>STANDARD BUTTON :normal</h4></th>
			<th colspan="6"><h4>STANDARD BUTTON :hover</h4></th>
		</tr>
		<tr>
			<th><strong>background<br />primary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.button.standard.background.primary|default:'faab18'}"></div>
					<input type="hidden" name="form[button][standard][background][primary]" value="{$data.skin.button.standard.background.primary|default:'faab18'}" />
				</div>
			</td>
			<th><strong>background<br />secondary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.button.standard.background.secondary|default:'e3881e'}"></div>
					<input type="hidden" name="form[button][standard][background][secondary]" value="{$data.skin.button.standard.background.secondary|default:'e3881e'}" />
				</div>
			</td>
			<th><strong>text</strong><br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.button.standard.text|default:'40372c'}"></div>
					<input type="hidden" name="form[button][standard][text]" value="{$data.skin.button.standard.text|default:'40372c'}" />
				</div>
			</td>
			<th><strong>background<br />primary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.button.hover.background.primary|default:'fcb735'}"></div>
					<input type="hidden" name="form[button][hover][background][primary]" value="{$data.skin.button.hover.background.primary|default:'fcb735'}" />
				</div>
			</td>
			<th><strong>background<br />secondary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.button.hover.background.secondary|default:'e4971e'}"></div>
					<input type="hidden" name="form[button][hover][background][secondary]" value="{$data.skin.button.hover.background.secondary|default:'e4971e'}" />
				</div>
			</td>
			<th><strong>text</strong><br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.button.hover.text|default:'342302'}"></div>
					<input type="hidden" name="form[button][hover][text]" value="{$data.skin.button.hover.text|default:'342302'}" />
				</div>
			</td>
		</tr>
		<tr>
			<th colspan="6"><h4>EMPSASIS BUTTON :normal</h4></th>
			<th colspan="6"><h4>EMPSASIS BUTTON :hover</h4></th>
		</tr>
		<tr>
			<th><strong>background<br />primary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.emp_button.standard.background.primary|default:'597cc8'}"></div>
					<input type="hidden" name="form[emp_button][standard][background][primary]" value="{$data.skin.emp_button.standard.background.primary|default:'597cc8'}" />
				</div>
			</td>
			<th><strong>background<br />secondary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.emp_button.standard.background.secondary|default:'385aa8'}"></div>
					<input type="hidden" name="form[emp_button][standard][background][secondary]" value="{$data.skin.emp_button.standard.background.secondary|default:'385aa8'}" />
				</div>
			</td>
			<th><strong>text</strong><br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.emp_button.standard.text|default:'ffffff'}"></div>
					<input type="hidden" name="form[emp_button][standard][text]" value="{$data.skin.emp_button.standard.text|default:'ffffff'}" />
				</div>
			</td>

			<th><strong>background<br />primary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.emp_button.hover.background.primary|default:'4366b2'}"></div>
					<input type="hidden" name="form[emp_button][hover][background][primary]" value="{$data.skin.emp_button.hover.background.primary|default:'4366b2'}" />
				</div>
			</td>
			<th><strong>background<br />secondary</strong> <br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.emp_button.hover.background.secondary|default:'26458e'}"></div>
					<input type="hidden" name="form[emp_button][hover][background][secondary]" value="{$data.skin.emp_button.hover.background.secondary|default:'26458e'}" />
				</div>
			</td>
			<th><strong>text</strong><br /> color</th>
			<td>
				<div class="cbox">
					<div style="background-color: #{$data.skin.emp_button.hover.text|default:'ffffff'}"></div>
					<input type="hidden" name="form[emp_button][hover][text]" value="{$data.skin.emp_button.hover.text|default:'ffffff'}" />
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="6"><h3 id="s_slideshow">Slideshow</h3></td>
			<td colspan="6"><h3>Logo</h3></td>
		<tr>
		<tr>
			<th colspan="6">
				<p>You can upload up to 5 image files for the home page's slideshow.</p>
				<p>Supported file formats: <strong>JPG, PNG, GIF</strong></p>
				<p>Slide resolution: <strong>680 x 320px</strong></p>
			</th>
			<th colspan="6">
				<p>You can upload your company logo from here.</p>
				<p>Supported file formats: <strong>JPG, PNG, GIF</strong></p>
				<p>Logo resolution: <strong>up to 275 x 100px</strong></p>
			</th>
		</tr>
		{section name=foo start=0 loop=5 step=1}
		<tr>
			<th>Slide {$smarty.section.foo.index+1}</th>
			<td colspan="5">
				{if $data.slide_files[$smarty.section.foo.index]|default:false}
					<a href="?cat=skins&action=edit&id={$data.id}&amp;remove_slide={$smarty.section.foo.index}"><img src="../i/icons/org_hierarchy/i_remove.png" alt="remove" align="absmiddle" /></a>
					<a href="../i/slides/{$data.slide_files[$smarty.section.foo.index]}" target="_blank">{$data.slide_files[$smarty.section.foo.index]}</a>
				{else}
				<input type="file" name="slide[{$smarty.section.foo.index}]" />
				{/if}
			</td>
			{if $smarty.section.foo.index == 0}
			<th>Logo</th>
			<td colspan="5">
				{if $data.logo_file|default:false}
				<a href="?cat=skins&action=edit&id={$data.id}&amp;remove_logo=true"><img src="../i/icons/org_hierarchy/i_remove.png" alt="remove" align="absmiddle" /></a>
				<a href="../i/logos/{$data.logo_file}">{$data.logo_file}</a>
				{else}
				<input type="file" name="logo" />
				{/if}
			</td>
			{/if}
		</tr>
		{/section}
		</tr>
	</tbody>
	</table>
	<hr />
	<input type="submit" value="Save Changes" name="form[save]" class="bt" />
</fieldset>
</form>

<script type="text/javascript">
	function getHex(rgbString) {
		var parts = rgbString.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
		delete (parts[0]);
		for (var i = 1; i <= 3; ++i) {
		    parts[i] = parseInt(parts[i]).toString(16);
		    if (parts[i].length == 1) parts[i] = '0' + parts[i];
		}
		return hexString = parts.join('').toUpperCase();
	}
	$(document).ready(function() {
		$('#rotator_switch').append('<ul></ul>');
	    $('#rotator').cycle({
			fx: 'fade', // choose your transition type, ex: fade, scrollUp, shuffle, etc...
			pager: '#rotator_switch ul',
			cleartype:  true,
			cleartypeNoBg: true,
			loop: true,
			pause: true //pause on hover
		});
		$('.cbox').ColorPicker({
			onShow: function (colpkr) {
				var color = getHex($(this).children('div').css('backgroundColor'));
				$(this).ColorPickerSetColor(color);
				$(colpkr).fadeIn(500); return false;
			},
			onHide: function (colpkr) { $(colpkr).fadeOut(500); return false; },
			onSubmit: function (hsb, hex, rgb, el) {
				$(el).children('div').css('backgroundColor', '#' + hex);
				console.log('setting value #'+hex+' to '+$(el).children('input').attr('name'));
				$(el).children('input').val(hex);
			}
		});
	});
</script>