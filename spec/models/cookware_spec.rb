require 'rails_helper'

RSpec.describe Cookware, type: :model do
  describe "relationships" do
    it { should have_many :recipe_cookware }
    it { should have_many(:recipes).through(:recipe_cookware) }
  end
end