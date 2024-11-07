require 'rails_helper'

RSpec.describe RecipeDetails do
    before(:all) do
        RecipeIngredient.delete_all
        RecipeInstruction.delete_all
        RecipeCookingTip.delete_all
        RecipeCookware.delete_all
        Cookware.delete_all
        Ingredient.delete_all
        Measurement.delete_all
        Recipe.delete_all
        @recipe1 = Recipe.create!(name:"Baked Potato", image:"future_image_of_potato", total_price:4.00, serving_size: 3)
        @ing1 = Ingredient.create!(name:"Potato", national_price:1.00, taxable:false, snap:true)
        @ing2 = Ingredient.create!(name:"Cheddar cheese", national_price:2.00, taxable:false, snap:true)
        @ing3 = Ingredient.create!(name:"Sour Cream", national_price:1.00, taxable:false, snap:true)
        @mes1 = Measurement.create!(unit:"lb")
        @mes10 = Measurement.create!(unit:"ounces")
        @mes8 = Measurement.create!(unit:"tablespoons")
        @cookware_1 = Cookware.create!(name: "cookware_test_1")
        @cookware_2 = Cookware.create!(name: "cookware_test_2")
        @cookware_3 = Cookware.create!(name: "cookware_test_3")
        @cooking_tip_1 = CookingTip.create!(tip: "Just")
        @cooking_tip_2 = CookingTip.create!(tip: "The")
        @cooking_tip_3 = CookingTip.create!(tip: "Tip")
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
        RecipeCookware.create!(recipe_id: @recipe1.id, cookware_id: @cookware_1.id)
        RecipeCookware.create!(recipe_id: @recipe1.id, cookware_id: @cookware_2.id)
        RecipeCookware.create!(recipe_id: @recipe1.id, cookware_id: @cookware_3.id)
        RecipeCookingTip.create!(recipe_id: @recipe1.id, cooking_tip_id: @cooking_tip_1.id)
        RecipeCookingTip.create!(recipe_id: @recipe1.id, cooking_tip_id: @cooking_tip_2.id)
        RecipeCookingTip.create!(recipe_id: @recipe1.id, cooking_tip_id: @cooking_tip_3.id)
    end
    
    it "can initialize" do
        details = RecipeDetails.new(@recipe1)

        expect(details).to be_an_instance_of(RecipeDetails)
        expect(details.id).to eq(@recipe1.id)
        expect(details.name).to eq("Baked Potato")
        expect(details.image).to eq("future_image_of_potato")
        expect(details.serving_size).to eq(3)
    end

    it "can get ingredients" do
        details = RecipeDetails.new(@recipe1)
        all_ingredients = details.ingredients
        expect(all_ingredients.length).to eq 3
        expect(all_ingredients).to be_an(Array)
    end

    it "can get the total price" do
        details = RecipeDetails.new(@recipe1)
        total = details.total_price

        expect(total).to eq 4.0
    end

    it "can get cookware" do
        details = RecipeDetails.new(@recipe1)
        all_cookware = details.cookwares

        expect(all_cookware.length).to eq(3)
        expect(all_cookware).to be_an(Array)
    end

    it "can get instructions" do
        details = RecipeDetails.new(@recipe1)
        all_instructions = details.instructions

        expect(all_instructions.length).to eq 2
        expect(all_instructions[0][:cooking_style]).to eq 1
        expect(all_instructions[0][:instructions].length).to eq 4
        expect(all_instructions[1][:cooking_style]).to eq 2
        expect(all_instructions[1][:instructions].length).to eq 5
    end

    it "can get cooking tips" do
        details = RecipeDetails.new(@recipe1)
        all_cooking_tips = details.cooking_tips

        expect(all_cooking_tips.length).to eq(3)
        expect(all_cooking_tips).to be_an(Array)
    end

    after(:all) do
        RecipeIngredient.delete_all
        RecipeInstruction.delete_all
        RecipeCookingTip.delete_all
        RecipeCookware.delete_all
        Cookware.delete_all
        Ingredient.delete_all
        Measurement.delete_all
        Recipe.delete_all
    end
end
