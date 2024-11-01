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
end

# Could revisit and add `.dependent(:destroy)`
# We would want to make the dependency relate to the joins table instead of the parent table