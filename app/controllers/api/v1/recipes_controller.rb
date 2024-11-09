class Api::V1::RecipesController < ApplicationController
    def index
        recipes = Recipe.all   
                            .filter_recipes(user_params)
                            .filter_by_ingredient(user_params)
                            .filter_by_cooking_style(user_params)
                            .filter_by_price(user_params)
                            .filter_by_serving(user_params)

        render json: RecipeSerializer.format_recipes(recipes)
    end

    def show
        recipe = Recipe.find(user_params[:id])
        if user_params[:by_location].present?
            update_ingredients = recipe.update_ingredients_details(user_params[:by_location])
            recipe_details = RecipeDetails.new(recipe, update_ingredients)
        else
            recipe_details = RecipeDetails.new(recipe)
        end
        render json: RecipeSerializer.format_recipe_details(recipe_details)
    end

    private
    def user_params
        params.permit(:id, :by_location, :by_recipe, :by_ingredient, :by_style, :by_price, :by_serving)
    end
end