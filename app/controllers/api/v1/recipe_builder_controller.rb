class Api::V1::RecipeBuilderController < ApplicationController
    
    def create
        builder = RecipeBuilder.new(user_params)
        if builder.call
            render json: { message: 'Recipe created successfully' }, status: :created
        else
            render json: { error: 'Recipe creation failed' }, status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
    end
        

    def update
        recipe = Recipe.find(params[:id])
        builder = RecipeBuilder.new(user_params)
        if builder.update_call(recipe)
            render json: { message: 'Recipe updated successfully' }, status: :created
        else
            render json: { error: 'Recipe update failed' }, status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
    end

    private
    def user_params
        params.require(:recipe_builder).permit(:name, :serving_size, :image_url, ingredients: [:quantity, :measurement, :ingredient, :price, :productId], instructions: [:cookingStyle, :step, :instruction], cookware: [:cookware], cooking_tips: [:tip])
    end
end