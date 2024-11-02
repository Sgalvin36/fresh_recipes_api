# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

@ing1 = Ingredient.create!(name: "Russett Potato", national_price: 1.00, taxable: false, snap: true)
@ing2 = Ingredient.create!(nam  "16oz Bag of Shredded Cheddar Cheese", national_price: 2.00, taxable: false, snap: true)
# Cooking Oils/Butter - Can we make the price reflect these partial amounts needed for recipes w/o suggesting they buy more?
# For example, if the recipe calls for 2 TBL of oilive oil and an 8oz bottle costs $4, can we simply calculate that partial cost for the recipe?
@ing3 = Ingredient.create!(name: "Olive Oil", national_price: 4.00, taxable: false, snap: true)
@ing4 = Ingredient.create!(name: "9oz Tube Chorizo Sausage", national_price: 3.00, taxable: false, snap: true)
# Are we going to have to do special pricing (by weight) for fresh fruits/vegetables?
@ing5 = Ingredient.create!(name: "Onion", national_price: 0.75, taxable: false, snap: true)
@ing6 = Ingredient.create!(name: "1lb Bulk Potatoes", national_price: 0.75, taxable: false, snap: true)
@ing7 = Ingredient.create!(name: "Onion", national_price: 0.75, taxable: false, snap: true)
@ing8 = Ingredient.create!(name: "8oz Grated Parmesean Cheese", national_price: 3, taxable: false, snap: true)
@ing9 = Ingredient.create!(name: "16oz Bag of Farfalle Pasta", national_price: 2, taxable: false, snap: true)
@ing10 = Ingredient.create!(name: "16oz Jar of Marinara Sauce", national_price: 2, taxable: false, snap: true)
@ing11 = Ingredient.create!(name: "4oz Bag of Pepperoni Slices", national_price: 3, taxable: false, snap: true)
@ing12 = Ingredient.create!(name: "16oz Jar of Alfredo Sauce", national_price: 2.50, taxable: false, snap: true)
@ing13 = Ingredient.create!(name: "4oz Can of Mushrooms", national_price: 2, taxable: false, snap: true)
@ing14 = Ingredient.create!(name: "16oz Bag of Fettuccine Pasta", national_price: 2, taxable: false, snap: true)
@ing15 = Ingredient.create!(name: "5 oz Can of Chicken Breast", national_price: 1.50, taxable: false, snap: true)



@mes1 = Measurement.create!(unit: "lb")
@mes2 = Measurement.create!(unit: "lbs")
@mes3 = Measurement.create!(unit: "cup")
@mes4 = Measurement.create!(unit: "cups")
@mes5 = Measurement.create!(unit: "teaspoon")
@mes6 = Measurement.create!(unit: "teaspoons")
@mes7 = Measurement.create!(unit: "tablespoon")
@mes8 = Measurement.create!(unit: "tablespoons")
@mes9 = Measurement.create!(unit: "ounce")
@mes10 = Measurement.create!(unit: "ounces")
@mes11 = Measurement.create!(unit: "each")

# Tips
@tip1 = CookingTip.create!(tip: "Reduce cooking time by chopping potatoes smaller.  This may take a few times to figure out.")
@tip2 = CookingTip.create!(tip: "Drain pasta without a strainer by using the pot's lid, a plate, bowl, a long spoon, tongs to hold pasta in pot while tipping out water.")
@tip3 = CookingTip.create!(tip: "Substitute any desired pasta type for this dish - Just ensure to follow package instructions (Note: Different pasta prices will differ).")

# Cookware
@cookware1 = Cookware.create!(name: "Microwave-Safe Baking Dish")
@cookware2 = Cookware.create!(name: "Oven-Safe Baking Dish")
@cookware3 = Cookware.create!(name: "Hot Pads/Dish Towel")
@cookware4 = Cookware.create!(name: "Large Microwave-Safe Bowl")
@cookware5 = Cookware.create!(name: "Metal Cooking Pot")
@cookware6 = Cookware.create!(name: "Metal Frying Pan")
@cookware7 = Cookware.create!(name: "Can Opener")

@recipe1 = Recipe.create!(name: "Baked Potato", image: "future_image_of_potato", total_price: 4.00)
RecipeCookware.create!(recipe: @recipe1, cookware: @cookware1)
RecipeCookware.create!(recipe: @recipe1, cookware: @cookware2)

RecipeIngredient.create!(recipe_id: @recipe1.id ,ingredient_id: @ing1.id, measurement_id: @mes1.id, quantity: 1)
RecipeIngredient.create!(recipe_id: @recipe1.id ,ingredient_id: @ing2.id, measurement_id: @mes10.id, quantity: 2)
RecipeIngredient.create!(recipe_id: @recipe1.id ,ingredient_id: @ing3.id, measurement_id: @mes8.id, quantity: 2)

