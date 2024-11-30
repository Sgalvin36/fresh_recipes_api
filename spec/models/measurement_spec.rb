require 'rails_helper'

RSpec.describe Measurement, type: :model do
  describe "relationships" do
    it { should have_many :recipe_ingredients }
    it { should have_many(:recipes).through(:recipe_ingredients) }
  end

  describe "validations" do
    it { should validate_presence_of(:unit) }
    it { should validate_uniqueness_of(:unit)}
  end

  describe "#find_or_create" do
    it "creates a new entry in table if param is not present in table" do
      existing_measurement = Measurement.create!(unit: 'cup')
      count = Measurement.all.count
      result = Measurement.find_or_create('cups')
      count2 = Measurement.all.count

      expect(result).to_not eq(existing_measurement)   
      expect(result.id).to_not eq(existing_measurement.id)     
      expect(count).to_not eq(count2)
    end

    it "does not create a new entry in table if param is found" do
      existing_measurement = Measurement.create!(unit: 'cup')
      count = Measurement.all.count
      result = Measurement.find_or_create('cup')
      count2 = Measurement.all.count

      expect(result).to eq(existing_measurement)    
      expect(result.id).to eq(existing_measurement.id)    
      expect(count).to eq(count2)
    end

    it "does not create a new entry in table if param is found regardless of capitilzation" do
      existing_measurement = Measurement.create!(unit: 'cup')
      count = Measurement.all.count
      result = Measurement.find_or_create('Cup')
      count2 = Measurement.all.count

      expect(result).to eq(existing_measurement)
      expect(result.id).to eq(existing_measurement.id)    
      expect(count).to eq(count2)
    end
  end
end