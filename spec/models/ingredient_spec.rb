require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe "relationships" do
    it { should have_many :recipe_ingredients }
    it { should have_many(:recipes).through(:recipe_ingredients) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:national_price).is_greater_than(0) }
    it { should validate_presence_of(:kroger_id) }
  end

  context "validating boolean values" do
    it 'validates taxable to be either true or false' do
      ingredient_true = Ingredient.new(name: "test_taxable", national_price: 10, taxable: true, snap: true, kroger_id: 32)
      ingredient_false = Ingredient.new(name: "test_taxable", national_price: 10, taxable: false, snap: true, kroger_id: 32)
      
      ingredient_nil = Ingredient.new(name: "test_taxable", national_price: 10, taxable: nil, snap: true)
      
      expect(ingredient_true).to be_valid
      expect(ingredient_false).to be_valid
      expect(ingredient_nil).not_to be_valid
      expect(ingredient_nil.errors[:taxable]).to include("is not included in the list")
    end

    it 'validates snap to be either true or false' do
      ingredient_true = Ingredient.new(name: "test_snap", national_price: 10, taxable: true, snap: true, kroger_id: 32)
      ingredient_false = Ingredient.new(name: "test_snap", national_price: 10, taxable: true, snap: false, kroger_id: 32)
      
      ingredient_nil = Ingredient.new(name: "test_snap", national_price: 10, taxable: true, snap: nil)
      
      expect(ingredient_true).to be_valid
      expect(ingredient_false).to be_valid
      expect(ingredient_nil).not_to be_valid
      expect(ingredient_nil.errors[:snap]).to include("is not included in the list")
    end
  end

  describe "model methods" do
    it "returns no more than 5 ingredients that match a partial query" do
      ingredient = Ingredient.create!(name:"American Cheese", national_price:4.32, taxable:true, snap:true, kroger_id: 32)
      ingredient2 = Ingredient.create!(name:"Bread", national_price:2.43, taxable:false, snap:true, kroger_id: 32)
      ingredient3 = Ingredient.create!(name:"Blue Cheese", national_price:6.32, taxable:true, snap:true, kroger_id: 32)
      ingredient4 = Ingredient.create!(name:"Hot Dogs", national_price:4.73, taxable:false, snap:true, kroger_id: 32)
      ingredient5 = Ingredient.create!(name:"French Cheese", national_price:4.32, taxable:true, snap:true, kroger_id: 32)
      ingredient6 = Ingredient.create!(name:"Red Cheese", national_price:2.43, taxable:false, snap:true, kroger_id: 32)
      ingredient7 = Ingredient.create!(name:"Green Cheese", national_price:6.32, taxable:true, snap:true, kroger_id: 32)
      ingredient8 = Ingredient.create!(name:"Cheese", national_price:4.73, taxable:false, snap:true, kroger_id: 32)

      result = Ingredient.filter_ingredients("cHeE")
      expected_result = [ingredient, ingredient3, ingredient5, ingredient7, ingredient8].sort_by(&:name)
      actual_result = result.sort_by(&:name)
    
      expect(actual_result).to eq(expected_result)    
    end

    it "updates total_price on associated recipes " do
      recipe_1 = Recipe.create!(name: "test_1", total_price: 0.00, image: "test_image_1.png", serving_size: 1)
      recipe_2 = Recipe.create!(name: "test_2", total_price: 0.00, image: "test_image_2.png", serving_size: 1)
      
      shared_ingredient = Ingredient.create!(name: "test_1", national_price: 1.00, taxable: false, snap: true, kroger_id: 32)
      unique_ingredient = Ingredient.create!(name: "test_2", national_price: 2.00, taxable: false, snap: true, kroger_id: 32)

      measurement = Measurement.create!(unit: "each")
      
      RecipeIngredient.create!(recipe: recipe_1, ingredient: shared_ingredient, quantity: 1, measurement: measurement)
      RecipeIngredient.create!(recipe: recipe_1, ingredient: unique_ingredient, quantity: 1, measurement: measurement)
      RecipeIngredient.create!(recipe: recipe_2, ingredient: shared_ingredient, quantity: 1, measurement: measurement)

      recipe_1.update_total_price
      recipe_2.update_total_price
      expect(recipe_1.total_price).to eq(3.00)
      expect(recipe_2.total_price).to eq(1.00)
      
      shared_ingredient.update(national_price: 11.00)
      
      recipe_1.update_total_price
      recipe_2.update_total_price
      expect(recipe_1.total_price).to eq(13.00)
      expect(recipe_2.total_price).to eq(11.00)
    end

    describe "find_or_create_ingredient" do
      it "finds ingredients that already exist" do
        ingredient_params = {productId: "12345", ingredient: 'Sugar', price: "3.75"}
      
        existing_ingredient = Ingredient.create!(
          name: "Flour",
          national_price: 2.50,
          kroger_id: "12345",
          taxable: true,
          snap: true
        )

        found_ingredient = Ingredient.find_or_create_ingredient(ingredient_params)
        expect(found_ingredient).to eq(existing_ingredient)
      end

      it "creates a new ingredient if it doesn't exist" do
        ingredient_params = {productId: "12345", ingredient: 'Sugar', price: "3.75"}
      
        expect {Ingredient.find_or_create_ingredient(ingredient_params)}.to change(Ingredient, :count).by(1)

        new_ingredient = Ingredient.find_by(kroger_id: "12345")
        
        expect(new_ingredient.name).to eq("Sugar")
        expect(new_ingredient.national_price).to eq(3.75)
        expect(new_ingredient.taxable).to be true
        expect(new_ingredient.snap).to be true
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

  describe '.fetch_kroger_data' do
    context 'when the request is successful' do
      it 'fetches product data with valid parameters', :vcr do
        search_params = "milk"
        location_id = 62000115
        
        result = Ingredient.fetch_kroger_data(search_params, location_id)

        
        expect(result).to be_an(Array)
        expect(result.first).to include(:product_ID, :description, :price)
      end
    end

    context 'when the request fails' do
      it 'raises an error on a failed response', :vcr do
        search_params = "nonexistent_product"  
        location_id = 62000115

        stub_request(:get, "https://api.kroger.com/v1/products")
          .with(query: hash_including("filter.term" => search_params, "filter.locationId" => location_id.to_s))
          .to_return(status: 404, body: { error: "Product not found" }.to_json)

        expect { Ingredient.fetch_kroger_data(search_params, location_id) }
          .to raise_error(RuntimeError, /Failed to fetch Kroger data/)
      end
    end
  end
end