require 'rails_helper'

RSpec.describe RecipeInstruction, type: :model do
  describe "relationships" do
    it { should belong_to :recipe }
  end

  describe "validations" do
    it { should validate_presence_of(:cooking_style) }
  end
end