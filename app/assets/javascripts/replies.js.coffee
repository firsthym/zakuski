# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	$('.cse-btn-reply').click ->
		username = $(this).closest('.cse-reply-body').find('.cse-username').html()
		origin = $('#reply_body').val()
		$('#reply_body').val(origin + '@' + username + '\n')