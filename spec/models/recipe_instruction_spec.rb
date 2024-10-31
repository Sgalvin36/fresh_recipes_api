require 'rails_helper'

RSpec.describe RecipeInstruction, type: :model do
  describe "relationships" do
    it { should belong_to :recipe }
  end
end