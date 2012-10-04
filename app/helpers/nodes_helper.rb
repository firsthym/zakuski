module NodesHelper
	def current_node(cse)
		Node.find(params[:node_id])
	end
end
