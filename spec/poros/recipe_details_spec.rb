require 'rails_helper'

RSpec.describe RecipeDetails do
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
    
    it "can initialize" do

    end

    it "can get ingredients" do
        details = RecipeDetails.new({id: 2, name: "Steve", image:"Thisone", serving_size:3})
        all_ingredients = details.get_ingredients(@recipe1.id)
        
        expect(all_ingredients.length).to eq 3
        expect(all_ingredients).to be_a(Array)

    end

    it "can get the total price" do
        details = RecipeDetails.new({id: 2, name: "Steve", image:"Thisone", serving_size:3})
        all_ingredients = details.get_ingredients(@recipe1.id)
        total = details.get_total_price(@recipe1.id)
        expect(total).to eq 4.0
    end

    it "can get cookware" do
    end

    it "can get instructions" do
        details = RecipeDetails.new({id: 2, name: "Steve", image:"Thisone", serving_size:3})
        all_instructions = details.get_instructions(@recipe1.id)
        expect(all_instructions.length).to eq 2
        expect(all_instructions[0][:cooking_style]).to eq 1
        expect(all_instructions[0][:instructions].length).to eq 4
        expect(all_instructions[1][:cooking_style]).to eq 2
        expect(all_instructions[1][:instructions].length).to eq 5

    end

    it "can get cooking tips" do
    end

    after(:all) do
        RecipeIngredient.delete_all
        RecipeInstruction.delete_all
        Ingredient.delete_all
        Measurement.delete_all
        Recipe.delete_all
    end
end