<% unless @more_consumers.nil? %>
(function(){
	$(document).ready(function(){
			var href = $('#more_consumers').attr('href');
			<% if @more == 10 %>
				var new_href = href + "/<%= @more %>";
			<% else %>
				var new_href = href.substring(0, href.lastIndexOf('/')) + "/<%= @more %>";
			<% end %>
			$('#more_consumers').attr('href', new_href);
			<% @more_consumers.each do |consumer| %>
				$('.cse-consumer').last().after('<%= render partial: "consumer", locals: {consumer: consumer} %>')
			<% end %>
	});
}).call(this);
<% end %>