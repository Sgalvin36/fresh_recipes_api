class Api::V1::RecipesController < ApplicationController
    
    def index
        if params[:by_recipe]
            recipes = Recipe.filter_recipes(params[:by_recipe])
        elsif params[:by_ingredient]
            recipes = Recipe.filter_by_ingredient(params[:by_ingredient])
        else
            recipes = Recipe.all
        end
        render json: RecipeSerializer.format_recipes(recipes)

    end
end