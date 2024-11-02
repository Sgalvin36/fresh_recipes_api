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
end