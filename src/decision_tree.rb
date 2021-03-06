require_relative '../src/node.rb'
require_relative '../src/gini.rb'

# Uses Gini indexing to categorize a given data set
# can be created to use randomized attribute lists or the full set
class DecisionTree
  attr_accessor :root_node
  attr_accessor :gini_indexer
  attr_accessor :data

  def initialize(root_node: nil, use_random: false, data:)
    @root_node = root_node
    @data = data
    @gini_indexer = Gini.new(random_attrs: use_random)
  end

  def build_tree(set = nil)
    set ||= @data
    split = @gini_indexer.split_set(set)
    node = Node.new(split_on: split[:split_on], labels: split[:labels])
    @root_node ||= node

    # is not leaf
    if split[:info_gain] != 0.0
      node.left = build_tree(split[:left_set]) unless split[:left_set].nil?
      node.right = build_tree(split[:right_set]) unless split[:right_set].nil?
    end

    node
  end

  def categorize(set, node = @root_node)
    label = node.vote
    return label if ! label.nil? && label != '' && node.split_on.empty?

    index = node.split_on[0]
    split = node.split_on[1]

    go_right = split.instance_of?(String) || set[index].instance_of?(String) ? set[index] == split : set[index] >= split

    if go_right
      categorize(set, node.right)
    else
      categorize(set, node.left)
    end
  end

  def pretty_print(node = nil, level = 0)
    node ||= @root_node
    level += 1
    str = "Level #{level}"
    tabs = ''
    level.times do
      tabs += "\t"
    end

    if node.is_leaf?
      str += "#{tabs}Leaf: #{node.display_labels}\n"
    else
      str += "#{tabs}#{node.display_split_on}\n"
    end

    str += pretty_print(node.right, level) if node.right
    str += pretty_print(node.left, level) if node.left
    str
  end
end
