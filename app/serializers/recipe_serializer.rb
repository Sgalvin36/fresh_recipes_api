class RecipeSerializer
    include JSONAPI::Serializer
    
    def self.format_recipes(recipes)
        { data: 
            recipes.map do |recipe|
            {
                id: recipe.id,
                type: "recipe",
                attributes: {
                    recipe_name: recipe.name,
                    total_price: recipe.ingredients.sum("national_price"),
                    image: recipe.image,
                    ingredients: recipe.get_ingredient_list
                }
            } end
        }
    end

    # def format_recipe(recipe)
    #     { data:
    #         {
    #             id: recipe.id,
    #             type: "recipe",
    #             attributes: {
    #                 recipe_name: recipe.recipe_name,
    #                 total_price: recipe.total_price,
    #                 image: recipe.image,
    #                 ingredients: [
    #                     # map over ingredients
    #                     {quantity: , measurement: , ingredient: , national_price:} 
    #                 ],
    #                 instructions: [
    #                     # map over instructions and sort cooking styles into seperate arrays
    #                     # an array with arrays of instructions (ideally, in order)
    #                 ],
    #                 cooking_tips: [
    #                     #  map over cooking_tips to make it an array of strings
    #                 ]
    #             }
    #         }
    #     }
    # end
end