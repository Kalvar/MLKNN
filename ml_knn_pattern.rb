class MLKNNPattern

	attr_accessor :features, :group_name, :identifier

	def initialize
		@features   = []
		@group_name = ""
		@identifier = ""
	end

	def add_features(features, group_name, identifier)
		@features   = features
		@group_name = group_name
		@identifier = identifier
	end
	
end
