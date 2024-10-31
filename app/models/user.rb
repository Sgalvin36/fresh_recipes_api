class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :role, presence: true, numericality: true
  validates :key, presence: true

  # Use this until we incorporate enums
  validates :role, inclusion: { in: [0, 1] }

  # For use with enums:
  # enum role: { admin: 0, user: 1 }
end