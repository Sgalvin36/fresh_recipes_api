require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  describe "relationships" do
    it { should belong_to :recipe }
    it { should belong_to :ingredient }
    it { should belong_to :measurement }
  end

  describe "validations" do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end
end