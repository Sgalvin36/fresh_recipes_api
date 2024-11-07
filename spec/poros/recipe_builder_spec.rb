require 'rails_helper'

RSpec.describe RecipeBuilder, type: :model do
    before(:all) do
        RecipeIngredient.delete_all
        RecipeInstruction.delete_all
        RecipeCookingTip.delete_all
        RecipeCookware.delete_all
        Cookware.delete_all
        Ingredient.delete_all
        Measurement.delete_all
        Recipe.delete_all
    end
    let(:user_params) do
        {
            "name": "Baked Potato1",
            "serving_size": "1",
            "image_url": "unknown1",
            "cooking_tips": [
                {
                    "tip": "Poking holes in the potato allows steam to escape, if you don't the potato could explode, especially in the microwave!"
                }
            ],
            "cookware": [
                {
                    "cookware": "Microwave-Safe Baking Dish"
                },
                {
                    "cookware": "Oven-Safe Baking Dish"
                }
            ],
            "ingredients": [
                {
                    "quantity": "1",
                    "measurement": "each",
                    "ingredient": "Russet Potato",
                    "price": 0.89,
                    "productId": "0000000004072"
                },
                {
                    "quantity": "1",
                    "measurement": "Tablespoon",
                    "ingredient": "Kroger® Spreadable Butter With Olive Oil & Sea Salt",
                    "price": 3.99,
                    "productId": "0001111090593"
                },
                {
                    "quantity": "2",
                    "measurement": "Tablespoons",
                    "ingredient": "Kroger® Sharp Cheddar Shredded Cheese",
                    "price": 2.49,
                    "productId": "0001111050158"
                }
            ],
            "instructions": [
                {
                    "cookingStyle": "1",
                    "step": "1",
                    "instruction": "Wash the dirt off the potato"
                },
                {
                    "cookingStyle": "1",
                    "step": "2",
                    "instruction": "Poke holes in the potato to allow steam to escape"
                },
                {
                    "cookingStyle": "1",
                    "step": "3",
                    "instruction": "Put on plate in microwave and cook for 8 minutes"
                },
                {
                    "cookingStyle": "1",
                    "step": "4",
                    "instruction": "If a fork is easily pushed in, its done, otherwise cook for an additional 2 minutes"
                },
                {
                    "cookingStyle": "3",
                    "step": "2",
                    "instruction": "Wash the dirt off the potato"
                },
                {
                    "cookingStyle": "3",
                    "step": "3",
                    "instruction": "Poke holes in the potato to allow steam to escape"
                },
                {
                    "cookingStyle": "3",
                    "step": "4",
                    "instruction": "Place potato on oven safe tray and cook for 45 minutes"
                },
                {
                    "cookingStyle": "3",
                    "step": "5",
                    "instruction": "If a fork is easily pushed in, its done, otherwise cook for an additional 10 minutes"
                },
                {
                    "cookingStyle": "3",
                    "step": "1",
                    "instruction": "Preheat oven to 400 degrees"
                }
            ]
        }
    end

    let (:update_params) do
        {
            "name": "Baked Potato12",
            "serving_size": "2",
            "image_url": "unknown3",
            "cooking_tips": [
                {
                    "tip": "Poking holes in the potato allows steam to escape, if you don't the potato could explode, especially in the microwave!"
                },
                {
                    "tip": "Rubbing it with an oil will allow the skin to crisp while cooking!"
                }
            ],
            "cookware": [
                {
                    "cookware": "Microwave-Safe Baking Dish"
                },
                {
                    "cookware": "Oven-Safe Baking Dish"
                }
            ],
            "ingredients": [
                {
                    "quantity": "2",
                    "measurement": "each",
                    "ingredient": "Russet Potato",
                    "price": 2.89,
                    "productId": "0000000004072"
                },
                {
                    "quantity": "1",
                    "measurement": "Tablespoon",
                    "ingredient": "Kroger® Spreadable Butter With Olive Oil & Sea Salt",
                    "price": 4.99,
                    "productId": "0001111090593"
                },
                {
                    "quantity": "2",
                    "measurement": "Tablespoons",
                    "ingredient": "Kroger® Sharp Cheddar Shredded Cheese",
                    "price": 1.49,
                    "productId": "0001111050158"
                }
            ],
            "instructions": [
                {
                    "cookingStyle": "1",
                    "step": "1",
                    "instruction": "Wash the dirt off the potato"
                },
                {
                    "cookingStyle": "1",
                    "step": "2",
                    "instruction": "Poke holes in the potato to allow steam to escape. CAREFUL: This requires some effort, and coordination, don't stab your hand"
                },
                {
                    "cookingStyle": "1",
                    "step": "3",
                    "instruction": "Put on plate in microwave and cook for 8 minutes"
                },
                {
                    "cookingStyle": "1",
                    "step": "4",
                    "instruction": "If a fork is easily pushed in, its done, otherwise cook for an additional 2 minutes"
                },
                {
                    "cookingStyle": "3",
                    "step": "2",
                    "instruction": "Wash the dirt off the potato"
                },
                {
                    "cookingStyle": "3",
                    "step": "3",
                    "instruction": "Poke holes in the potato to allow steam to escape"
                },
                {
                    "cookingStyle": "3",
                    "step": "4",
                    "instruction": "Place potato on oven safe tray and cook for 45 minutes"
                },
                {
                    "cookingStyle": "3",
                    "step": "5",
                    "instruction": "If a fork is easily pushed in, its done, otherwise cook for an additional 10 minutes"
                },
                {
                    "cookingStyle": "3",
                    "step": "1",
                    "instruction": "Preheat oven to 400 degrees"
                }
            ]
        }
    end

    let(:recipe_builder) { RecipeBuilder.new(user_params) }
    let(:update_builder) { RecipeBuilder.new(update_params)}

    describe "#call" do
        it "creates a new recipe and associated records" do
        expect { recipe_builder.call }.to change { Recipe.count }.by(1)
        recipe = Recipe.last

        expect(recipe.ingredients.count).to eq(3)
        expect(recipe.cookware.count).to eq(2)
        expect(recipe.cooking_tips.count).to eq(1)
        expect(recipe.recipe_instructions.count).to eq(9)
        end

        it "calculates and updates the recipe's total price" do
        recipe_builder.call
        recipe = Recipe.last

        expected_price = 0.89 + 3.99 + 2.49
        expect(recipe.total_price).to eq(expected_price)
        end
    end

    describe "#update_call" do
        it "updates existing recipe and associated records" do
            recipe_builder.call
            recipe = Recipe.last
            # binding.pry
            update_builder.update_call(recipe)
            updated_recipe = Recipe.find(recipe.id)
            expect {
                update_builder.update_call(recipe)
            }.not_to change { Recipe.count }
            
            expect(updated_recipe.ingredients.count).to eq(3)
            expect(updated_recipe.cookware.count).to eq(2)
            expect(updated_recipe.cooking_tips.count).to eq(2)
            expect(updated_recipe.recipe_instructions.count).to eq(10)
        end

        it "updates the recipe's total price after updating ingredients" do
            recipe_builder.call
            recipe = Recipe.last

            update_builder.update_call(recipe)
            updated_recipe = Recipe.find(recipe.id)

            expected_price = 2.89 + 4.99 + 1.49
            expect(updated_recipe.total_price).to eq(expected_price)
        end

        it "only updates specific attributes when partial data is provided" do
            recipe_builder.call
            recipe = Recipe.last
            updated_params = update_params.except(:instructions, :cookware, :cooking_tips)
            recipe_builder_with_partial_params = RecipeBuilder.new(updated_params)

            recipe_builder_with_partial_params.update_call(recipe)
            updated_recipe = Recipe.find(recipe.id)
            # updated_recipe.recipe_instructions.reload

            expected_price = 2.89 + 4.99 + 1.49

            expect(updated_recipe.recipe_instructions.count).to eq(9)
            expect(updated_recipe.ingredients.count).to eq(3) 
            expect(updated_recipe.cookware.count).to eq(2) 
            expect(updated_recipe.cooking_tips.count).to eq(1)
            expect(updated_recipe.total_price).to eq(expected_price)
        end
    end
end
