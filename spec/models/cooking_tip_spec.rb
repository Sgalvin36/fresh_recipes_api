require 'rails_helper'

RSpec.describe CookingTip, type: :model do
  describe "relationships" do
    it { should have_many :recipe_cooking_tips }
    it { should have_many(:recipes).through(:recipe_cooking_tips) }
  end
end