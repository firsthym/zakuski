class RegistrationsController < Devise::RegistrationsController
	before_filter :init_link, only: [:new, :create]
	private
		def init_link
			@hash_tag = Hash.new
      			@hash_node = Hash.new
	      		Tag.all.group_by { |t| t.name }.collect { |k,v| @hash_tag[k]= v[0]}
      			Node.all.group_by { |n| n.title }.collect { |k,v| @hash_node[k]= v[0]}	
		end
end
