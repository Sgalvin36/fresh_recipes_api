require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:key) }
  end

  describe "validations" do
    # Use this until we incorporate enums
    it { should validate_inclusion_of(:role).in_array([0, 1]) }
    
    # For use with enums:
    # Model validation test for enums
    # it { should define_enum_for(:role).with_values({ admin: 0, user: 1 }) }
  end
end