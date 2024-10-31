require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe "relationships" do
    it { should have_many(:recipe_ingredients).dependent(:destroy) }
    it { should have_many(:recipe_instructions).dependent(:destroy) }
    it { should have_many(:recipe_cookware).dependent(:destroy) }
    it { should have_many(:recipe_cooking_tips).dependent(:destroy) }

    it { should have_many(:ingredients).through(:recipe_ingredients) }
    it { should have_many(:measurements).through(:recipe_ingredients) }
    it { should have_many(:cookware).through(:recipe_cookware) }
    it { should have_many(:cooking_tips).through(:recipe_cooking_tips) }
  end
end

# We need to add tests here to demonstrate how the top four are dependent upon their assocation and will delete their dependents.
  # (One test per association.)

  # EXAMPLE

  # describe "dependent: :destroy behavior" do
  #   it "destroys associated recipe_ingredients when recipe is deleted" do
  #     recipe = Recipe.create!(recipe_name: "Test Recipe")
  #     ingredient = recipe.recipe_ingredients.create!(quantity: 1)

  #     expect { recipe.destroy }.to change { RecipeIngredient.count }.by(-1)
  #   end