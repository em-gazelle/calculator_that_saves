require 'rails_helper'

RSpec.describe Calculator do
	describe 'self.calculate(calculation_query)' do
		context 'when valid query' do
			context 'simple and valid' do
				it 'does not throw error if no calculation to perform, but valid number in query' do
					expect(Calculator.calculate("-33328282.9")).to eq(-33328282.9)
					expect(Calculator.calculate("+5+3")).to eq(8.0)
					expect(Calculator.calculate(".98789")).to eq(0.98789)
					expect(Calculator.calculate("0")).to eq(0)
				end
				it 'converts string to integers, operators, and returns proper calculation' do
					expect(Calculator.calculate("3+4")).to eq(7)
				end
				it 'handles decimals, fractions, and non-integer division results' do
					expect(Calculator.calculate("3/4")).to eq(0.75)
					expect(Calculator.calculate("3.3/4.4").zero?).to be false
					expect(Calculator.calculate("(2/3)/(3/2)").zero?).to be false
				end
				it "handles exponent sign '^' as Ruby's '**" do
					expect(Calculator.calculate("(3^3)*2")).to eq(54)
				end
				it 'handles negative and subtraction signs properly' do
					expect(Calculator.calculate("3----4")).to eq(-1)
					expect(Calculator.calculate("-3+4*(4-4)")).to eq(-3)
				end
				it "converts 'sqrt' input find square root" do
					expect(Calculator.calculate("sqrt(4)")).to eq(2)
					expect(Calculator.calculate("sqrt4")).to eq(2)
					expect(Calculator.calculate("sqrt(-(2-6))")).to eq(2)
				end
			end
		end
		context 'when invalid characters are included' do
			it 'deletes invalid characters and returns calculation if otherwise valid' do
				expect(Calculator.calculate("a3a3a+3a b-d3!?""")).to eq(33)
				expect(Calculator.calculate("a3a3a+aaabdklsqrt4a")).to eq(35)
			end
			it 'returns error if query still invalid after invalid characters deleted' do
				expect(Calculator.calculate("fnfn4abfch-j3j+")).to eq("Invalid Query")
				expect(Calculator.calculate("3sqrt+a3asqrt -3!?++""")).to eq("Invalid Query")
			end
		end
		context 'when invalid query' do
			it 'returns query string with error message stating that query was invalid' do
				expect(Calculator.calculate("5+3-")).to eq("Invalid Query")				
			end
			it 'does not return imaginary numbers' do
				expect(Calculator.calculate("sqrt-5")).to eq("Invalid Query")				
			end				
		end
	end	

	describe 'remove_invalid_characters_and_separate_numbers_and_operators' do
		it 'accurately deletes all invalid characters, supports operators (sqrt, (), ^, *, -----, +, /), and decimals. Converts all non-operators to floats, returns as array' do
			expect(Calculator.remove_invalid_characters_and_separate_numbers_and_operators("djdjjd8888+++000_-    3*35.9+.9^sqrt(3.3.3)")).to eq([8888.0, "+", "+", "+", 0.0, "-", 3.0, "*", 35.9, "+", 0.9, "^", "sqrt", "(", 3.3, 0.3, ")"])
		end
	end

end