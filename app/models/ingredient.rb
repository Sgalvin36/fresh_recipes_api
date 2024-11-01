class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true
  validates :national_price, numericality: { greater_than: 0, only_float: true }
  # I'm pretty sure this is the correct way to validate these last two ingredient attributes.
  # validates :taxable, inclusion: { in: [true, false] }
  # validates :snap, inclusion: { in: [true, false] }
end