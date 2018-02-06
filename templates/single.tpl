<h1>{get_the_title()}</h1>

<p>{nl2br(esc_html(get_post_meta(get_the_ID(), "description", true)))}</p>

<p class="message">
	<span></span>
</p>

<p class="point">
	現在のポイント:<span class="now_point">0</span> / 目標ポイント:<span class="clear_point">{get_post_meta(get_the_ID(), "clear_point" ,true)}</span>
</p>

<div class="cards">
	{foreach from=$cards item=$card}
		<p class="card">
			<span class="card_touch">{$card->image_src}</span>
			<input class="card_spell" type="hidden" name="spell" value="{$card->spell}" />
			<input class="card_another" type="hidden" name="another" value="{$card->another}" />
		</p>
	{/foreach}
</div>
