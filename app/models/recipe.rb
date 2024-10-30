class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipe_instructions
  has_many :recipe_utensils
  has_many :recipe_cooking_tips
  has_many :ingredients, through: :recipe_ingredients
  has_many :measurements, through: :recipe_ingredients
  has_many :cooking_utensils, through: :recipe_utensils
  has_many :cooking_tips, through: :recipe_cooking_tips
end