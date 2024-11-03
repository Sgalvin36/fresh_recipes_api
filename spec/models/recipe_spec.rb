require 'rails_helper'

RSpec.describe Recipe, type: :model do
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
    it { should validate_numericality_of(:total_price).is_greater_than(0) }
    it { should validate_presence_of(:image) }
    it { should validate_uniqueness_of(:image) }
  end

  it "test get_ingredients_list" do
  end

  it "test update_total_price" do
    recipe_x = Recipe.create!(name: "test", total_price: 0.00, image: "test_image.png", serving_size: 1)
    ing1 = Ingredient.create!(name: "test1", national_price: 1.00, taxable: false, snap: true)
    ing2 = Ingredient.create!(name: "test2", national_price: 2.00, taxable: false, snap: true)
    ing3 = Ingredient.create!(name: "test3", national_price: 3.00, taxable: false, snap: true)
    measurement = Measurement.create!(unit: "each")

    RecipeIngredient.create!(recipe: recipe_x, ingredient: ing1, quantity: 1, measurement: measurement)
    RecipeIngredient.create!(recipe: recipe_x, ingredient: ing2, quantity: 1, measurement: measurement)
    RecipeIngredient.create!(recipe: recipe_x, ingredient: ing3, quantity: 1, measurement: measurement)

    recipe_x.update_total_price

    expect(recipe_x.total_price).to eq(6.00)
  end

  it "test filter_recipes" do
  end

  it "fiter_by_ingredients" do
  end
end

# Could revisit and add `.dependent(:destroy)`
# We would want to make the dependency relate to the joins table instead of the parent table