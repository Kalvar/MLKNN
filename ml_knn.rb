# Dynamic loading and matching the PATH of files
$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'ml_distance_function'
require 'ml_distance_kernel'
require 'ml_knn_pattern'

class MLKNN

	# Const
	IDENTIFIER_KEY = "identifier"
	DISTANCE_KEY   = "distance"
	UNKNOWN_GROUP  = "unknown_group"

	attr_accessor :distance_function, :kernel_method, :training_sets, :completion_block

	def initialize
		@distance_function = MLDistanceFunction.new
		@kernel_method     = MLDistanceKernel::ECULIDEAN
		@training_sets     = {}
	end
 
	def add_features(features, group_name, identifier)
		add_classified_sets(features, group_name, identifier)
	end

	def classify(pattern_features, identifier, k_neighbor, &block)
		neighbor_distances 		= []
		@training_sets.each{ |classified_id, knn_pattern|
			distance 		    = calculate_distance(knn_pattern.features, pattern_features)
			neighbor_distances << {IDENTIFIER_KEY => classified_id, DISTANCE_KEY => distance}
		}

		# DESC distance unit, that used b <=> a
		sorted_distances       = neighbor_distances.sort{ |a, b| b[DISTANCE_KEY] <=> a[DISTANCE_KEY] }
		# Counting the nearest neighbors 
		sum_group_distances    = {}
		counting_neighbors     = {}
		max_counting	       = 0
		assigned_group		   = UNKNOWN_GROUP
		chose_k 			   = 0
		success				   = false
		sorted_distances.each_with_index{ |neighbors, index| 
			pattern_group      = @training_sets[neighbors[IDENTIFIER_KEY]].group_name
			counting 	       = counting_neighbors[pattern_group].to_i + 1
			if counting > max_counting
				max_counting   = counting
				# Assign to its own group
				assigned_group = pattern_group
			end
			counting_neighbors[pattern_group] = counting

			# Sum the distance of neighbor of pattern to support assign to right group since it has same neighbors of nearest
			neighbor_distance  = neighbors[DISTANCE_KEY]
			group_distance     = sum_group_distances[pattern_group].to_f
			group_distance 	  += neighbor_distance
			sum_group_distances[pattern_group] = group_distance

			chose_k += 1
			if chose_k >= k_neighbor
				own_distance = sum_group_distances[assigned_group].to_f
				counting_neighbors.each{ |group_name, counting| 
					if (group_name != assigned_group) && (counting_neighbors[group_name] == max_counting)
						other_distance = sum_group_distances[group_name].to_f
						if other_distance < own_distance
							own_distance   = other_distance
							assigned_group = group_name
						end
					end
				}
				break;
			end
		}

		if max_counting > 0
			success = true
			add_classified_sets(pattern_features, assigned_group, identifier)
		end

		block.call(success, assigned_group, max_counting, @training_sets.values) if block_given?
	end

	def classify_with_auto_k(pattern_features, identifier, &block)
		classify(pattern_features, identifier, choose_k(), block)
	end

	# sqrt(n) to simply choose K neighbor number
	def choose_k
		Math.sqrt(@training_sets.count).ceil
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

	def add_classified_sets(features, group_name, identifier)
		@training_sets[identifier] = MLKNNPattern.new(features, group_name, identifier)
	end
end