require 'rails_helper'

RSpec.describe RecipeCookware, type: :model do
  describe "relationships" do
    it { should belong_to :recipe }
    it { should belong_to :cookware }
  end
end