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

    def initialize(recipe, ingredients = nil)
        @id = recipe.id
        @name = recipe.name
        @image = recipe.image
        @serving_size = recipe.serving_size
        @ingredients = ingredients || get_ingredients(recipe)
        @total_price = get_total_price(recipe)
        @cookwares = get_cookware(recipe)
        @instructions = get_instructions(recipe)
        @cooking_tips = get_cooking_tips(recipe)
    end

    def get_ingredients(recipe)
        recipe.recipe_ingredients.map do |rec_ingr|
            {
                ingredient: rec_ingr.ingredient.name,
                price: rec_ingr.ingredient.national_price,
                quantity: rec_ingr.quantity,
                measurement: rec_ingr.measurement.unit
            }
        end
    end
    
    def get_total_price(recipe)
        recipe.ingredients.sum("national_price")
    end

    def get_cookware(recipe)
        recipe.recipe_cookware.map { |r_cookware| r_cookware.cookware.name }
    end

    def get_instructions(recipe)
        recipe.recipe_instructions.each_with_object([]) do |instruction, all_instructions|
            style = all_instructions.find { |style| style[:cooking_style] == instruction.cooking_style }
            unless style
                style = { cooking_style: instruction.cooking_style, instructions: [] }
                all_instructions << style
            end
            style[:instructions] << {
                instruction_step: instruction.instruction_step,
                instruction: instruction.instruction
            }
        end
    end

    def get_cooking_tips(recipe)
        recipe.recipe_cooking_tips.map { |r_cooking_tip| r_cooking_tip.cooking_tip.tip }
    end
end