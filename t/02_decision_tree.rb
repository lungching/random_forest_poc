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

		#dTree.pretty_print( node )
		assert_equal("Index 1 is >= 3", node.split_on, "root node split")
		assert_equal("grape", node.left.split_on, "root's left node split")
		assert_equal("Index 0 is yellow", node.right.split_on, "root's right node split")
		assert_equal("apple", node.right.left.split_on, "root's right's left node split")
		assert_equal("apple, lemon", node.right.right.split_on, "root's right's right node split")
	end
end

