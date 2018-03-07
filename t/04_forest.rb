require "test/unit"
require_relative "../src/random_forest.rb"


class TestTree < Test::Unit::TestCase
	def test_create
		# PassengerId,Survived,Pclass,Name,Sex,Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked
		data = [
			[1,0,3,"Braund, Mr. Owen Harris","male",22,1,0,"A/5 21171",7.25,nil,'S'],
			[2,1,1,"Cumings, Mrs. John Bradley (Florence Briggs Thayer)","female",38,1,0,"PC 17599",71.2833,"C85",'C'],
			[3,1,3,"Heikkinen, Miss. Laina","female",26,0,0,"STON/O2. 3101282",7.925,nil,'S'],
			[4,1,1,"Futrelle, Mrs. Jacques Heath (Lily May Peel)","female",35,1,0,113803,53.1,"C123",'S'],
			[5,0,3,"Allen, Mr. William Henry","male",35,0,0,373450,8.05,nil,'S'],
			[6,0,3,"Moran, Mr. James","male",nil,0,0,330877,8.4583,nil,'Q'],
			[7,0,1,"McCarthy, Mr. Timothy J","male",54,0,0,17463,51.8625,"E46",'S'],
		]
		forest = RandomForest.new(num_of_trees: 3)
		forest.create_forest( data )
		assert_equal( forest.forest.size, 3, "Created 3 trees" )

	end

	def test_winner
		srand( 327538163933117543858906166455989191158 )
		data = [
			[1,0,3,"Braund, Mr. Owen Harris","male",22,1,0,"A/5 21171",7.25,nil,'S'],
			[2,1,1,"Cumings, Mrs. John Bradley (Florence Briggs Thayer)","female",38,1,0,"PC 17599",71.2833,"C85",'C'],
			[3,1,3,"Heikkinen, Miss. Laina","female",26,0,0,"STON/O2. 3101282",7.925,nil,'S'],
			[4,1,1,"Futrelle, Mrs. Jacques Heath (Lily May Peel)","female",35,1,0,113803,53.1,"C123",'S'],
			[5,0,3,"Allen, Mr. William Henry","male",35,0,0,373450,8.05,nil,'S'],
			[6,0,3,"Moran, Mr. James","male",nil,0,0,330877,8.4583,nil,'Q'],
			[7,0,1,"McCarthy, Mr. Timothy J","male",54,0,0,17463,51.8625,"E46",'S'],
		]
		forest = RandomForest.new(num_of_trees: 3)
		forest.create_forest( data )
		winner = forest.winner([4,1,1,"Futrelle, Mrs. Jacques Heath (Lily May Peel)","female",35,1,0,113803,53.1,"C123",'S'])
		assert_equal(winner, 'S', "Found S")
	end
end
