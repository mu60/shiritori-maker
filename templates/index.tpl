<h1>{get_bloginfo("name")}</h1>

<p>{get_bloginfo("description")}</p>

<table>
	<thead>
		<tr>
			<th>作成日時</th>
			<th>タイトル</th>
			<th>説明</th>
		</tr>
	</thead>
	<tbody>
		{foreach from=shiritori\index_new_game_list() item=$shiritori}
			<tr>
				<td>{get_the_date(get_option("date_format"), $shiritori->ID)}</td>
				<td>
					<a href="{get_permalink($shiritori->ID)}">{$shiritori->post_title}</a>
				</td>
				<td>{nl2br(esc_html(get_post_meta($shiritori->ID, "description", true)))}</td>
			</tr>
		{/foreach}
	</tbody>
</table>