# Microwave Instructions
RecipeInstruction.create!(recipe_id: @recipe1.id, cooking_style:1, instruction_step: 1,instruction: "Wash the dirt off the potato")
RecipeInstruction.create!(recipe_id: @recipe1.id, cooking_style:1, instruction_step: 2,instruction: "Poke holes in the potato to allow steam to escape")
RecipeInstruction.create!(recipe_id: @recipe1.id, cooking_style:1, instruction_step: 3,instruction: "Put on plate in microwave and cook for 8 minutes")
RecipeInstruction.create!(recipe_id: @recipe1.id, cooking_style:1, instruction_step: 4,instruction: "If a fork is easily pushed in, its done, otherwise cook for an additional 2 minutes")

# Oven Instructions
RecipeInstruction.create!(recipe_id: @recipe1.id, cooking_style:3, instruction_step: 1,instruction: "Preheat oven to 400 degrees")
RecipeInstruction.create!(recipe_id: @recipe1.id, cooking_style:3, instruction_step: 2,instruction: "Wash the dirt off the potato")
RecipeInstruction.create!(recipe_id: @recipe1.id, cooking_style:3, instruction_step: 3,instruction: "Poke holes in the potato to allow steam to escape")
RecipeInstruction.create!(recipe_id: @recipe1.id, cooking_style:3, instruction_step: 4,instruction: "Place potato on oven safe tray and cook for 45 minutes")
RecipeInstruction.create!(recipe_id: @recipe1.id, cooking_style:3, instruction_step: 5,instruction: "If a fork is easily pushed in, its done, otherwise cook for an additional 2 minutes")



@recipe2 = Recipe.create!(name: "Roasted Potato Chunks w/Chorizo Sausage", image: "future_image_of_roasted_chunky_taters", total_price:8.00)
RecipeCookware.create!(recipe: @recipe2, cookware: @cookware1)
RecipeCookware.create!(recipe: @recipe2, cookware: @cookware2)
RecipeCookingTip.create!(recipe: @recipe2, cooking_tip: @tip1)

RecipeIngredient.create!(recipe_id: @recipe2.id ,ingredient_id: @ing6.id, measurement_id: @mes1.id, quantity: 1)
RecipeIngredient.create!(recipe_id: @recipe2.id ,ingredient_id: @ing4.id, measurement_id: @mes10.id, quantity: 1)
RecipeIngredient.create!(recipe_id: @recipe2.id ,ingredient_id: @ing2.id, measurement_id: @mes8.id, quantity: 1)
RecipeIngredient.create!(recipe_id: @recipe2.id ,ingredient_id: @ing3.id, measurement_id: @mes8.id, quantity: 0.125)
RecipeIngredient.create!(recipe_id: @recipe2.id ,ingredient_id: @ing3.id, measurement_id: @mes8.id, quantity: 1)

# Microwave Instructions
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 1, instruction: "Wash potatoes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 2, instruction: "Chop uniformly into ½-1” cubes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 3, instruction: "Toss potatoes with olive oil or melted butter until coated.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 4, instruction: "Place potatoes in glass or microwave-safe plastic dish.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 5, instruction: "Cut one end from chorizo tube and evenly squeeze on top of potatoes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 6, instruction: "Cook on high for 5 minutes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 7, instruction: "Use spoon or spatula to stir potatoes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 8, instruction: "Add shredded cheese on top.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 9, instruction: "Cook on high another 5 minutes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 10, instruction: "Potatoes are done if a fork goes right through them.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 1, instruction_step: 11, instruction: "Top with diced onions if desired.")

# Oven Instructions
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 1, instruction: "Preheat oven to 425°F.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 2, instruction: "Wash potatoes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 3, instruction: "Chop uniformly into ½-1” cubes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 4, instruction: "Toss potatoes with olive oil or melted butter until coated.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 5, instruction: "Place potatoes in appropriate cooking dish: ")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 6, instruction: "For Microwave: Glass or Microwave-safe plastic.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 7, instruction: "For Oven: Glass or Metal.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 8, instruction: "Cut one end from chorizo tube and evenly squeeze on top of potatoes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 9, instruction: "Place in middle rack for 25-35 minutes - stir them at 10 minutes & at 20 minutes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 10, instruction: "Add shredded cheese at 20 minutes.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 11, instruction: "Potatoes are done if a fork goes right through them.")
RecipeInstruction.create!(recipe_id: @recipe2.id, cooking_style: 3, instruction_step: 12, instruction: "Top with diced onions if desired.")


@recipe3 = Recipe.create!(name: "Pepperoni & Parmesan Marina Pasta", image: "future_image_of_pepperoni_pasta", total_price: 8.00)
RecipeCookware.create!(recipe: @recipe3, cookware: @cookware4)
RecipeCookware.create!(recipe: @recipe3, cookware: @cookware5)
RecipeCookingTip.create!(recipe: @recipe3, tip: @tip2)

