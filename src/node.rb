class Node
	attr_accessor :right
	attr_accessor :left
	attr_accessor :split_on
	attr_accessor :label

	def initialize(right = nil, left = nil, split_on = '', label = '')
		@right    = right
		@left     = left
		@split_on = split_on
		@label    = label
	end

	def is_leaf?
		return :right.nil? && :left.nil?
	end
end
