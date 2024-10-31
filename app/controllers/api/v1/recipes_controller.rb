class Api::V1::RecipesController < ApplicationController
    
    def index
        if params[:ingredients]
            recipes = Recipe.find(params[:ingredients])
        else
            recipes = Recipe.all
        end
        render json: RecipeSerializer.format_recipes(recipes)

    end
end