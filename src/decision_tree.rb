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
		if split[:info_gain] != 0.0
			node.left = build_tree(split[:left_set]) unless split[:left_set].nil?
			node.right = build_tree(split[:right_set]) unless split[:right_set].nil?
		end
		
		node
	end

	def categorize( set, node = @root_node )
		label = node.vote
		return label if label

		index = node.split_on[0]
		split = node.split_on[1]

    go_right = true
		go_right = split.instance_of?(String) || set[index].instance_of?(String) ? set[index] == split : set[index] >= split

		if go_right
			categorize(set, node.right)
		else
			categorize(set, node.left)
		end
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
