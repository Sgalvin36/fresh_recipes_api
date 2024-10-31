class User < ApplicationRecord
  it { should validate_the_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_the_presence_of(:key) }
  
  # Use this until we incorporate enums
  validates :role, inclusion: { in: [0, 1] }

  # For use with enums:
  # Model validation test for enums
# it { should define_enum_for(:role).with_values({ admin: 0, user: 1 }) }
end