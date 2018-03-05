require_relative "../src/node.rb"
require_relative "../src/gini.rb"

class DecisionTree
	attr_accessor :root_node
	attr_accessor :gini_indexer
	attr_accessor :data

	def initialize( root_node: nil, use_random: false, data: )
		@root_node = root_node
		@data = data
		@gini_indexer = Gini.new( random_attrs: use_random )
	end

	def build_tree(set = nil)
		set = @data unless set
		split = @gini_indexer.split_set( set )
		node = Node.new(split_on: split[:split_on], labels: split[:labels])
		@root_node = node unless @root_node

		# is not leaf
		if split[:info_gain] != 0
			node.left = build_tree(split[:left_set])
			node.right = build_tree(split[:right_set])
		end
		
		node
	end

	def pretty_print(node = nil, level = 0)
		node = @root_node unless node
		level += 1
		puts "Level #{level}"
		tabs = ''
		level.times do
			tabs += "\t"
		end

		if node.is_leaf?
			puts "#{tabs}Leaf: #{node.display_labels}"
		else
			puts "#{tabs}#{node.display_split_on}"
		end

		if node.left
			pretty_print( node.left, level)
		end

		if node.right
			pretty_print( node.right, level)
		end
	end
end
