class RecipeSerializer
    include JSONAPI::Serializer
    
    def format_recipes(recipes)
        { data: 
            recipes.map do |recipe|
            {
                id: recipe.id,
                type: "recipe",
                attributes: {
                    recipe_name: recipe.recipe_name,
                    total_price: recipe.total_price,
                    image: recipe.image,
                    ingredients: [
                        # {ingredient_id: id,
                        # ingredient_name: name}
                        # map over ingredients to make ingredient array
                    ]
                }
            }
        }
    end

    def format_recipe(recipe)
        { data:
            {
                id: recipe.id,
                type: "recipe",
                attributes: {
                    recipe_name: recipe.recipe_name,
                    total_price: recipe.total_price,
                    image: recipe.image,
                    ingredients: [
                        # map over ingredients
                        {quantity: , measurement: , ingredient: , national_price:} 
                    ],
                    instructions: [
                        # map over instructions and sort cooking styles into seperate arrays
                        # an array with arrays of instructions (ideally, in order)
                    ],
                    cooking_tips: [
                        #  map over cooking_tips to make it an array of strings
                    ]
                }
            }
        }
    end
end