class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  belongs_to :measurement

  validates :quantity, numericality: { greater_than: 0 }
end