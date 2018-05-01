require 'test/unit'
require_relative '../src/node.rb'

class TestTree < Test::Unit::TestCase
  def test_node_isnt_leaf
    node = Node.new(left: Node.new, right: Node.new)
    assert_equal(nil, node.vote, 'non-leaf voting')
  end

  def test_node_100_conf
    node = Node.new(labels: [['apple', 1.0]])
    assert_equal('apple', node.vote, 'voting with 100% confidence')
  end

  def test_node_multi_labels
    100.times do
      labels = ['apple', 'lemon', 'orange']
      node = Node.new(labels: [['apple', 0.3], ['grape', 0.2], ['lemon', 0.3], ['orange', 0.3], ['banana', 0.1]])
      vote = node.vote
      assert(labels.index(vote), "voting with less than 100% confidence picked either apple, lemon, or orange - vote was for #{vote}")
    end
  end
end
