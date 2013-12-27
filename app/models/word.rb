class Word
	attr_accessor :str

	def save
		@@neo ||= Neography::Rest.new
		node = @@neo.execute_query(
			"
			MATCH (w:Word)
			WHERE w.str = {str}
			RETURN w
			", {
				"str" => str
			})
		if(node["data"].empty?)
			node = @@neo.execute_query(
				"
				CREATE (w:Word {str : {str}})
				RETURN w
				", {
					"str" => str,
				})
		end
		return node
	end
end