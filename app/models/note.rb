class Note
	attr_accessor :uid, :prompt, :body

	def save
		nnode = nil
		if uid
			nnode = @@neo.execute_query(
				"
				MATCH (n:Note)
				WHERE n.uid = {uid}
				SET n.prompt = {prompt}
				SET n.body = {body}
				RETURN n
				", {
					"uid" => uid,
					"prompt" => prompt,
					"body" => body
				})
		else
			self.uid = SecureRandom.hex(5)
			nnode = @@neo.execute_query(
				"
				CREATE (n:Note {uid : {uid}, prompt : {prompt}, body : {body}})
				RETURN n
				", {
					"uid" => uid,
					"prompt" => prompt,
					"body" => body
				})
		end
		words = body.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
		words.each do |cur|
			w = Word.new
			w.str = cur
			wnode = w.save
			@@neo.execute_query(
				"
				MATCH (a:Note),(b:Word)
				WHERE a.uid = {uid} 
				AND b.str = {str}
				CREATE (a)-[r:contains]->(b)
				RETURN r", {
					"uid" => uid,
					"str" => cur
				})
			@@neo.execute_query(
				"
				MATCH (a:Note),(b:Word)
				WHERE a.uid = {uid} 
				AND b.str = {str}
				CREATE (b)-[r:comprises]->(a)
				RETURN r", {
					"uid" => uid,
					"str" => cur
			})
		end
	end

	def suggest
		# 122ba7f3f8
		puts "hello"
		puts uid
		@@neo.execute_query(
			"
			START n = node(*) 
			WHERE n.uid = {uid}
			MATCH n-[:contains]->friend-[:comprises]->friend_of_friend  
			RETURN collect(friend.str), friend_of_friend.body
			", {
				"uid" => uid
			})
	end
end