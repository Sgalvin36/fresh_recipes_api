require 'rails_helper'

RSpec.describe CookingUtensil, type: :model do
  describe "relationships" do
    it { should have_many :recipe_utensils }
    it { should have_many(:recipes).through(:recipe_utensils) }
  end
end