module Gini
	def split_set(set)
		tree = proc { Hash.new { |hash, key| hash[key] = tree.call } };
		attrs = tree.call
		label_index = set[0].length - 1
		set.each do |row|
			row.each_with_index do |val, i|
				# skip if last column since that's the label
				next if i == label_index
				attrs[i][val] = 1
			end
		end


		attrs.keys.each do |index|
			values = attrs[index].keys
			values.each do |val|
				left_set = []
				right_set = []
				#split_on = val.instance_of?("String") ? " a #{val}" : " >= #{val}"
				set.each do |row|
#binding.pry
#puts "working on row #{row} and index #{index} - val of #{val} - label index #{label_index}"
					label = row[label_index]
					if val.instance_of?(String)
						if row[index] == val
							right_set.push(label)
						else
							left_set.push(label)
						end
					else
						if row[index] >= val
							right_set.push(label)
						else
							left_set.push(label)
						end
					end
				end

				init_impurity = calc_impurity( [right_set, left_set].flatten )
				puts "initial impurity: #{init_impurity}"
				puts "#{val} : #{calc_impurity(right_set)}"
				puts "not #{val} : #{calc_impurity(left_set)}"
			end
		end


		#return [{:blah => 1}, {:foo => 2}]
	end
	
	def calc_impurity(labels)
#puts "working on #{labels}"
#binding.pry
		count = labels.length.to_f
		count_of_each = Hash.new(0)

		labels.each do |label|
			count_of_each[label] += 1.0
		end

		sum = 0
		count_of_each.keys.each do |label|
			sum += (count_of_each[label]/count)**2
		end

		return 1 - sum
	end
end
