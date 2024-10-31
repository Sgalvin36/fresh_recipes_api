require 'rails_helper'

RSpec.describe RecipeUtensil, type: :model do
  describe "relationships" do
    it { should belong_to :recipe }
    it { should belong_to :cooking_utensils }
  end
end