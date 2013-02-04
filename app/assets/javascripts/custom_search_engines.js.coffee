# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	# initializations for widgets
	
	$('.cse-labels').tagit
		showAutocompleteOnFocus: true
	$('.cse-tags').select2()
	
	# Event bind

	$('.tagit-new input').live 'click', ->
		labels = []
		$('.cse-label-name:visible').each ->
			labels.push($(this).val().trim()) if $(this).val() != ''
		if labels?
			$(this).closest('td').find('.cse-labels').tagit
				availableTags: labels
				showAutocompleteOnFocus: true
			
			

	$('.cse-add-item').click (e) ->
		controls = $(this).closest('.controls')
		new_row = controls.find("tbody.hidden").clone()
		count = controls.find('tbody:not(.hidden)').length
		new_row.find('.cse-input').each ->
			$(this).attr('id', $(this).attr('id').replace(/#/, count))
			$(this).attr('name', $(this).attr('name').replace(/#/, count))
		controls.find('table').append(new_row)
		new_row.find('.new-cse-labels').addClass('cse-labels').tagit()
		new_row.removeClass('hidden')
		new_row.find('input:text').first().focus()
		return


	$('.cse-checkbox-manager').click ->
		check = if $(this).attr('checked') == 'checked' then true else false
		$(each).attr('checked', check) for each in $(this).closest('.controls').find('tbody:visible .cse-checkbox-item')
		return
	# cse-checkbox-manager click end


	$('.cse-checkbox-item').live 'click', ->
		check = true
		for each in $(this).closest('.controls').find('tbody:visible .cse-checkbox-item')
			if $(each).attr('checked') != 'checked'
				check = false
				break
		$(this).closest('.controls').find('.cse-checkbox-manager').attr('checked', check)
		return


	$('.cse-del-item').click ->
		controls = $(this).closest('.controls')
		for each in controls.find('tbody:visible .cse-checkbox-item')
			if $(each).attr('checked') == 'checked'
				if (_destroy = $(each).siblings(':hidden')).length
					_destroy.val(true)
					$(each).closest('tbody').hide()
				else
					$(each).closest('tbody').remove()
		if controls.find('tbody:visible').length == 0
			controls.find('.cse-checkbox-manager').attr('checked', false)
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
	
	
	$('.cse-theme-box .thumbnail').click ->
		$('.cse-theme-box .thumbnail').removeClass('cse-theme-choose')
		$(this).addClass('cse-theme-choose')
		theme = $(this).find('.cse-theme-name').val()
		$(this).closest('.control-group').find('.cse-theme-selected').val(theme)
	
	# document ready end
	return
