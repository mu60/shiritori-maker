<?php

namespace shiritori;

get_header();
$smarty = include_smarty();
$smarty->display("index.tpl");
get_footer();

function index_new_game_list() {
	$args = [
		"post_type" => "shiritori",
		"posts_per_page" => get_option("posts_per_page"),
	];
	return get_posts($args);
}
