class CookingTip < ApplicationRecord
  has_many :recipe_cooking_tips
  has_many :recipes, through: :recipe_cooking_tips
end