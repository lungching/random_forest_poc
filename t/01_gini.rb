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
			:split_on => "Index 0 is red",
			:right_set => [["red", 1, "grape"], ["red", 1, "grape"]],
			:left_set => [["green", 3, "apple"], ["yellow", 3, "apple"], ["yellow", 3, "lemon"]],
			:info_gain => 0.37333333333333324,
		}, ginis, "Created ginis structure")
	end
end
