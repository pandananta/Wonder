class Relationship
	attr_accessor :uid1, :uid2

	def save
		@@neo ||= Neography::Rest.new
		@@neo.execute_query(
			"
			MATCH (a:Note),(b:Note)
			WHERE a.uid = {uid1} 
			AND b.uid = {uid2}
			AND NOT(a-[:linked]->b)
			CREATE (a)-[r:linked]->(b)
			RETURN r", {
				"uid1" => uid1,
				"uid2" => uid2
			})
	end
end