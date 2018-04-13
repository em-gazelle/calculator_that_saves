module Calculator

	def self.calculate_and_format(calculation_query)
		calculation = calculate(calculation_query)
		(calculation == invalid_query) ? "#{calculation} : #{calculation_query}" : "#{calculation_query} = #{calculation}"
	end

	def self.calculate(expression)
		return invalid_query if expression.include?(invalid_query)
		
		expression = remove_invalid_characters_and_separate_numbers_and_operators(expression) if expression.is_a?(String)
		total = expression.count

		if total.zero? 
			expression
		elsif total == 1
			expression.first.is_a?(Float) ? expression.first : invalid_query 
		elsif total == 2
			if !expression.last.is_a?(Float)
				invalid_query
			elsif ["+", "-"].include?(expression[0])
				merge_sign_into_float(expression[0], expression[1])
			elsif expression[0] == "sqrt"
				perform_individual_calculation(expression[0], expression[1])
			else
				invalid_query
			end
		elsif total >= 2
			# recursion .. sending to perf_ind_calc but calling calculate on substrings (within parens)
			# order of operations
			if expression.index(")")
				closing_parenthesis_index = expression.index(")")
				opening_parenthesis_index = expression[0...closing_parenthesis_index].rindex("(")

				if ((closing_parenthesis_index-opening_parenthesis_index) > 1) 
					innermost_parenthesis_expression = expression[opening_parenthesis_index+1..closing_parenthesis_index-1]
					inner_parentheses_calculated = [calculate(innermost_parenthesis_expression)]
				else
					inner_parentheses_calculated = []
				end

				expression = ( opening_parenthesis_index.zero? ? [] : expression[0..(opening_parenthesis_index-1)] ) + inner_parentheses_calculated + ( (closing_parenthesis_index==total) ? [] : expression[closing_parenthesis_index+1..-1] )
			else
				if expression.rindex("sqrt")
					operator_index = expression.rindex("sqrt")
					expression[operator_index+1..-1] = next_float(expression[operator_index+1..-1]) if !expression[operator_index+1].is_a?(Float)
					expression[operator_index..operator_index+1] = [perform_individual_calculation("sqrt", expression[operator_index+1])]
				elsif expression[0].is_a?(String)
					if ["+", "-"].include?(expression[0]) && expression[1].is_a?(Float)
						expression[0..1] = merge_sign_into_float(expression[0], expression[1])
					else
						invalid_query
					end
				elsif expression.index("^")
					operator_index = expression.index("^")
					invalid_query if !(expression[operator_index-1]).is_a?(Float)
					expression[operator_index+1..-1] = next_float(expression[operator_index+1..-1]) if !expression[operator_index+1].is_a?(Float)

					expression[operator_index-1..operator_index+1] = [perform_individual_calculation(expression[operator_index-1], "^", expression[operator_index+1])]
				elsif expression.index("*") || expression.index("/")
					operator_index = expression.index("*") || expression.index("/")				

					invalid_query if !(expression[operator_index-1]).is_a?(Float)
					expression[operator_index+1..-1] = next_float(expression[operator_index+1..-1]) if !expression[operator_index+1].is_a?(Float)

					expression[operator_index-1..operator_index+1] = [perform_individual_calculation(expression[operator_index-1], expression[operator_index], expression[operator_index+1])]
				elsif expression.index("+") || expression.index("-")
					operator_index = expression.index("+") || expression.index("-")	

					if operator_index == total
						invalid_query
					elsif !(expression[operator_index-1]).is_a?(Float)
						if ["+", "-"].include?(expression[operator_index-1])
							handle_two_add_subtr(operator_index-1, operator_index)
						else
							invalid_query
						end
					elsif !expression[operator_index+1].is_a?(Float)
						expression[operator_index+1..-1] = next_float(expression[operator_index+1..-1]) if !expression[operator_index+1].is_a?(Float)
					else
						expression[operator_index-1..operator_index+1] = [perform_individual_calculation(expression[operator_index-1], expression[operator_index], expression[operator_index+1])]
					end
				else
					expression = invalid_query
				end
			end
			calculate(expression) 
		end
	end

	def self.next_float(sub_expression)
		until sub_expression.first.is_a?(Float) || sub_expression = invalid_query do

			sub_expression.each_with_index do |c, i|
				if ["+", "-"].include?(c) && ["+", "-"].include?(expression[i+1])
					expression[i..i+1] = handle_two_add_subtr([c, expression[i+1]])
				elsif ["+", "-"].include?(c) && expression[i+1].is_a?(Float)
					expression[i..i+1] = merge_sign_into_float(c, expression[i+1])
				else
					invalid_query
				end			
			end
		end
		sub_expression
	end

	def self.perform_individual_calculation(first_number, operator, second_number=nil)
		# process_multi_negatives(operator) if (operator.is_a?(String) && operator.include?("-") && operator.length > 1)
		# can assume at least one of these numbers is an operator

		if second_number
			if ["+", "-", "*", "/"].include?(operator)
				(first_number).send(operator, second_number)
			elsif operator == "^"
				first_number**second_number
			else
				invalid_query
			end
		elsif (first_number == "sqrt") && operator.is_a?(Float)
			Math.sqrt(operator)
		else
			invalid_query
		end
	end

	def self.merge_sign_into_float(sign, float)
		if float < 0 && sign == "-"
			"#{float*-1}".to_f
		elsif float < 0 && sign == "+"
			float
		else
			"#{sign}#{float}".to_f
		end
	end

	def self.invalid_query
		expression = "Invalid Query"
	end

	def self.remove_invalid_characters_and_separate_numbers_and_operators(expression)
		# supporting decimals (.9, 0.9, 9.9, 99) 
		valid_characters_only = expression.scan(/\+|\*|\/|-+|\^|sqrt|\(|\)|\d+\.\d*|\.\d+|\d+/)
		array_with_floats = valid_characters_only.map{|c| c.match(/\d+/) ? c.to_f : c }
		array_with_floats_and_no_double_negatives = array_with_floats.map{|c| c.is_a?(String) && c.include?("--") ? process_multi_negatives(c) : c}
	end

	def self.process_multi_negatives(negative_subtraction)
		negative_subtraction.length.even? ? "+" : "-"
	end

	def self.handle_two_add_subtr(array)
		(array.uniq.count == 1) ? ["-"] : ["+"]
	end

end