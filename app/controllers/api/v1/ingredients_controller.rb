class Api::V1::IngredientsController < ApplicationController
    
    def index
        if params[:for_ingredient]
            ingredients = Ingredient.filter_ingredients(params[:for_ingredient])
        else
            ingredients = Ingredient.all
        end
        render json: IngredientSerializer.new(ingredients)
    end

end