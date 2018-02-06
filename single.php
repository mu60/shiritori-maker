<?php

namespace shiritori;

get_header();
$smarty = include_smarty();
$cards = new gamepage();
$smarty->assign("cards", $cards->cards);
$smarty->display("single.tpl");
get_footer();

class gamepage {
	public $cards, $test;
	function __construct() {
		$cards = get_post_meta(get_the_ID(), "cards", true);
		$this->cards = [];
		foreach($cards as $card) {
			array_push($this->cards, new set_card($card));
		}
		$blank = [
			"spell" => [],
			"another" => [],
			"image_id" => "",
		];
		for($i = count($cards); $i < 24; ++$i) {
			array_push($this->cards, new set_card($blank));
		}
		shuffle($this->cards);
	}
}

class set_card {
	public $spell, $another, $image_id, $image_src;
	function __construct($card) {
		$this->spell = implode(",", $card["spell"]);
		$this->another = implode(",", $card["another"]);
		$this->image_id = $card["image_id"];
		if(!empty($card["image_id"])) {
			$this->image_src = wp_get_attachment_image($card["image_id"]);
		} else {
			$this->image_src = "";
		}
	}
}
