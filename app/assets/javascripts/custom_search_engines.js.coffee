# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	current_annotation_count = $('.cse-annotations').find('tbody').length
	# cse-add-annotation click begin
	$('#cse-add-annotation').click (e) ->
		new_row = $(this).parent('.cse-annotations').find("tbody:first").clone(); 
		new_text = new_row.find(':text')
		new_text.val('')
		new_text.attr('id', new_text.attr('id').replace(/\d/, current_annotation_count))
		new_text.attr('name', new_text.attr('name').replace(/\d/, current_annotation_count))
		
		new_select = new_row.find('select')
		new_select.attr('id', new_select.attr('id').replace(/\d/, current_annotation_count))
		new_select.attr('name', new_select.attr('name').replace(/\d/, current_annotation_count))

		new_row.find('td:first').append('<input type="checkbox" class="cse-checkbox-annotation"/>')
		$(this).parent('.cse-annotations').find("tbody:last").after(new_row)
		current_annotation_count++
		return
	# cse-add-annotation click end

	# cse-checkbox-manager click begin
	$('#cse-checkbox-manager').click ->
		check = if $(this).attr('checked') == 'checked' then true else false
		$(each).attr('checked', check) for each in $('.cse-checkbox-annotation')
		return
	# cse-checkbox-manager click end

	# cse-checkbox-annotation click begin
	$('.cse-checkbox-annotation').live 'click', ->
		check = true
		for each in $('.cse-checkbox-annotation')
			if $(each).attr('checked') != 'checked'
				check = false
				break
		$('#cse-checkbox-manager').attr('checked', check)
		return
	# cse-checkbox-annotation click end

	# cse-del-annotation click begin
	$('#cse-del-annotation').click ->
		for each in $('.cse-checkbox-annotation')
			if $(each).attr('checked') == 'checked'
				if (_destroy = $(each).siblings(':hidden')).length
					_destroy.val(true)
					$(each).closest('tbody').hide()
				else
					$(each).closest('tbody').remove()
		# $('#cse-checkbox-manager').attr('checked', false) if $('.cse-checkbox-annotation').length == 0
		return
	# cse-del-annotation click end

	# cse-create-submit begin

	# cse-create-submit end

	$('.link-cse').click ->
		cseid = $(this).siblings(':hidden').val()
		$.cookie('linked_cseid', cseid)
		linked_cse_info = $(this).closest('div').siblings('.hide').html()
		$('#linked-cse-desc').html(linked_cse_info)
		$(this).closest('ul').find('.cse-selected').removeClass('cse-selected')
		$(this).closest('li.cse-link').addClass('cse-selected')
		return
	
	# document ready end
	return
