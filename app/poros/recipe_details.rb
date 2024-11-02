class RecipeDetails
    attr_reader :id,
                :name,
                :serving_size,
                :total_price,
                :image,
                :ingredients,
                :cookwares,
                :instructions,
                :cooking_tips

    def initialize(recipe_data)
        @id = recipe_data[:id]
        @name = recipe_data[:name]
        @image = recipe_data[:image]
        @serving_size = recipe_data[:serving_size]
        @ingredients = get_ingredients(@id)
        @total_price = get_total_price(@ingredients)
        @cookwares = get_cookware(@id)
        @instructions = get_instructions(@id)
        @cooking_tips = get_cooking_tips(@id)
    end

    def find_recipe(id)
        recipe = Recipe.find_by(id: id)
        recipe ? recipe : nil
    end

    def get_ingredients(id)
        recipe = find_recipe(id)
        return [] if recipe.nil?
        ingredients = []
        recipe.recipe_ingredients.each do |rec_ingr|
            build_data = {
            ingredient: rec_ingr.ingredient.name,
            price: rec_ingr.ingredient.national_price,
            quantity: rec_ingr.quantity,
            measurement: rec_ingr.measurement.unit
            }
            ingredients.push(build_data)
        end
        ingredients
    end
    
    def get_total_price(id)
        recipe = find_recipe(id)
        return 0.00 if recipe.nil?
        recipe.ingredients.sum("national_price")
    end

    def get_cookware(id)
        recipe = find_recipe(id)
        return [] if recipe.nil?
        cookware = []
        recipe.recipe_cookwares.each do |cookware|
            cookware.push(cookware.name)
        end
        cookware
    end

    def get_instructions(id)
        recipe = find_recipe(id)
        return [] if recipe.nil?
        all_instructions = []
        recipe.recipe_instructions.each do |instruction|
            if !all_instructions.any? { |style| style[:cooking_style] == instruction.cooking_style}
                all_instructions.push({cooking_style: instruction.cooking_style, instructions: []})

            end
            style_index = all_instructions.index { |style| style[:cooking_style] == instruction.cooking_style}
            all_instructions[style_index][:instructions].push({instruction_step: instruction.instruction_step, instruction: instruction.instruction})
        end
        all_instructions
    end

    def get_cooking_tips(id)
        recipe = find_recipe(id)
        return [] if recipe.nil?
        cooking_tip = []
        recipe.recipe_cooking_tips.each do |cookware|
            cooking_tip.push(cooking_tip.name)
        end
        cooking_tip
    end
end