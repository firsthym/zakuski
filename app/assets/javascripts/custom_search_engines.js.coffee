# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	# initializations for widgets
	
	labels = $('.cse-labels').tagit()
	
	# Event bind

	$('.tagit-new').live 'click', ->
		labels.each ->
			$(this).createTag('test')
			

	$('.cse-add-item').click (e) ->
		last_row = $(this).closest('.controls').find("tbody:last")
		new_row = last_row.clone()
		count = $(this).closest('.controls').find('tbody').length
		new_row.find('.cse-input').each ->
			$(this).val('')
			$(this).attr('id', $(this).attr('id').replace(/\d/, count))
			$(this).attr('name', $(this).attr('name').replace(/\d/, count))
		new_row.find('td:first').html('<input type="checkbox" class="cse-checkbox-item"/>')
		new_row.find('.cse-labels')
		last_row.after(new_row)
		return


	$('.cse-checkbox-manager').click ->
		check = if $(this).attr('checked') == 'checked' then true else false
		$(each).attr('checked', check) for each in $(this).closest('.controls').find('.cse-checkbox-item')
		return
	# cse-checkbox-manager click end


	$('.cse-checkbox-item').live 'click', ->
		check = true
		for each in $(this).closest('.controls').find('.cse-checkbox-item')
			if $(each).attr('checked') != 'checked'
				check = false
				break
		$(this).closest('.controls').find('.cse-checkbox-manager').attr('checked', check)
		return


	$('.cse-del-item').click ->
		for each in $(this).closest('.controls').find('.cse-checkbox-item')
			if $(each).attr('checked') == 'checked'
				if (_destroy = $(each).siblings(':hidden')).length
					_destroy.val(true)
					$(each).closest('tbody').hide()
				else
					$(each).closest('tbody').remove()
		# $('#cse-checkbox-manager').attr('checked', false) if $('.cse-checkbox-annotation').length == 0
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
