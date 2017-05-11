{if !$email}
<p class="ss">section</p>
<h2>{$pagetitle|default:'Statistic Page'}</h2>
<ul class="snav">
	<li><a href="?cat=statistic&display" class="sel">Statistic Page</a></li>
	<li><a href="?cat=statistic" class="sel">Send Statistic Page to Email</a></li>
</ul>
{/if}
<h3>Statistic Page</h3>
<br />
<form enctype="multipart/form-data" method="post" action="">
	<fieldset>
		<table cellspacing="0" cellpadding="3" border="0" class="std">
			<tbody>
				<tr>
					<td>Start Date</td>
					<td>End Date</td>
				</tr>
				<tr>
					<td><input class="dateCtrl" type="text" name="stat[start_date]"/></td>
					<td><input class="dateCtrl" type="text" name="stat[end_date]"/></td>
				</tr>
				<tr>
					<td><button type="submit" name="stat[submit]" value="submit">Submit</button> </td>
				</tr>
			</tbody>
		</table>
	</fieldset>
</form>
<script>
$(function(){
	$('.dateCtrl').datepicker();
});
</script>
	  