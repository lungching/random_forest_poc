require "test/unit"
require_relative "../src/decision_tree.rb"


class TestTree < Test::Unit::TestCase
	def test_tree_build()
		test_data = [
			['green', 3, 'apple'],
			['yellow', 3, 'apple'],
			['red', 1, 'grape'],
			['red', 1, 'grape'],
			['yellow', 3, 'lemon'],
		]
		dTree = DecisionTree.new
		node = dTree.build_tree( test_data )

		dTree.pretty_print( node )
		assert_equal([1,3], node.split_on, "root node split")
		assert_equal("", node.left.split_on, "root's left node split is blank")
		assert_equal([["grape", 1.0]], node.left.labels, "root's left node label")
		assert_equal([0, "yellow"], node.right.split_on, "root's right node split")
		assert_equal("", node.right.left.split_on, "root's right's left node split is blank")
		assert_equal([["apple", 1.0]], node.right.left.labels, "root's right's left node label")
		assert_equal("", node.right.right.split_on, "root's right's right node split is blank")
		assert_equal([["apple", 0.5], ["lemon", 0.5]], node.right.right.labels, "root's right's right node label")
	end
end

