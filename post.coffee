jQuery ($) ->

	$(document).on "click", "#card_add_button", ->
		card_org = $(".card_wrap[data-number='0']").clone()
		number = $(".card_wrap").length
		spell_types = ["spell", "another"]
		$.each spell_types, (index, spell_type) ->
			spell_no = spell_type + "[" + number + "][]"
			card_org.find(".card_spell_value." + spell_type).attr "name", spell_no
		card_org.find(".image_id").attr "name", "image_id[" + number + "]"
		card_org.attr("data-number", number)
		$("#shiritori_table_cards").append card_org
		card_org.addClass("hide")
		$.wait(1)
			.done ->
				card_org.removeClass("hide")

	$(document).on "click", ".card_spell_add", ->
		spell_org = $(".card_spell_input").eq(0).clone()
		if $(this).hasClass("spell")
			spell_type = "spell"
		else
			spell_type = "another"
		number = $(".card_wrap").index $(this).closest(".card_wrap")
		number = spell_type + "[" + number + "][]"
		spell_org.find(".card_spell_value").attr "name", number
		spell_org.addClass("hide")
		$(this).closest(".card_spell_wrap").find(".card_spell_input_wrap").append spell_org
		$.wait(1)
			.done ->
				spell_org.removeClass("hide")

	$(document).on "click", ".card_delete", ->
		card_delete = $(this).closest(".card_wrap")
		card_delete.addClass("hide")
		$.wait(300)
			.done ->
				card_delete.remove()
				$(".card_wrap").each (index) ->
					$(this).attr("data-number", index)
					###
					spell_types = ["spell", "another"]
					$.each spell_types, (i, spell_type) ->
						console.log spell_type
						card.find(".card_spell_value."+spell_type).attr("name", spell_type+"["+index+"][]")
					###
					$(this).find(".card_spell_value.spell").attr("name", "spell["+index+"][]")
					$(this).find(".card_spell_value.another").attr("name", "another["+index+"][]")
					$(this).find(".image_id").attr "name", "image_id[" + index + "]"

	$(document).on "click", ".spell_delete", ->
		if $(this).closest(".card_spell_input_wrap").find(".card_spell_input").length > 1
			spell_delete = $(this).closest(".card_spell_input")
			spell_delete.addClass("hide")
			$.wait(300)
				.done ->
					spell_delete.remove()
		else
			$(this).siblings(".card_spell_value").val("")

	$("#post").submit ->
		error = false
		$(".card_spell_value.spell").each (i) ->
			if $(this).val() == "" && i > 0
				alert "読みは入力必須です。"
				error = true
				return false
		if error == true
			return false
		$(".card_wrap[data-number='0']").addClass("show")
		$(".card_wrap[data-number='0']").remove()
		$(".card_count").val $(".card_wrap").length

	$.wait = (msec) ->
		# Deferredのインスタンスを作成
		d = new ($.Deferred)
		setTimeout (->
			# 指定時間経過後にresolveしてdeferredを解決する
			d.resolve msec
			return
		), msec
		d.promise()

	$(document).on "click", ".media_add", (e) ->
		custom_uploader = undefined
		select_media = $(this).closest(".card_media_wrap")
		e.preventDefault()
		if custom_uploader
			custom_uploader.open()
			return
		custom_uploader = wp.media
			title: "Choose Image"
			library: type: "image"
			button: text: "Choose Image"
			multiple: false
		custom_uploader.on "select", ->
			images = custom_uploader.state().get("selection")
			images.each (file) ->
				select_media.find(".image_id").val ""
				select_media.find(".put_image").empty()
				select_media.find(".image_id").val file.id
				select_media.find(".put_image").append "<img src='" + file.attributes.sizes.thumbnail.url + "' />"
		custom_uploader.open()

	$(".media_delete").click ->
		select_media = $(this).closest(".card_media_wrap")
		select_media.find(".image_id").val ""
		select_media.find(".put_image").empty()
