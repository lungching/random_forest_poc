require 'set'

# given a data set figures out the best way to split it so that one group
# is as consistent as possible
class Gini
  attr_accessor :random_attrs     # if true then at each split only a subset of all the attributes will be considered

  def initialize(random_attrs: false)
    @random_attrs = random_attrs
  end

  def split_set(set)
    tree = proc { Hash.new { |hash, key| hash[key] = tree.call } }
    attrs = tree.call
    label_index = set[0].length - 1

    # for each attribute by index (except for the label) collect the unique set of values for that attribute
    set.each do |row|
      dont_include_num = 0
      row.each_with_index do |val, i|
        # skip if last column since that's the label
        next if i == label_index
        attrs[i][:val] = Set.new unless attrs[i].respond_to?('add')
        attrs[i][:val].add(val)

        # if using a random number of attributes is enabled then set a marker if a given random number is greater than the number of attributes divided by 3
        attrs[i][:include] = random_attrs && (dont_include_num < (row.length - 3)) ? Random.rand(5) != 0 : true
        dont_include_num += 1 unless attrs[i][:include]
      end
    end
# puts "\n\nattrs: #{attrs.inspect}"; exit
    # for each attrubute and each unique value in that attribute split the labels into two sets, one that is
    # equal to or greater than a number value/equal to string value and one that is less than a number value/
    # not equal to string value
    # find the impurity  of each set

    split_info = {
      split_on: '',
      labels: '',
      left_set: [],
      right_set: [],
      info_gain: 0.0,
    }

    init_impurity = nil
    count_of_labels = nil
    num_keys = attrs.keys.length
    attrs.keys.sample(num_keys).each do |index|
      next unless attrs[index][:include]
      attrs[index][:val].each do |val|
        val ||= ''
        left_set     = []
        right_set    = []
        left_labels  = []
        right_labels = []
        set.each do |row|
          row[index] = '' unless row[index]
          label = row[label_index]
          if val.instance_of?(String) || row[index].instance_of?(String) ? row[index].to_s == val.to_s : row[index] >= val
            right_labels.push(label)
            right_set.push(row)
          else
            left_labels.push(label)
            left_set.push(row)
          end
        end

        init_impurity      ||= calc_impurity([right_labels, left_labels].flatten)
        count_of_labels    ||= right_labels.length + left_labels.length
        avg_impurity_right   = right_labels.length.to_f / count_of_labels.to_f * calc_impurity(right_labels)
        avg_impurity_left    = left_labels.length.to_f / count_of_labels.to_f * calc_impurity(left_labels)
        avg_impurity         = avg_impurity_right + avg_impurity_left
        info_gain            = init_impurity - avg_impurity
        info_gain            = info_gain.round(20)

        if split_info[:info_gain] <= info_gain
          split_info[:info_gain] = info_gain
          split_info[:left_set]  = left_set
          split_info[:right_set] = right_set

          if info_gain > 0.0
            split_info[:split_on] = [index, val]
          else
            split_info[:labels] = label_list([left_labels, right_labels].flatten)
          end
        end
      end

      split_info[:labels] = label_list([left_labels, right_labels].flatten) unless split_info[:split_on]
    end

    split_info
  end

  # compile count of each label, sum for each unique label the value of ( its count / total count )^2
  # the impurity is 1 minus the sum
  def calc_impurity(labels)
    count = labels.length.to_f
    count_of_each = Hash.new(0)

    labels.each do |label|
      count_of_each[label] += 1.0
    end

    sum = 0
    count_of_each.keys.each do |label|
      sum += (count_of_each[label] / count)**2
    end

    1 - sum
  end

  # return an array of arrays where each row is an array with the first element is the label and the second is the confidence
  # the confidence is calculated by summing the count of each instance of labels and dividing by the total size of the list
  def label_list(labels)
    list_size = labels.count

    label_count = Hash.new(0)
    labels.each do |label|
      label_count[label] += 1.0
    end
 
    compiled_labels = []
    label_count.keys.each do |key|
      compiled_labels.push([key, label_count[key] / list_size])
    end

    compiled_labels
  end
end
