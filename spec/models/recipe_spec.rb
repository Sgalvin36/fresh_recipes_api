require 'rails_helper'

RSpec.describe Recipe, type: :model do
  before(:each) do
    @recipe1 = Recipe.create!(name: "Spaghetti", image: "spaghetti.png", total_price: 4.00, serving_size: 2)
    @recipe2 = Recipe.create!(name: "Meatball Spaghetti", image: "meatball_spaghetti.png", total_price: 5.00, serving_size: 4)
    @recipe3 = Recipe.create!(name: "Cup of Dirt", image: "cup_of_dirt.png", total_price: 10.00, serving_size: 1)
    @recipe4 = Recipe.create!(name: "Salad", image: "salad.png", total_price: 12.00, serving_size: 1)
    @recipe5 = Recipe.create!(name: "Fruit Salad", image: "fruit_salad.png", total_price: 13.00, serving_size: 1)

    

    # Ingredient data for testing filter by ingredients
    @ingredient1 = Ingredient.create!(name: "Tomato", national_price: 1.00, taxable: false, snap: true)
    @ingredient2 = Ingredient.create!(name: "Mozzarella Cheese", national_price: 2.00, taxable: false, snap: true)
    @ingredient3 = Ingredient.create!(name: "Cheddar Cheese", national_price: 0.50, taxable: false, snap: true)

    @measurement = Measurement.create!(unit: "each")

    RecipeIngredient.create!(recipe: @recipe1, ingredient: @ingredient1, quantity: 1, measurement: @measurement)
    RecipeIngredient.create!(recipe: @recipe1, ingredient: @ingredient2, quantity: 1, measurement: @measurement)
    RecipeIngredient.create!(recipe: @recipe1, ingredient: @ingredient3, quantity: 1, measurement: @measurement)
    RecipeIngredient.create!(recipe: @recipe2, ingredient: @ingredient2, quantity: 1, measurement: @measurement)

    # Instructions data for testing filter by cooking style
    RecipeInstruction.create!(recipe: @recipe1, cooking_style: 3, instruction_step: 1, instruction: "Bake for 1 hour at 400°F")
    RecipeInstruction.create!(recipe: @recipe2, cooking_style: 1, instruction_step: 1, instruction: "Microwave for 5 minutes on high")
  end

  describe "relationships" do
    it { should have_many(:recipe_ingredients) }
    it { should have_many(:recipe_instructions) }
    it { should have_many(:recipe_cookware) }
    it { should have_many(:recipe_cooking_tips) }

    it { should have_many(:ingredients).through(:recipe_ingredients) }
    it { should have_many(:measurements).through(:recipe_ingredients) }
    it { should have_many(:cookware).through(:recipe_cookware) }
    it { should have_many(:cooking_tips).through(:recipe_cooking_tips) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:image) }
    it { should validate_uniqueness_of(:image) }
    it { should validate_numericality_of(:serving_size).is_greater_than_or_equal_to(0) }
  end

  describe "model methods" do
    it "test get_ingredients_list" do
      ingredients = @recipe1.get_ingredient_list

      expect(ingredients.length).to eq(3)
      expect(ingredients).to be_an(Array)
      expect(ingredients.first[:ingredient]).to eq("Tomato")
    end
    
    it "test update_total_price" do
      recipe_x = Recipe.create!(name: "test", total_price: 0.00, image: "test_image.png", serving_size: 1)
      ing1 = Ingredient.create!(name: "test1", national_price: 1.00, taxable: false, snap: true)
      ing2 = Ingredient.create!(name: "test2", national_price: 2.00, taxable: false, snap: true)
      ing3 = Ingredient.create!(name: "test3", national_price: 3.00, taxable: false, snap: true)
      measurement = Measurement.create!(unit: "ounce")
      
      RecipeIngredient.create!(recipe: recipe_x, ingredient: ing1, quantity: 1, measurement: measurement)
      RecipeIngredient.create!(recipe: recipe_x, ingredient: ing2, quantity: 1, measurement: measurement)
      RecipeIngredient.create!(recipe: recipe_x, ingredient: ing3, quantity: 1, measurement: measurement)
      
      recipe_x.update_total_price
      
      expect(recipe_x.total_price).to eq(6.00)
    end
    
    it "test filter_recipes" do
      search_params = {
        by_recipe: "sP"
      }
      result = Recipe.filter_recipes(search_params)
      result_2 = Recipe.filter_recipes({})
    
      expect(result.length).to eq(2)
      expect(result.last.name).to eq("Meatball Spaghetti")

      expect(result_2.length).to eq(5)
      expect(result_2.last.name).to eq("Fruit Salad")
    end

    it "returns all if filter_recipes parameter isn't present" do
      result = Recipe.filter_recipes({})
      expect(result.length).to eq(5)
    end
    
    it "fiter_by_ingredients" do
      search_params = {
        by_ingredient: "cHeE"
      }
      result = Recipe.filter_by_ingredient(search_params)

      expect(result.length).to eq(2)
      expect(result.last.name).to eq("Meatball Spaghetti")
    end

    it "returns all if filter_ingredient parameter isn't present" do
      result = Recipe.filter_by_ingredient({})
      expect(result.length).to eq(5)
    end
    
    it "test filter_by_cooking_style" do
      search_params = {
        by_style: "3"
      }
      search_params2 = {
        by_style: "1"
      }
      result = Recipe.filter_by_cooking_style(search_params)
      result_2 = Recipe.filter_by_cooking_style(search_params2)

      expect(result.length).to eq(1)
      expect(result.last.name).to eq("Spaghetti")
      
      expect(result_2.length).to eq(1)      
      expect(result_2.last.name).to eq("Meatball Spaghetti")
    end

    it "returns all if filter_by_cooking_style parameter isn't present" do
      result = Recipe.filter_by_cooking_style({})
      expect(result.length).to eq(5)
    end
    
    it "filter_by_price" do
      search_params = {
        by_price: "0"
      }
      result_0 = Recipe.filter_by_price(search_params)
      search_params = {
        by_price: "1"
      }
      result_1 = Recipe.filter_by_price(search_params)
      search_params = {
        by_price: "2"
      }
      result_2 = Recipe.filter_by_price(search_params)
      search_params = {
        by_price: "3"
      }
      result_3 = Recipe.filter_by_price(search_params)

      expect(result_0.length).to eq(1)
      expect(result_1.length).to eq(3)
      expect(result_2.length).to eq(2)
      expect(result_3.length).to eq(2)
    end

    it "returns all if filter_by_price parameter isn't present" do
      result = Recipe.filter_by_price({})
      expect(result.length).to eq(5)
    end
    
    it "filter_by_serving_size" do
      search_params = {
        by_serving: "Single"
      }
      result_1 = Recipe.filter_by_serving(search_params)
      search_params = {
        by_serving: "Multiple"
      }
      result_2 = Recipe.filter_by_serving(search_params)

      expect(result_1.length).to eq(3)
      expect(result_1.last.name).to eq("Fruit Salad")
      
      expect(result_2.length).to eq(2)
      expect(result_2.last.name).to eq("Meatball Spaghetti")
    end

    it "returns all if filter_by_serving parameter isn't present" do
      result = Recipe.filter_by_serving({})
      expect(result.length).to eq(5)
    end
  end

  describe '.fetch_update' do
    let(:ingredient_ids) { "0001111050158, 0001111090593, 0000000004072"}
    let(:location_id) { 62000115 }

    it 'fetches and returns data from Kroger API', :vcr do
      VCR.use_cassette('kroger/fetch_update') do
        result = @recipe1.fetch_update(ingredient_ids, location_id)

        expect(result).to be_an(Array)
        expect(result.first).to include(:product_ID, :description, :price)
      end
    end

    context 'when the response status is not 200' do
      it 'raises an error', :vcr do
        VCR.use_cassette('kroger/fetch_update_error') do
          expect {
            @recipe1.fetch_update(ingredient_ids, 999999) # Using an invalid location ID for error simulation
          }.to raise_error("Failed to fetch Kroger data: Field 'locationId' must have a length of 8 alphanumeric characters")
        end
      end
    end
  end

  describe "#update_ingredients_details" do
    let(:location_id) { 62000115 }

    before do
      RecipeIngredient.delete_all
      RecipeInstruction.delete_all
      Ingredient.delete_all
      Measurement.delete_all
      Recipe.delete_all
      @recipe1 = Recipe.create!(name:"Baked Potato", image:"future_image_of_potato", total_price:4.00, serving_size: 1)
      @ing1 = Ingredient.create!(name:"Potato", national_price:1.00, taxable:false, snap:true, kroger_id:"0001111050158")
      @ing2 = Ingredient.create!(name:"Cheddar cheese", national_price:2.00, taxable:false, snap:true, kroger_id:"0001111090593")
      @ing3 = Ingredient.create!(name:"Sour Cream", national_price:1.00, taxable:false, snap:true, kroger_id:"0000000004072")
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

    context "when the API responds with valid data" do
      it "returns a list of ingredients with updated details" do
        VCR.use_cassette("recipe_update_ingredients_details_success") do
          result = @recipe1.update_ingredients_details(location_id)
          
          expect(result).to be_an(Array)
          expect(result.size).to eq(3)
          
          result.each do |ingredient_detail|
            expect(ingredient_detail[:ingredient]).to be_present
            expect(ingredient_detail[:price]).to be_present
            expect(ingredient_detail[:quantity]).to be_present
            expect(ingredient_detail[:measurement]).to be_present
          end
        end
      end
    end

    context "when the API does not return data for a kroger_id" do
      before do
        allow_any_instance_of(Recipe).to receive(:fetch_update).and_return([
          { product_ID: "0001111050158", description: "Potato", price: 1.99 },
          { product_ID: "0001111090593", description: "Cheddar cheese", price: 4.99 }
        ])
      end

      it "logs missing data and skips that ingredient" do
        VCR.use_cassette("recipe_update_ingredients_details_missing_data") do
          expect { @recipe1.update_ingredients_details(location_id) }
            .to output(/No data found for kroger_id: 0000000004072/).to_stdout
          
          result = @recipe1.update_ingredients_details(location_id)
          expect(result).to be_an(Array)
          expect(result.size).to eq(3) 

          expect(result[0][:ingredient]).to eq("Potato")
          expect(result[0][:price]).to eq(1.99)
          expect(result[1][:ingredient]).to eq("Cheddar cheese")
          expect(result[1][:price]).to eq(4.99)
        end
      end
    end
  end
end