class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipe_instructions, dependent: :destroy
  has_many :recipe_utensils, dependent: :destroy
  has_many :recipe_cooking_tips, dependent: :destroy
  
  has_many :ingredients, through: :recipe_ingredients
  has_many :measurements, through: :recipe_ingredients
  has_many :cooking_utensils, through: :recipe_utensils
  has_many :cooking_tips, through: :recipe_cooking_tips
end