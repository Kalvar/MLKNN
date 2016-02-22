require './ml_knn'

knn = MLKNN.new

# Adding training samples at (sample_features, group_name, sample_id)
knn.add_features([1, 2, 3], "SPORT", "John")
knn.add_features([3, 4, 5], "3C", "Tim")
knn.add_features([2, 1, 1], "SPORT", "Wanie")

# Start in training, for this sample we wanna classify Sam this guy and input his features, his name (ID) and how many neighbors.
# To use for-loop classifies more patterns once time. 
knn.classify([3, 4, 1], "Sam", knn.choose_k){ 
	|success, assigned_group, max_counting, all_patterns|

	puts "Training completion : #{success}\n"
	puts "Sam classified to #{assigned_group}\n"
	puts "How many neighbors : #{max_counting}\n"
	puts "All classified samples : #{all_patterns}\n\n"

	all_patterns.each{ |pattern| puts "#{pattern.identifier} classified to #{pattern.group_name}" }
}