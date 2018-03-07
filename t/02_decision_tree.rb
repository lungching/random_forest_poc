require "test/unit"
require_relative "../src/decision_tree.rb"


class TestTree < Test::Unit::TestCase
	def test_tree_build
		# test data example from google's video on building decision trees https://www.youtube.com/watch?v=LDRbO9a6XPU
		test_data = [
			['green', 3, 'apple'],
			['yellow', 3, 'apple'],
			['red', 1, 'grape'],
			['red', 1, 'grape'],
			['yellow', 3, 'lemon'],
		]
		dTree = DecisionTree.new(data: test_data )
		node = dTree.build_tree

		#dTree.pretty_print
		assert_equal([1,3], node.split_on, "root node split")
		assert_equal("", node.left.split_on, "root's left node split is blank")
		assert_equal([["grape", 1.0]], node.left.labels, "root's left node label")
		assert_equal([0, "yellow"], node.right.split_on, "root's right node split")
		assert_equal("", node.right.left.split_on, "root's right's left node split is blank")
		assert_equal([["apple", 1.0]], node.right.left.labels, "root's right's left node label")
		assert_equal("", node.right.right.split_on, "root's right's right node split is blank")
		assert_equal([["apple", 0.5], ["lemon", 0.5]], node.right.right.labels, "root's right's right node label")
	end

	def test_build_subset_attrs
		srand( 327538163933117543858906166455989191158 )
		# PassengerId,Survived,Pclass,Name,Sex,Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked
		test_data = [
			[1,0,3,"Braund, Mr. Owen Harris","male",22,1,0,"A/5 21171",7.25,nil,'S'],
			[2,1,1,"Cumings, Mrs. John Bradley (Florence Briggs Thayer)","female",38,1,0,"PC 17599",71.2833,"C85",'C'],
			[3,1,3,"Heikkinen, Miss. Laina","female",26,0,0,"STON/O2. 3101282",7.925,nil,'S'],
			[4,1,1,"Futrelle, Mrs. Jacques Heath (Lily May Peel)","female",35,1,0,113803,53.1,"C123",'S'],
			[5,0,3,"Allen, Mr. William Henry","male",35,0,0,373450,8.05,nil,'S'],
			[6,0,3,"Moran, Mr. James","male",nil,0,0,330877,8.4583,nil,'Q'],
			[7,0,1,"McCarthy, Mr. Timothy J","male",54,0,0,17463,51.8625,"E46",'S'],
		]
		dTree  = DecisionTree.new(data: test_data, use_random: true)
		node   = dTree.build_tree( test_data )
		splits = get_splits( node )
		#puts "splits: #{splits}"
		assert_equal([[9, 51.8625], [[5, ""], [""]], [[10, "E46"], [[3, "Futrelle, Mrs. Jacques Heath (Lily May Peel)"], [""]], [""]]], splits, "node splits taking only a subset of attributes at each node")

		dTree2  = DecisionTree.new(data: test_data, use_random: true)
		node2   = dTree2.build_tree( test_data )
		splits2 = get_splits( node2 )
		assert_equal([[8, 17463], [[10, ""], [""]], [[9, 51.8625], [[5, ""], [""]], [""]]], splits2, "same data, different splits")
	end

	def test_categorize
		# PassengerId,Survived,Pclass,Name,Sex,Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked
		test_data = [
			[1,0,3,"Braund, Mr. Owen Harris","male",22,1,0,"A/5 21171",7.25,nil,'S'],
			[2,1,1,"Cumings, Mrs. John Bradley (Florence Briggs Thayer)","female",38,1,0,"PC 17599",71.2833,"C85",'C'],
			[3,1,3,"Heikkinen, Miss. Laina","female",26,0,0,"STON/O2. 3101282",7.925,nil,'S'],
			[4,1,1,"Futrelle, Mrs. Jacques Heath (Lily May Peel)","female",35,1,0,113803,53.1,"C123",'S'],
			[5,0,3,"Allen, Mr. William Henry","male",35,0,0,373450,8.05,nil,'S'],
			[6,0,3,"Moran, Mr. James","male",nil,0,0,330877,8.4583,nil,'Q'],
			[7,0,1,"McCarthy, Mr. Timothy J","male",54,0,0,17463,51.8625,"E46",'S'],
		]
		dTree = DecisionTree.new(data: test_data, use_random: false)
		dTree.build_tree( test_data )
		assert_equal(dTree.categorize([7,0,1,"McCarthy, Mr. Timothy J","male",54,0,0,17463,51.8625,"E46",'S']), 'S', "labeled set as S")
		assert_equal(dTree.categorize([2,1,1,"Cumings, Mrs. John Bradley (Florence Briggs Thayer)","female",38,1,0,"PC 17599",71.2833,"C85",'C']), 'C', "labeled set as C")
	end

	def get_splits( node )
		splits = [ node.split_on ]
		
		if ! node.is_leaf?
			splits.push( get_splits( node.left ) ) if node.left != nil
			splits.push( get_splits( node.right ) ) if node.right != nil
		end

		return splits.uniq
	end
end

