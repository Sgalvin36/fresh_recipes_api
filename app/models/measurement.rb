class Measurement < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  validates :unit, presence: true, uniqueness: true

  def self.find_or_create(unit)
    find_by("LOWER(unit) = ?", unit.downcase) || create!(unit: unit)
  end
end