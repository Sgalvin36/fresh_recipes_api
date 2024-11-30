require 'rails_helper'

RSpec.describe Cookware, type: :model do
  describe "relationships" do
    it { should have_many :recipe_cookware }
    it { should have_many(:recipes).through(:recipe_cookware) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "find_or_create_cookware" do
    it "finds cookware that already exist" do
      cookware_params = { cookware: "Frying Pan"}

      existing_cookware = Cookware.create!(name: "Frying Pan")

      found_cookware = Cookware.find_or_create_cookware(cookware_params)

      expect(found_cookware).to eq(existing_cookware)
    end

    it "create cookware that isn't in the database" do
      cookware_params = { cookware: "Frying Pan"}

      expect {Cookware.find_or_create_cookware(cookware_params)}.to change(Cookware, :count).by(1)

      new_cookware = Cookware.find_by(name: "Frying Pan")

      expect(new_cookware.name).to eq("Frying Pan")
    end

    it "finds cookware regardless of capitalization" do
      cookware_params = { cookware: "frying pan"}
      Cookware.create!(name: "Frying Pan")

      found_cookware = Cookware.find_or_create_cookware(cookware_params)

      expect(found_cookware.name).to eq("Frying Pan")
    end
  end
end