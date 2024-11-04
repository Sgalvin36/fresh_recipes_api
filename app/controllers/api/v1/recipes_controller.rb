class Api::V1::RecipesController < ApplicationController
    def index
        recipes = Recipe.all   
                            .filter_recipes(params[:by_recipe])
                            .filter_by_ingredient(params[:by_ingredient])
                            .filter_by_cooking_style(params[:by_style])
                            .filter_by_price(params[:by_price])
                            .filter_by_serving(params[:by_serving])

        render json: RecipeSerializer.format_recipes(recipes)
    end

    def show
        recipe = Recipe.find(params[:id])
        recipe_details = RecipeDetails.new(recipe)
        render json: RecipeSerializer.format_recipe_details(recipe_details)
    end
end