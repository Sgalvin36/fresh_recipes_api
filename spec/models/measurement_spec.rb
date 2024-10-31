require 'rails_helper'

RSpec.describe Measurement, type: :model do
  describe "relationships" do
    it { should have_many :recipe_ingredients }
    it { should have_many(:recipes).through(:recipe_ingredients) }
  end
end