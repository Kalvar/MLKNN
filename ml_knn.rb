# Dynamic loading and matching the PATH of files
$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'ml_distance_function'
require 'ml_distance_kernel'

class MLKNN

	attr_accessor :distance_function, :kernel_method, :all_data, :training_sets, :training_groups, :completion_block

	def initialize
		@distance_function = MLDistanceFunction.new
		@kernel_method     = MLDistanceKernel::ECULIDEAN
		@all_data 	       = {}
		@training_sets     = {}
		@training_groups   = {}
	end
 
	def add_features(features, group, identifier)
		@training_sets[identifier] 	 = features
		@training_groups[identifier] = group
		@all_data[identifier]		 = [group, identifier, features]
	end

	def classify(pattern_features, identifier, k_neighbor, &block)
		
		@training_sets.each{ |classified_id, classified_features|
			distance = calculate_distance(classified_features, pattern_features)
			puts "here #{distance}"
		}

		block.call(9) if block_given?

	end

	private
	def calculate_distance(x1, x2)
		case @kernel_method
			when MLDistanceKernel::COSINE_SIMILARITY
				@distance_function.cosine_similarity(x1, x2)
			when MLDistanceKernel::ECULIDEAN
				@distance_function.eculidean(x1, x2)
			when MLDistanceKernel::RBF
				@distance_function.rbf(x1, x2, 2.0)
			else
				0.0
		end
	end

	public
	def test

		add_features([1, 2, 3], "SPORT", "John")
		add_features([3, 4, 5], "3C", "Tim")
		add_features([2, 1, 1], "SPORT", "Wanie")
		
		classify([3, 4, 1], "Enoch", 2){
			puts "done #{value}" 
		}

		distance = MLDistanceFunction.new
		a = distance.cosine_similarity([1, 2, 3], [4, 5, 6])
		puts "here #{a}"

		b = distance.eculidean([1, 2], [4, 5])
		puts "here #{b}"

		c = distance.rbf([1, 2, 3], [4, 5, 6], 2.0)
		puts "here #{c}"

	end


end