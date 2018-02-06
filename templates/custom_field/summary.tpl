<table id="shiritori_table_summary" class="shiritori_input_table">
	<tr>
		<th>説明文</th>
		<td><textarea name="description" class="description">{get_post_meta(get_the_ID(), "description", true)}</textarea></td>
	</tr>
	<tr>
		<th>使用カード数</th>
		<td><input type="number" name="use_cards" value="{get_post_meta(get_the_ID(), 'use_cards', true)}" /></td>
	</tr>
	<tr>
		<th>クリア目標数</th>
		<td><input type="number" name="clear_point" value="{get_post_meta(get_the_ID(), 'clear_point', true)}" /></td>
	</tr>
</table>
