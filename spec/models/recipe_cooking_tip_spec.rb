require 'rails_helper'

RSpec.describe RecipeCookingTip, type: :model do
  describe "relationships" do
    it { should belong_to :recipe }
    it { should belong_to :cooking_tip }
  end
end