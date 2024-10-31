require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe "relationships" do
    it { should have_many :recipe_ingredients }
    it { should have_many :recipe_instructions }
    it { should have_many :recipe_utensils }
    it { should have_many :recipe_cooking_tips }
    it { should have_many(:ingredients).through(:recipe_ingredients) }
    it { should have_many(:measurements).through(:recipe_ingredients) }
    it { should have_many(:cooking_utensils).through(:recipe_utensils) }
    it { should have_many(:cooking_tips).through(:recipe_cooking_tips) }
  end
end