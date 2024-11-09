require "rails_helper"

RSpec.describe "Recipe controller", type: :request do
    before(:all) do
        RecipeIngredient.delete_all
        RecipeInstruction.delete_all
        Ingredient.delete_all
        Measurement.delete_all
        Recipe.delete_all
        @recipe1 = Recipe.create!(name:"Baked Potato", image:"future_image_of_potato", total_price:4.00, serving_size: 1)
        @ing1 = Ingredient.create!(name:"Potato", national_price:1.00, taxable:false, snap:true, kroger_id:"0001111050158")
        @ing2 = Ingredient.create!(name:"Cheddar cheese", national_price:2.00, taxable:false, snap:true, kroger_id:"0001111090593")
        @ing3 = Ingredient.create!(name:"Sour Cream", national_price:1.00, taxable:false, snap:true, kroger_id: "0000000004072")
        @mes1 = Measurement.create!(unit:"lb")
        @mes10 = Measurement.create!(unit:"ounces")
        @mes8 = Measurement.create!(unit:"tablespoons")
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
    end

    describe "GET all recipes Endpoint" do
        it "can make the request successfully" do
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            get api_v1_recipes_path
            expect(response).to be_successful
            json = JSON.parse(response.body, symbolize_names: true)

            expect(json).to have_key(:data)

            recipe_data = json[:data]
 
            expect(recipe_data[0][:id]).to eq(@recipe1.id)
            expect(recipe_data[0][:type]).to eq("recipe")
            expect(recipe_data[0][:attributes]).to be_a(Hash)

            attributes = recipe_data[0][:attributes]
            expect(attributes[:recipe_name]).to eq("Baked Potato")
            expect(attributes[:total_price]).to eq(4.0)
            expect(attributes[:image]).to eq("future_image_of_potato")
            expect(attributes[:serving_size]).to eq(1)
            expect(attributes[:ingredients]).to be_an(Array)

            expect(attributes[:ingredients].count).to eq(3)

            first_ingredient = attributes[:ingredients].first
            expect(first_ingredient).to have_key(:ingredient_id)
            expect(first_ingredient).to have_key(:ingredient)
            expect(first_ingredient).to have_key(:price)

            expect(first_ingredient[:ingredient_id]).to eq(@ing1.id)
            expect(first_ingredient[:ingredient]).to eq("Potato")
            expect(first_ingredient[:price]).to eq(1.0)
        end
    end

    describe "GET a single endpoint" do
        it "can make the request successfully" do
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            get api_v1_recipe_path(@recipe1)
            expect(response).to be_successful
            json = JSON.parse(response.body, symbolize_names: true)
            recipe_data = json[:data]

            expect(recipe_data[:id]).to eq(@recipe1.id)
            expect(recipe_data[:type]).to eq("recipe")
            expect(recipe_data[:attributes]).to be_a(Hash)

            attributes = recipe_data[:attributes]
            expect(attributes[:recipe_name]).to eq("Baked Potato")
            expect(attributes[:total_price]).to eq(4.0)
            expect(attributes[:image]).to eq("future_image_of_potato")
            expect(attributes[:serving_size]).to eq(1)

            expect(attributes[:ingredients]).to be_an(Array)
            expect(attributes[:ingredients].count).to eq(3)

            first_ingredient = attributes[:ingredients].first
            expect(first_ingredient[:ingredient]).to eq("Potato")
            expect(first_ingredient[:price]).to eq(1.0)
            expect(first_ingredient[:quantity]).to eq(1.0)
            expect(first_ingredient[:measurement]).to eq("lb")

            expect(attributes[:cookwares]).to be_an(Array)
            expect(attributes[:cookwares]).to be_empty

            expect(attributes[:instructions]).to be_an(Array)
            expect(attributes[:instructions].count).to eq(2) # 

            first_instruction_style = attributes[:instructions].first
            expect(first_instruction_style).to have_key(:cooking_style)
            expect(first_instruction_style[:cooking_style]).to eq(1)
            expect(first_instruction_style[:instructions]).to be_an(Array)

            first_instruction = first_instruction_style[:instructions].first
            expect(first_instruction[:instruction_step]).to eq(1)
            expect(first_instruction[:instruction]).to eq("Wash the dirt off the potato")

            expect(attributes[:cooking_tips]).to be_an(Array)
            expect(attributes[:cooking_tips]).to be_empty
        end

        it "updates the prices before finishing the request if a location is present", :vcr do
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }
            params = {
                id: @recipe1.id,
                by_location: 62000115
            }
            get api_v1_recipe_path(params)
            expect(response).to be_successful
            json = JSON.parse(response.body, symbolize_names: true)
        end

        it "returns an error for sad path" do
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }
            get api_v1_recipe_path(9999999999999999999999999)

            json = JSON.parse(response.body, symbolize_names: true)

            expect(response.status).to eq(404)

            expect(json).to have_key(:message)
            expect(json[:message]).to eq("Couldn't find Recipe with 'id'=9999999999999999999999999")
            expect(json).to have_key(:status)
            expect(json[:status]).to eq(404)
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