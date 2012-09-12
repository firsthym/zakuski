# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	current_row_number = 1
	$('#cse-add-annotation').click (e) ->
		last_row = $(this).parent('.cse-annotations').find("tbody:last") 
		new_row = last_row.clone()
		new_text = new_row.find(':text')
		new_text.val('')
		new_text.attr('id', new_text.attr('id').replace(/\d/, current_row_number))
		new_text.attr('name', new_text.attr('name').replace(/\d/, current_row_number))
		
		new_select = new_row.find('select')
		new_select.attr('id', new_select.attr('id').replace(/\d/, current_row_number))
		new_select.attr('name', new_select.attr('name').replace(/\d/, current_row_number))

		new_checkbox = new_row.find('input:checkbox')
		alert(new_checkbox.length)
		new_checkbox.attr('checked', false)
		last_row.after(new_row)
		current_row_number++

	$('#cse-checkbox-manager').click ->
		check = if $(this).attr('checked') == 'checked' then true else false
		$(each).attr('checked', check) for each in $('.cse-checkbox-annotation')

	$('.cse-checkbox-annotation').live 'click', ->
		check = true
		for each in $('.cse-checkbox-annotation')
			if $(each).attr('checked') != 'checked'
				check = false
				break
		$('#cse-checkbox-manager').attr('checked', check)