RecipeIngredient.create!(recipe_id: @recipe3.id ,ingredient_id: @ing1.id, measurement_id: @mes1.id, quantity: 1)
RecipeIngredient.create!(recipe_id: @recipe3.id ,ingredient_id: @ing10.id, measurement_id: @mes1.id, quantity: 0.5)
RecipeIngredient.create!(recipe_id: @recipe3.id ,ingredient_id: @ing1.id, measurement_id: @mes1.id, quantity: 1)

# Microwave Cooking Instructions
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 1, instruction_step:1, instruction: "Put pasta in a microwave-safe bowl.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 1, instruction_step:2, instruction: "Cover with water by at least 2 inches.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 1, instruction_step:3, instruction: "Microwave on high for the time on the package plus a couple of extra minutes.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 1, instruction_step:4, instruction: "Stir halfway through cooking to prevent sticking.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 1, instruction_step:5, instruction: "Remove with hot pads or kitchen towel.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 1, instruction_step:6, instruction: "Drain pasta.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 1, instruction_step:7, instruction: "Add sauce & pepperoni.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 1, instruction_step:8, instruction: "Cover, and place back in the microwave for 1-2 minutes or until entire meal is warm.")

# Stovetop Cooking Instructions
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 2, instruction_step: 1, instruction: "Fill pot halfway with water.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 2, instruction_step: 2, instruction: "Place pot on stove and set to 'High' until boiling.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 2, instruction_step: 3, instruction: "Add pasta making sure to follow specific instructions on packaging.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 2, instruction_step: 4, instruction: "Fill pot halfway with water.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 2, instruction_step: 5, instruction: "Drain pasta in pot (refer to tips).")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 2, instruction_step: 6, instruction: "Add marinara sauce & pepperoni.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 2, instruction_step: 7, instruction: "Heat on medium-low until warm.")
RecipeInstruction.create!(recipe_id: @recipe3.id, cooking_style: 2, instruction_step: 8, instruction: "Serve & add parmesan cheese as desired.")


@recipe4 = Recipe.create!(name: "Chicken & Mushroom Alfredo Fettuccine Pasta", image: "future_image_of_alfredo_pasta", total_price: 8.00)
RecipeCookware.create!(recipe: @recipe4, cookware: @cookware4)
RecipeCookware.create!(recipe: @recipe4, cookware: @cookware5)
RecipeCookware.create!(recipe: @recipe4, cookware: @cookware7)
RecipeCookingTip.create!(recipe: @recipe4, tip: @tip2)

RecipeIngredient.create!(recipe_id: @recipe4.id ,ingredient_id: @ing12.id, measurement_id: @mes1.id, quantity: 0.5)
RecipeIngredient.create!(recipe_id: @recipe4.id ,ingredient_id: @ing13.id, measurement_id: @mes1.id, quantity: 1)
RecipeIngredient.create!(recipe_id: @recipe4.id ,ingredient_id: @ing14.id, measurement_id: @mes1.id, quantity: 0.5)
RecipeIngredient.create!(recipe_id: @recipe4.id ,ingredient_id: @ing15.id, measurement_id: @mes1.id, quantity: 1)

# Microwave Cooking Instructions
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 1, instruction_step: 1, instruction: "Put pasta in a microwave-safe bowl.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 1, instruction_step: 2, instruction: "Cover with water by at least 2 inches.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 1, instruction_step: 3, instruction: "Microwave on high for the time on the package plus a couple of extra minutes.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 1, instruction_step: 4, instruction: "Stir halfway through cooking to prevent sticking.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 1, instruction_step: 5, instruction: "Remove with hot pads or kitchen towel.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 1, instruction_step: 6, instruction: "Drain pasta.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 1, instruction_step: 7, instruction: "Open the cans of mushrooms & chicken & drain out excess liquid.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 1, instruction_step: 8, instruction: "Mix alfredo sauce, mushrooms, and chicken into pasta.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 1, instruction_step: 9, instruction: "Cover, and place back in the microwave for 1-2 minutes or until entire meal is warm.")

# Stovetop Cooking Instructions
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 2, instruction_step: 1, instruction: "Fill pot halfway with water.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 2, instruction_step: 2, instruction: "Place pot on stove and set to 'High' until boiling.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 2, instruction_step: 3, instruction: "Add pasta making sure to follow specific instructions on packaging.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 2, instruction_step: 4, instruction: "Fill pot halfway with water.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 2, instruction_step: 5, instruction: "Drain pasta in pot (refer to tips).")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 2, instruction_step: 6, instruction: "Open the cans of mushrooms & chicken & drain out excess liquid.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 2, instruction_step: 7, instruction: "Mix alfredo sauce, mushrooms, and chicken into pasta.")
RecipeInstruction.create!(recipe_id: @recipe4.id, cooking_style: 2, instruction_step: 8, instruction: "Heat on medium-low until warm.")
