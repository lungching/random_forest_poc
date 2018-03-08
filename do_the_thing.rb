require_relative 'src/random_forest.rb'
require 'csv'

train_data = CSV.read('titanic_train.csv')

forest = RandomForest.new(num_of_trees: 100)
forest.create_forest( train_data )

test_data = CSV.read('titanic_test.csv')

matched = 0
test_data.each { |row|
	prediction = forest.winner( row )
	matched += 1 if prediction == row[-1]
#	puts "Guessed #{prediction} Actual: #{row[-1]}" if prediction != row[-1]
}

puts "Tested #{test_data.size} rows."
puts "#{matched} matched."
puts "#{matched.to_f/test_data.size.to_f * 100.0}% correct"
