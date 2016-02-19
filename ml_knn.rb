# Dynamic loading and matching the PATH of files
$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'ml_distance_function'
require 'ml_distance_kernel'

class MLKNN

	attr_accessor :all_data, :training_sets, :training_groups, :kernel_method, :completion_block

	def initialize
		@distance  	     = MLDistanceFunction.new
		@kernel_method   = MLDistanceKernel::ECULIDEAN
		@all_data 	     = {}
		@training_sets   = {}
		@training_groups = {}
	end
 
	def add_features(features, group, identifier)
		@training_sets[identifier] 	 = features
		@training_groups[identifier] = group
		@all_data[identifier]		 = [group, identifier, features]
	end

	def classify(features, identifier, k_neighbor, &block)

	end

	def classify(features, identifier, &block)

	end

	def test

		add_features([1, 2, 3], "SPORT", "John")

		distance = MLDistanceFunction.new
		a = distance.cosine_similarity([1, 2, 3], [4, 5, 6])
		puts "here #{a}"

		b = distance.eculidean([1, 2], [4, 5])
		puts "here #{b}"

		c = distance.rbf([1, 2, 3], [4, 5, 6], 2.0)
		puts "here #{c}"

	end

end