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

    def update_call(recipe)
        ActiveRecord::Base.transaction do
            return false unless update_recipe(recipe) if user_params[:name].present? || user_params[:image_url].present? || user_params[:serving_size].present?
            return false unless update_ingredients(recipe) if user_params[:ingredients].present?
            return false unless update_instructions(recipe) if user_params[:instructions].present?
            return false unless update_cookware(recipe) if user_params[:cookware].present?
            return false unless update_cooking_tips(recipe) if user_params[:cooking_tips].present?
            recipe.update_total_price
            recipe.save!
        end
        true
    rescue ActiveRecord::RecordInvalid
        false
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
                national_price: ingredient[:price].to_f,
                kroger_id: ingredient[:productId],
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
                instruction_step: instruction[:step], 
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

    def update_recipe(recipe)
        recipe.update!(
            name: user_params[:name],
            image: user_params[:image_url],
            serving_size: user_params[:serving_size],
            total_price: 1.00
        )
    end

    def update_ingredients(recipe)
        user_params[:ingredients].each do |data|
            new_ing = Ingredient.find_or_initialize_by(kroger_id: data[:productId])
            new_ing.update!(
                name: data[:ingredient],
                national_price: data[:price].to_f,
                kroger_id: data[:productId],
                taxable: true,
                snap: true
            )

            new_mes = Measurement.find_or_initialize_by(unit: data[:measurement])
            new_mes.update!(unit: data[:measurement])

            recipe_ingredient = RecipeIngredient.find_or_initialize_by(recipe: recipe, ingredient: new_ing)
            recipe_ingredient.update!(
            quantity: data[:quantity],
            measurement: new_mes
            )
        end
    end

    def update_instructions(recipe)
        user_params[:instructions].each do |instr|
            new_inst = RecipeInstruction.find_or_initialize_by(
                instruction: instr[:instruction],  
                cooking_style: instr[:cookingStyle]
            )

            new_inst.update!(
                instruction: instr[:instruction], 
                cooking_style: instr[:cookingStyle],
                instruction_step: instr[:step], 
                recipe: recipe
            )
        end
    end

    def update_cookware(recipe)
        user_params[:cookware].each do |cookware|
            new_cook = Cookware.find_or_initialize_by(name: cookware[:cookware])
            recipe_cookware = RecipeCookware.find_or_initialize_by(
                recipe: recipe, 
                cookware: new_cook
            )
            
            recipe_cookware.update!(
                cookware: new_cook, 
                recipe: recipe
            )
        end
    end

    def update_cooking_tips(recipe)
        user_params[:cooking_tips].each do |tip|
            new_tip = CookingTip.find_or_initialize_by(tip: tip[:tip])
            recipe_cooking_tip = RecipeCookingTip.find_or_initialize_by(
                recipe: recipe, 
                cooking_tip: new_tip
            )
            
            recipe_cooking_tip.update!(
                cooking_tip: new_tip, 
                recipe: recipe
            )
        end
    end
end
