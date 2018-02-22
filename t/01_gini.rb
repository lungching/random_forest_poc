require_relative "../src/gini.rb"
require 'pry'
include Gini
require "test/unit"

class TestGini < Test::Unit::TestCase
	def test_gini_calc()
		test_data = [
			['green', 3, 'apple'],
			['yellow', 3, 'apple'],
			['red', 1, 'grape'],
			['red', 1, 'grape'],
			['yellow', 3, 'lemon'],
		]
		ginis = split_set( test_data )
		assert_equal({
			:split_on => [1, 3],
			:left_set => [["red", 1, "grape"], ["red", 1, "grape"]],
			:right_set => [["green", 3, "apple"], ["yellow", 3, "apple"], ["yellow", 3, "lemon"]],
			:info_gain => 0.37333333333333324,
		}, ginis, "Created ginis structure")
	end
	
	def test_leaf_label()
		test_data = [
			['red', 1, 'grape'],
			['red', 1, 'grape'],
		]
		ginis = split_set( test_data )
		assert_equal({
			:split_on => "",
			:info_gain => 0.0,
			:right_set => [['red',1,'grape'], ['red',1,'grape']],
			:left_set => [],
			:labels => [["grape", 1.0]]
		}, ginis, "split label is only the list of unique labels")
	end
end
