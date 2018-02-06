
<table id="shiritori_table_cards" class="shiritori_input_table card_add_table">

	<thead>
		<tr>
			<th id="media_column">画像</th>
			<th>読み</th>
			<th>裏読み</th>
			<th>カード削除</th>
		</tr>
	</thead>

	<tbody>
		{assign var="i" value=0}
		{foreach from=$cards item=$card}
			<tr class="card_wrap" data-number="{$i}">
				<td class="card_media_wrap">
					<div>
						<p class="put_image">{wp_get_attachment_image($card["image_id"])}</p>
						<input class="image_id" type="hidden" name="image_id[{$i}]" value="{$card['image_id']}" />
						<!-- 要素数を取得するための一時的処理 -->
					</div>
					<p><button class="media_add" type="button">画像登録</button></p>
					<p><button class="media_delete" type="button">画像削除</button></p>
				</td>
				{foreach from=["spell", "another"] item=$spell_type}
					<td class="card_spell_wrap">
						<div class="card_spell_input_wrap">
							{foreach from=$card[$spell_type] item=$spell}
								<p class="card_spell_input">
									<input class="card_spell_value {$spell_type}" type="text" name="{$spell_type}[{$i}][]" value="{$spell}" />
									<button class="spell_delete" type="button">読み削除</button>
								</p>
							{/foreach}
						</div>
						<p><button class="card_spell_add {$spell_type}" type="button">読み追加</button></p>
					</td>
				{/foreach}
				<td>
					<button class="card_delete" type="button">カード削除</button>
				</td>
			</tr>
			{assign var="i" value=$i+1}
		{/foreach}
	</tbody>

</table>

<p id="card_add_wrap">
	<button id="card_add_button" type="button">カード追加</button>
</p>

<input type="hidden" class="card_count" name="card_count" value="{$card_count}" />
