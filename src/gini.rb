module Gini
	def split_set(set)
		tree = proc { Hash.new { |hash, key| hash[key] = tree.call } };
		attrs = tree.call
		label_index = set[0].length - 1

		# for each attribute by index (except for the label) collect the unique set of values for that attribute
		set.each do |row|
			row.each_with_index do |val, i|
				# skip if last column since that's the label
				next if i == label_index
				attrs[i][val] = 1
			end
		end

		# for each attrubute and each unique value in that attribute split the labels into two sets, one that is
		# equal to or greater than a number value/equal to string value and one that is less than a number value/
		# not equal to string value
		# find the impurity  of each set

		split_info = {
			:split_on => '',
			:left_set => [],
			:right_set => [],
			:info_gain => 0,
		}
		attrs.keys.each do |index|
			values = attrs[index].keys
			values.each do |val|
				left_set = []
				right_set = []
				left_labels = []
				right_labels = []
				#split_on = val.instance_of?("String") ? " a #{val}" : " >= #{val}"
				set.each do |row|
					label = row[label_index]
					if val.instance_of?(String) ? row[index] == val : row[index] >= val
						right_labels.push(label)
						right_set.push(row)
					else
						left_labels.push(label)
						left_set.push(row)
					end
				end

				init_impurity      = calc_impurity( [right_labels, left_labels].flatten )
				count_of_labels    = right_labels.length + left_labels.length
				avg_impurity_right = right_labels.length.to_f / count_of_labels.to_f * calc_impurity( right_labels )
				avg_impurity_left  = left_labels.length.to_f / count_of_labels.to_f * calc_impurity( left_labels )
				avg_impurity       = avg_impurity_right + avg_impurity_left
				info_gain          = init_impurity - avg_impurity

				if split_info[:info_gain] <= info_gain
					split_info[:info_gain] = info_gain
					split_info[:left_set]  = left_set
					split_info[:right_set] = right_set

					if info_gain > 0
						split_info[:split_on] = "Index #{index} is #{val.instance_of?(String) ? '' : '>= '}#{val}"
					else
						split_info[:split_on] = [left_labels,right_labels].flatten.uniq.join(", ")
					end
				end
			end
		end

		return split_info
	end
	
	def calc_impurity(labels)
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
