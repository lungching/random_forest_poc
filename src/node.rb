class Node
	attr_accessor :right     # node where attr value is == or >=
	attr_accessor :left      # node where attr vlaue is != or <
	attr_accessor :split_on  # array in the form [<index>, <value to check>]
	attr_accessor :labels    # array of array in the form [[<label1, <confidence>], [<label2>, <confidence>] ... ]

	def initialize(right = nil, left = nil, split_on = [], labels = [])
		@right    = right
		@left     = left
		@split_on = split_on
		@labels   = labels
	end

	def is_leaf?
		return @right.nil? && @left.nil?
	end

	def vote
	end

	def display_split_on
		index = @split_on[0]
		split = @split_on[1]
		split_str = split.instance_of?(String) ? split : ">= #{split}"
		return "Index #{index} : #{split_str}"
	end

	def display_labels
		return unless @labels && @labels.count

		labels_str = ''
		@labels.each do | label, confidence |
			labels_str += "#{label}: #{confidence}  "
		end

		return labels_str
	end

	def vote
	end
end