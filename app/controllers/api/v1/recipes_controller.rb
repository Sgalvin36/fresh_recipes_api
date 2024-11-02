class Api::V1::RecipesController < ApplicationController
    
    def index
        # if params[:by_recipe]
        #     recipes = Recipe.filter_recipes(params[:by_recipe])
        # elsif params[:by_ingredient]
        #     recipes = Recipe.filter_by_ingredient(params[:by_ingredient])
        # else
        #     recipes = Recipe.all
        # end

        recipes = Recipe.all   
                            .filter_recipes(params[:by_recipe])
                            .filter_by_ingredient(params[:by_ingredient])
                            .filter_by_cooking_style(params[:by_style])
                            .filter_by_price(params[:by_price])

        render json: RecipeSerializer.format_recipes(recipes)

    end
end