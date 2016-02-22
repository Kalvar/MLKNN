## About

MLKNN is implemented by Ruby and k-Nearest Neighbors algorithm of Machine Learning that is a classification method.

## How To Get Started

#### Require
``` ruby
require './ml_knn'
```

#### Use It
``` ruby
knn = MLKNN.new

# Adding training samples at (sample_features, group_name, sample_id)
knn.add_features([1, 2, 3], "SPORT", "John")
knn.add_features([3, 4, 5], "3C", "Tim")
knn.add_features([2, 1, 1], "SPORT", "Wanie")

knn.classify([3, 4, 1], "Sam", 3){ 
	|success, assigned_group, max_counting, all_data|
	
	puts "Training completion : #{success}\n"
	puts "Sam classified to #{assigned_group}\n"
	puts "How many neighbors : #{max_counting}\n"
	puts "All classified samples : #{all_data}"
}
```

## Version

V1.1

## LICENSE

MIT.
