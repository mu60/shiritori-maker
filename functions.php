<?php

namespace shiritori;

add_theme_support("post-thumbnails");
add_theme_support("title-tag");

function include_smarty() {
	require_once("smarty/Smarty.class.php");
	$smarty = new \Smarty();
	$smarty->template_dir = get_template_directory() . "/templates";
	$smarty->compile_dir = get_template_directory() . "/templates_c";
	return $smarty;
}

add_action("wp_enqueue_scripts", function() {
	wp_enqueue_style("normalize", "https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.css");
	wp_enqueue_style("style", get_template_directory_uri() . "/style.css");
	wp_enqueue_script("jquery");
	wp_enqueue_script("script", get_template_directory_uri() . "/assets/script.js");
});

add_filter("manage_shiritori_posts_columns", function ($columns) {
	$columns["thumbnail"] = __("Thumbnail");
	return $columns;
});

add_action("manage_shiritori_posts_custom_column", function ($column_name, $post_id) {
	if("thumbnail" == $column_name) {
		$thum = get_the_post_thumbnail($post_id, "thumb100");
	}
	if(isset($thum) && $thum) {
		echo $thum;
    }
}, 10, 2);

add_action("admin_enqueue_scripts", function () {
	global $pagenow;
	if(!is_admin() || get_post_type() != "shiritori") {
		return false;
	}
	switch($pagenow) {
		case "edit.php":
			wp_enqueue_style("edit_shiritori", get_template_directory_uri() . "/assets/edit.css");
		break;
		case "post.php":
		case "post-new.php":
			wp_enqueue_style("post_shiritori", get_template_directory_uri() . "/assets/post.css");
			wp_enqueue_script("post_shiritori", get_template_directory_uri() . "/assets/post.js");
		break;
	}
});

add_action("init", function () {
	$exampleSupports = [
		"title",
		//"editor",
		"thumbnail",
		"revisions"
	];
	register_post_type(
		"shiritori",
		[
			"label" => "しりとり",
			"public" => true,
			"has_archive" => true,
			"menu_position" => 5,
			"supports" => $exampleSupports
		]
	);
});

add_action("admin_menu", function () {
	$meta = [
		"summary" => "基本設定",
		"cards" => "カード",
	];
	foreach($meta as $key => $value) {
		add_meta_box($key, $value, function ($output, $key) {
			$smarty = include_smarty();
			$key = $key["args"];
			if($key == "cards") {
				$blank_card = [
					0 => [
						"spell" => [
							0 => "",
						],
						"another" => [
							0 => "",
						],
						"image_id" => "",
					],
				];
				$cards = $blank_card;
				$save_cards = get_post_meta(get_the_ID(), "cards", true);
				if(!empty($save_cards)) {
					$cards = array_merge($cards, $save_cards);
				} else {
					$cards = array_merge($cards, $blank_card);
				}
				//var_dump($cards);
				$smarty->assign("cards", $cards);
				$smarty->assign("card_count", count($cards));
			}
			$smarty->display("custom_field/" . $key . ".tpl");
		}, "shiritori", "", "", $key);
	}
});

add_action("save_post", function ($post_id) {
	if(get_post_type() != "shiritori") {
		return false;
	}
	$customfields = [
		"description",
		"use_cards",
		"clear_point",
	];
	foreach($customfields as $customfield) {
		$value = filter_input(INPUT_POST, $customfield);
		if(!empty($value)){
			update_post_meta($post_id, $customfield, $value);
		} else {
			delete_post_meta($post_id, $customfield);
		}
	}
	$card_count = filter_input(INPUT_POST, "card_count");
	$cards = [];
	$keys = [
		"spell",
		"another",
		"image_id",
	];
	for($i = 1; $i <= $card_count; ++$i) {
		$cards[$i] = [];
		foreach($keys as $key) {
			$value = filter_input(INPUT_POST, $key, FILTER_DEFAULT, FILTER_REQUIRE_ARRAY);
			$args = [
				$key => $value[$i],
			];
			$cards[$i] = array_merge($cards[$i], $args);
		}
	}
	update_post_meta($post_id, "cards", $cards);
});
