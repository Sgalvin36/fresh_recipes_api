class Api::V1::IngredientsController < ApplicationController
    
    def index
        if params[:for_ingredient]
            ingredients = Ingredient.filter_ingredients(params[:for_ingredient])
        elsif params[:for_dev]
            ingredients = Ingredient.fetch_kroger_data(params[:for_dev])
            return render json: ingredients
        else
            ingredients = Ingredient.all
        end
        render json: IngredientSerializer.new(ingredients)
    end

end

private

locaiton_id = 62000115