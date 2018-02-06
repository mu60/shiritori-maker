jQuery ($) ->

	$.wait = (msec) ->
		# Deferredのインスタンスを作成
		d = new ($.Deferred)
		setTimeout (->
			# 指定時間経過後にresolveしてdeferredを解決する
			d.resolve msec
			return
		), msec
		d.promise()

	$.convert_spell = (str, first = false) ->
		if first
			str = str.slice(0, 1)
		else
			# 最後の文字が伸ばし棒だった場合は、最後から2番目を取得
			temp = str.slice(-1)
			if(temp == "ー")
				str = str.slice(-2)
				str = str.slice(0, 1)
			else
				str = str.slice(-1)
		# カタカナをひらがなに変換
		str = str.replace /[ァ-ン]/g, (s) ->
			String.fromCharCode(s.charCodeAt(0) - 0x60)
		return str

	$.txt_set = (msg) ->
		window.txt_count = 0
		window.txt_message = msg.split("")
		$(".message").text ""

	$.remaining_check = ->
		select_card = []
		$(".card_touch").each (index, element) ->
			if $(this).html() != ""
				select_card.push $(this)
		match = false
		$.each select_card, (index, element) ->
			temp_name = $(this).parent().children(".card_spell").val()
			temp_name = temp_name.split(",")
			$.each temp_name, (index, element) ->
				spell = $.convert_spell(element, true)
				if spell == window.txt_now
					match = true
					return false
			if match
				return false
		return match

	window.txt_count
	window.txt_message
	window.txt_phase
	window.txt_msec
	window.txt_now
	window.timer
	window.point = 0

	$.txt_working = () ->
		window.timer = setTimeout($.txt_working, 50)
		$(".message").append window.txt_message[window.txt_count]
		window.txt_count++
		if window.txt_count == window.txt_message.length
			clearTimeout window.timer
			$.wait(window.txt_msec).done ->
				$.phase_change()
		return

	$.game_start = ->
		$.txt_set "しりとりで勝負だ！おれから行くぞ！"
		window.txt_phase = "game_start"
		window.txt_msec = 1000
		$.txt_working()

	$.game_start()

	$.phase_change = ->
		switch window.txt_phase
			when "game_start"
				$.start_card()
			when "start_card"
				$.your_turn()
			when "card_match"
				$.next_card()
			when "next_card"
				$.start_card()
			when "card_empty"
				$.game_set()

	$.start_card = ->
		name = ""
		select_card = []
		$(".card_touch").each (index, element) ->
			if $(this).html() != ""
				select_card.push $(this)
		nn = false
		match = false
		if window.point == 0
			card_rnd = 0
			while match == false
				card_rnd = Math.floor(Math.random() * select_card.length)
				name = select_card[card_rnd].parent().children(".card_spell").val()
				name = name.split(",")
				spell_rnd = Math.floor(Math.random() * name.length)
				name = name[spell_rnd]
				console.log $.convert_spell(name)
				if $.convert_spell(name) != "ん"
					match = true
			select_card[card_rnd].addClass("enemy")
		else
			while match == false
				$.each select_card, (index, element) ->
					temp_name = $(this).parent().children(".card_spell").val()
					temp_name = temp_name.split(",")
					$.each temp_name, (index, element) ->
						spell = $.convert_spell(element, true)
						if spell == window.txt_now
							if $.convert_spell(element) == "ん" && nn = false
								return true
							else
								match = true
								name = element
								return false
					if match
						$(this).addClass("enemy")
						return false
				nn = true
		window.txt_now = $.convert_spell(name)
		$.wait(1500).done ->
			$(".card_touch.enemy").parent().children("input").val ""
			$(".card_touch.enemy").html ""
			$(".card_touch.enemy").removeClass("enemy")
			if $.remaining_check()
				window.txt_phase = "start_card"
				$.txt_set "「"+name+"」だ！「"+window.txt_now+"」で始まるのはどれだ？"
				window.txt_msec = 1
			else
				window.txt_phase = "card_empty"
				$.txt_set "「"+name+"」だ！しかし「"+window.txt_now+"」で始まるものが、もう無いようだな。"
				window.txt_msec = 1500
			clearTimeout window.timer
			$.txt_working()

	$.your_turn = ->
		window.txt_phase = "your_turn"
		$(".card_touch").addClass("your_turn")

	$(document).on "click", ".card_touch", ->
		if window.txt_phase != "your_turn"
			return
		spell = $(this).parent().children(".card_spell").val()
		if spell == ""
			return
		spell = spell.split(",")
		match = false
		match_index = 0
		$.each spell, (index, element) ->
			element = element.slice(0, 1)
			element = $.convert_spell(element)
			if element == window.txt_now
				match = true
			if match
				match_index = index
				return false
		if match
			++window.point
			$(".now_point").text window.point
			window.txt_phase = "card_match"
			$(".card_touch").removeClass("your_turn")
			$(this).addClass("match")
			$.txt_set "なるほど、「"+spell[match_index]+"」か…。"
			window.txt_now = $.convert_spell(spell[match_index])
			window.txt_msec = 1500
			$.txt_working()
		else
			$.txt_set "それは違うぞ！「"+window.txt_now+"」で始まるものはどれだ？"
			window.txt_msec = 1
		clearTimeout window.timer
		$.txt_working()

	$.next_card = ->
		$(".card_touch.match").parent().children("input").val ""
		$(".card_touch.match").html ""
		$(".card_touch.match").removeClass("match")
		if window.txt_now == "ん"
			window.txt_phase = "game_set"
			$.txt_set "バカめ！「ん」で終わるものを選んだな！お前の負けだ！"
			window.txt_msec = 1500
			$.txt_working()
			return false
		if $.remaining_check()
			window.txt_phase = "next_card"
			$.txt_set "「"+window.txt_now+"」で始まるものだな。それならば…。"
			window.txt_msec = 1000
		else
			window.txt_phase = "card_empty"
			$.txt_set "ん？「"+window.txt_now+"」で始まるものが、もう無いぞ。"
			window.txt_msec = 1500
		clearTimeout window.timer
		$.txt_working()

	$.game_set = ->
		window.txt_phase = "game_set"
		if window.point < Number $(".clear_point").text()
			$.txt_set "残念だったな。ポイントが足りないぞ。お前の負けだ！"
		else
			$.txt_set "なかなかやるじゃないか。お前の勝ちだ。ここを通してやろう。"
		window.txt_msec = 1500
		$.txt_working()
