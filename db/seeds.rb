# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

@ing1 = Ingredient.create!(name:"Potato", national_price:1.00, taxable:false, snap:true)
@ing2 = Ingredient.create!(name:"Cheddar cheese", national_price:2.00, taxable:false, snap:true)
@ing3 = Ingredient.create!(name:"Sour Cream", national_price:1.00, taxable:false, snap:true)

@mes1 = Measurement.create!(type:"lb")
@mes2 = Measurement.create!(type:"lbs")
@mes3 = Measurement.create!(type:"cup")
@mes4 = Measurement.create!(type:"cups")
@mes5 = Measurement.create!(type:"teaspoon")
@mes6 = Measurement.create!(type:"teaspoons")
@mes7 = Measurement.create!(type:"tablespoon")
@mes8 = Measurement.create!(type:"tablespoons")
@mes9 = Measurement.create!(type:"ounce")
@mes10 = Measurement.create!(type:"ounces")
@mes11 = Measurement.create!(type:"each")

@recipe1 = Recipe.create!(name:"Baked Potato", image:"future_image_of_potato", total_price:4.00)

RecipeIngredient.create!(recipe_id:@recipe1.id ,ingredient_id:@ing1.id, measurement_id:@mes1.id, quantity:1)
RecipeIngredient.create!(recipe_id:@recipe1.id ,ingredient_id:@ing2.id, measurement_id:@mes10.id, quantity:2)
RecipeIngredient.create!(recipe_id:@recipe1.id ,ingredient_id:@ing3.id, measurement_id:@mes8.id, quantity:2)

RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:1, instruction_step: 1,instruction:"Wash the dirt off the potato")
RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:1, instruction_step: 2,instruction:"Poke holes in the potato to allow steam to escape")
RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:1, instruction_step: 3,instruction:"Put on plate in microwave and cook for 8 minutes")
RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:1, instruction_step: 4,instruction:"If a fork is easily pushed in, its done, otherwise cook for an additional 2 minutes")
RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 1,instruction:"Preheat oven to 400 degrees")
RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 2,instruction:"Wash the dirt off the potato")
RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 3,instruction:"Poke holes in the potato to allow steam to escape")
RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 4,instruction:"Place potato on oven safe tray and cook for 45 minutes")
RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 5,instruction:"If a fork is easily pushed in, its done, otherwise cook for an additional 2 minutes")