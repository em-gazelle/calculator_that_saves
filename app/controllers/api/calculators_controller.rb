module Api
	class CalculatorsController < ApplicationController

		def create
			@calculation = Calculator.calculate_and_format(calculation_params)

			# add newest calculation to top of list of saved calculations
			( session[:calculations] ||= [] ).unshift(@calculation)
			# delete oldest calculation if max number of calculations to save has been exceeded
			session[:calculations].pop if (session[:calculations].count > total_number_of_calculations_to_save)
			@calculations = session[:calculations]

			render json: { calculations: @calculations }
		end

		def index
			@calculations = session[:calculations]
			render json: { calculations: @calculations, status: 200}
		end


		private

		def total_number_of_calculations_to_save
			10
		end

		def calculation_params
			params.require(:calculation)
		end
		
	end
end