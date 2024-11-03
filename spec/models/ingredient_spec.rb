require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe "relationships" do
    it { should have_many :recipe_ingredients }
    it { should have_many(:recipes).through(:recipe_ingredients) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:national_price).is_greater_than(0) }
    # UNCOMMENT ONCE SEEDED INGREDIENT DATA CONTAINS LIVE kroger_id ATTRIBUTES
    # it { should validate_presence_of(:kroger_id) }
  end

  context "validating boolean values" do
    it 'validates taxable to be either true or false' do
      ingredient_true = Ingredient.new(name: "test_taxable", national_price: 10, taxable: true, snap: true)
      ingredient_false = Ingredient.new(name: "test_taxable", national_price: 10, taxable: false, snap: true)
      
      ingredient_nil = Ingredient.new(name: "test_taxable", national_price: 10, taxable: nil, snap: true)
      
      expect(ingredient_true).to be_valid
      expect(ingredient_false).to be_valid
      expect(ingredient_nil).not_to be_valid
      expect(ingredient_nil.errors[:taxable]).to include("is not included in the list")
    end

    it 'validates snap to be either true or false' do
      ingredient_true = Ingredient.new(name: "test_snap", national_price: 10, taxable: true, snap: true)
      ingredient_false = Ingredient.new(name: "test_snap", national_price: 10, taxable: true, snap: false)
      
      ingredient_nil = Ingredient.new(name: "test_snap", national_price: 10, taxable: true, snap: nil)
      
      expect(ingredient_true).to be_valid
      expect(ingredient_false).to be_valid
      expect(ingredient_nil).not_to be_valid
      expect(ingredient_nil.errors[:snap]).to include("is not included in the list")
    end
  end

  describe "model methods" do
    it "returns no more than 5 ingredients that match a partial query" do
      ingredient = Ingredient.create!(name:"American Cheese", national_price:4.32, taxable:true, snap:true)
      ingredient2 = Ingredient.create!(name:"Bread", national_price:2.43, taxable:false, snap:true)
      ingredient3 = Ingredient.create!(name:"Blue Cheese", national_price:6.32, taxable:true, snap:true)
      ingredient4 = Ingredient.create!(name:"Hot Dogs", national_price:4.73, taxable:false, snap:true)
      ingredient5 = Ingredient.create!(name:"French Cheese", national_price:4.32, taxable:true, snap:true)
      ingredient6 = Ingredient.create!(name:"Red Cheese", national_price:2.43, taxable:false, snap:true)
      ingredient7 = Ingredient.create!(name:"Green Cheese", national_price:6.32, taxable:true, snap:true)
      ingredient8 = Ingredient.create!(name:"Cheese", national_price:4.73, taxable:false, snap:true)

      expect(Ingredient.filter_ingredients("che")).to eq([ingredient, ingredient3, ingredient5, ingredient6, ingredient7])
    end

    it "updates total_price on associated recipes " do
      recipe_1 = Recipe.create!(name: "test_1", total_price: 0.00, image: "test_image_1.png", serving_size: 1)
      recipe_2 = Recipe.create!(name: "test_2", total_price: 0.00, image: "test_image_2.png", serving_size: 1)
      
      shared_ingredient = Ingredient.create!(name: "test_1", national_price: 1.00, taxable: false, snap: true)
      unique_ingredient = Ingredient.create!(name: "test_2", national_price: 2.00, taxable: false, snap: true)

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

    after(:all) do
      RecipeIngredient.delete_all
      RecipeInstruction.delete_all
      Ingredient.delete_all
      Measurement.delete_all
      Recipe.delete_all
    end
  end
end