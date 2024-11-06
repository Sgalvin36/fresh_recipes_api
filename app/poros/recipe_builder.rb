class RecipeBuilder

    attr_reader :user_params

    def initialize(user_params)
        @user_params = user_params
    end

    def call
        ActiveRecord::Base.transaction do
            recipe = create_recipe
            create_ingredients(recipe)
            create_instructions(recipe)
            create_cookware(recipe)
            create_cooking_tips(recipe)
            recipe.update_total_price
        end
    end

    private

    def create_recipe
        Recipe.create!(
            name: user_params[:name],
            image: user_params[:image_url],
            serving_size: user_params[:serving_size],
            total_price: 1.00
        )
    end
    
    def create_ingredients(recipe)
        user_params[:ingredients].each do |ingredient|
            new_ing = Ingredient.create!(
                name: ingredient[:ingredient],
                national_price: ingredient[:price],
                kroger_id: ingredient[:productId]
                taxable: true,
                snap: true
            )
            new_mes = Measurement.create!(unit: ingredient[:measurement])
            RecipeIngredient.create!(
                quantity: ingredient[:quantity],
                recipe: recipe,
                ingredient: new_ing,
                measurement: new_mes
            )
        end
    end

    def create_instructions(recipe)
        user_params[:instructions].each do |instruction|
            RecipeInstruction.create!(
                instruction: instruction[:instruction], 
                cooking_style: instruction[:cookingStyle], 
                recipe: recipe
            )
        end
    end

    def create_cookware(recipe)
        user_params[:cookware].each do |cookware|
            new_cook = Cookware.create!(name: cookware[:cookware])
            RecipeCookware.create!(
                cookware: new_cook, 
                recipe: recipe
            )
        end
    end

    def create_cooking_tips(recipe)
        user_params[:cooking_tips].each do |tip|
            new_tip = CookingTip.create!(tip: tip[:tip])
            RecipeCookingTip.create!(
                cooking_tip: new_tip, 
                recipe: recipe
            )
        end
    end
end
