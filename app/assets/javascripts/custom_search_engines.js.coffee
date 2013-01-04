# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	# initializations for widgets
	
	$('.cse-labels').tagit()
	
	# Event bind

	$('.tagit-new input').live 'click', ->
		labels = []
		$('.cse-label-name').each ->
			labels.push($(this).val()) if $(this).val() != ''
		if labels?
			$(this).closest('td').find('.cse-labels').tagit
				availableTags: labels
				showAutocompleteOnFocus: true
			
			

	$('.cse-add-item').click (e) ->
		new_row = $(this).closest('.controls').find("tbody.hidden").clone()
		count = $(this).closest('.controls').find('tbody:not(.hidden)').length
		new_row.find('.cse-input').each ->
			$(this).attr('id', $(this).attr('id').replace(/#/, count))
			$(this).attr('name', $(this).attr('name').replace(/#/, count))
		$(this).closest('.controls').find('tbody:last').after(new_row)
		new_row.find('.new-cse-labels').addClass('cse-labels').tagit()
		new_row.removeClass('hidden')
		return


	$('.cse-checkbox-manager').click ->
		check = if $(this).attr('checked') == 'checked' then true else false
		$(each).attr('checked', check) for each in $(this).closest('.controls').find('tbody:not(.hidden) .cse-checkbox-item')
		return
	# cse-checkbox-manager click end


	$('.cse-checkbox-item').live 'click', ->
		check = true
		for each in $(this).closest('.controls').find('tbody:not(.hidden) .cse-checkbox-item')
			if $(each).attr('checked') != 'checked'
				check = false
				break
		$(this).closest('.controls').find('.cse-checkbox-manager').attr('checked', check)
		return


	$('.cse-del-item').click ->
		for each in $(this).closest('.controls').find('tbody:not(.hidden) .cse-checkbox-item')
			if $(each).attr('checked') == 'checked'
				if (_destroy = $(each).siblings(':hidden')).length
					_destroy.val(true)
					$(each).closest('tbody').hide()
				else
					$(each).closest('tbody').remove()
		return


	$('.link-cse').live 'click', ->
		cseid = $(this).siblings(':hidden').val()
		$.cookie('linked_cseid', cseid, {path: '/'})
		$.cookie('active_cseid', cseid, {path: '/'})
		linked_cse_info = $(this).closest('div').siblings('.hide').html()
		$('#linked-cse-desc').html(linked_cse_info)
		$(this).closest('ul').find('.cse-selected').removeClass('cse-selected')
		$(this).closest('li.cse-link').addClass('cse-selected')
		return
	
	# document ready end
	return
