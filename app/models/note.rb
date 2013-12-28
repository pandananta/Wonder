class Note
	attr_accessor :uid, :prompt, :body
	

	def save
		@@neo ||= Neography::Rest.new
		nnode = nil
		if uid
			@@neo.execute_query(
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
			@@neo.execute_query(
				"
				CREATE (n:Note {uid : {uid}, prompt : {prompt}, body : {body}})
				RETURN n
				", {
					"uid" => uid,
					"prompt" => prompt,
					"body" => body
				})
		end
		stopwords = ["a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount", "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as", "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "i", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"]
		words = body.downcase.gsub(/[^a-z\s]/, '')
		words = words.split.delete_if{|x| stopwords.include?(x)}.join(' ')
		words = words.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
		words.each do |cur|
			w = Word.new
			w.str = cur
			w.save
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
end