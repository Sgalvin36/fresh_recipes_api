class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  validates :name presence: true, :national_price numericality: { greater_than: 0, only_float: true }
  # taxable?
  # snap?
  # Can't validate booleans, right?  Or is there another way to do it?  I can't remember right now.
end