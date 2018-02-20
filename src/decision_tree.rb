require_relative "../src/node.rb"
require_relative "../src/gini.rb"
include Gini

class DecisionTree
	attr_accessor :root_node

	def initialize( root_node = nil)
		@root_node = root_node
	end

	def build_tree(set)
		split = split_set(set)
		node = Node.new(nil, nil, split[:split_on], split[:label_list])

		# is leaf
		if split[:info_gain] != 0
			node.left = build_tree(split[:left_set])
			node.right = build_tree(split[:right_set])
		end
		
		return node
	end

	def pretty_print(node, level = 0)
		level += 1
		puts "Level #{level}"
		tabs = ''
		level.times do
			tabs += "\t"
		end
		puts "#{tabs}#{node.split_on}"
		
		if node.left
			pretty_print( node.left, level)
		end

		if node.right
			pretty_print( node.right, level)
		end

		return
	end
end
