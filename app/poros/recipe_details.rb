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

    def get_ingredients(id)
        recipe = Recipe.find(id)
        ingredients = []
        recipe.recipe_ingredients.each do |ingredient|
            ingredient = recipe_ingredient.ingredient
            quantity = recipe_ingredient.quantity
            measurement = recipe_ingredient.unit
            price = recipe_ingredient.national_price
            ingredients.push({
                quantity: quanity, 
                unit: measurement, 
                ingredient: ingredient,
                price: price
            })
        end
        ingredients
    end
    
    def get_total_price(ingredients)
        recipe = Recipe.find(id)
        recipe.ingredients.sum("national_price")
    end

    def get_cookware(id)
        recipe = Recipe.find(id)
        cookware = []
        recipe.recipe_cookwares.each do |cookware|
            cookware.push(cookware.name)
        end
        cookware
    end

    def get_instructions(id)
        recipe = Recipe.find(id)
        # instructions = [
        #     {cooking_style: 0, instructions: [{instruction_step:1, instruction:"string"},{instruction_step:2, instruction:"string"}]},
        #     {cooking_style: 1, instructions: []},
        #     {cooking_style: 2, instructions: []},
        #     {cooking_style: 3, instructions: []}
        # ]
        # if cooking style doesn't exist, create object, then push instruction
        # if cooking style does exist, push instruction
        recipe.recipe_instructions.each do |instruction|
            if cooking_style == 1
        end
    end

    def get_cooking_tips(id)
        recipe = Recipe.find(id)
        cooking_tip = []
        recipe.recipe_cooking_tips.each do |cookware|
            cooking_tip.push(cooking_tip.name)
        end
        cooking_tip
    end
end