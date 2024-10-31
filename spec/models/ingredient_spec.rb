require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe "relationships" do
    it { should have_many :recipe_ingredients }
    it { should have_many(:recipes).through(:recipe_ingredients) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    # it { should validate_numericality_of(:price).is_greater_than(0).only_integer(false) }
    # it { should validate_inclusion_of(:taxable).in_array([true, false]) }
    # it { should validate_inclusion_of(:snap).in_array([true, false]) }
  end
end