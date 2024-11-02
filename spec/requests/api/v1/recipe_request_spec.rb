require "rails_helper"

RSpec.describe "Recipe controller", type: :request do
    before(:all) do
        @recipe1 = Recipe.create!(name:"Baked Potato", image:"future_image_of_potato", total_price:4.00)
        @ing1 = Ingredient.create!(name:"Potato", national_price:1.00, taxable:false, snap:true)
        @ing2 = Ingredient.create!(name:"Cheddar cheese", national_price:2.00, taxable:false, snap:true)
        @ing3 = Ingredient.create!(name:"Sour Cream", national_price:1.00, taxable:false, snap:true)
        @mes1 = Measurement.create!(unit:"lb")
        @mes10 = Measurement.create!(unit:"ounces")
        @mes8 = Measurement.create!(unit:"tablespoons")
        RecipeIngredient.create!(recipe_id:@recipe1.id ,ingredient_id:@ing1.id, measurement_id:@mes1.id, quantity:1)
        RecipeIngredient.create!(recipe_id:@recipe1.id ,ingredient_id:@ing2.id, measurement_id:@mes10.id, quantity:2)
        RecipeIngredient.create!(recipe_id:@recipe1.id ,ingredient_id:@ing3.id, measurement_id:@mes8.id, quantity:2)
        # RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:1, instruction_step: 1,instruction:"Wash the dirt off the potato")
        # RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:1, instruction_step: 2,instruction:"Poke holes in the potato to allow steam to escape")
        # RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:1, instruction_step: 3,instruction:"Put on plate in microwave and cook for 8 minutes")
        # RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:1, instruction_step: 4,instruction:"If a fork is easily pushed in, its done, otherwise cook for an additional 2 minutes")
        # RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 1,instruction:"Preheat oven to 400 degrees")
        # RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 2,instruction:"Wash the dirt off the potato")
        # RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 3,instruction:"Poke holes in the potato to allow steam to escape")
        # RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 4,instruction:"Place potato on oven safe tray and cook for 45 minutes")
        # RecipeInstruction.create!(recipe_id:@recipe1.id, cooking_style:2, instruction_step: 5,instruction:"If a fork is easily pushed in, its done, otherwise cook for an additional 2 minutes")

        @recipe1 = Recipe.create!(name:"Baked Cheesey Sandwich", image:"future_image_of_cheese_pull", total_price:6.00)
        @ing1 = Ingredient.create!(name:"Bread", national_price:3.00, taxable:false, snap:true)
        @ing2 = Ingredient.create!(name:"Cheddar cheese", national_price:2.00, taxable:false, snap:true)
        @ing3 = Ingredient.create!(name:"Butter", national_price:1.00, taxable:false, snap:true)
        @mes1 = Measurement.create!(unit:"each")
        @mes10 = Measurement.create!(unit:"ounces")
        @mes8 = Measurement.create!(unit:"tablespoons")
        RecipeIngredient.create!(recipe_id:@recipe1.id ,ingredient_id:@ing1.id, measurement_id:@mes1.id, quantity:1)
        RecipeIngredient.create!(recipe_id:@recipe1.id ,ingredient_id:@ing2.id, measurement_id:@mes10.id, quantity:2)
        RecipeIngredient.create!(recipe_id:@recipe1.id ,ingredient_id:@ing3.id, measurement_id:@mes8.id, quantity:2)
    end

    describe "GET all recipes Endpoint" do
        it "can make the request successfully" do
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            get api_v1_recipes_path
            expect(response).to be_successful
        end

        it "can return the data as requested" do
            recipe = Recipe.new()

            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            get api_v1_recipes_path
            expect(response).to be_successful

            json = JSON.parse(response.body, symbolize_names: true)
            binding.pry
        end
    end

    after(:all) do
        RecipeIngredient.delete_all
        RecipeInstruction.delete_all
        Ingredient.delete_all
        Measurement.delete_all
        Recipe.delete_all
    end
end