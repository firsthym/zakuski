
class StaticPagesController < ApplicationController

	def about
		render "static_pages/#{I18n.locale}/about"
	end

	def help
		@hash_tag = Hash.new
		@hash_node = Hash.new
		Tag.all.group_by { |t| t.keyname }.collect { |k,v| @hash_tag[k]= v[0]}
		Node.all.group_by { |n| n.keyname }.collect { |k,v| @hash_node[k]= v[0]}
		render "static_pages/#{I18n.locale}/help"
	end

	def agreement
	end
end
