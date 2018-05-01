require_relative '../src/decision_tree.rb'

# uses a given number of decision trees created with a random subset of attributes to vote on
# the label of a given set of data
class RandomForest
  attr_accessor :num_of_trees     # how many trees to make
  attr_accessor :forest           # collection of decision trees

  def initialize(num_of_trees: 10)
    @num_of_trees = num_of_trees
    @forest = []
  end

  def create_forest(set)
    @num_of_trees.times do
      dt = DecisionTree.new(data: set, use_random: true)
      dt.build_tree
      @forest.push(dt)
    end
  end

  def winner(set)
    votes = Hash.new(0)
    leader = {
      label: '',
      votes: 0,
    }
    @forest.each { |tree|
      label = tree.categorize(set)
      votes[label] += 1

      if leader[:label] == label
        leader[:votes] += 1
      elsif leader[:votes] < votes[label]
        leader[:label] = label
        leader[:votes] = votes[label]
      end
    }

    leader[:label]
  end
end
