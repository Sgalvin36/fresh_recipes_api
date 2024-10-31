class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipe_instructions, dependent: :destroy
  has_many :cookware, dependent: :destroy
  has_many :recipe_cooking_tips, dependent: :destroy
  
  has_many :ingredients, through: :recipe_ingredients
  has_many :measurements, through: :recipe_ingredients
  has_many :cookware, through: :recipe_cookware
  has_many :cooking_tips, through: :recipe_cooking_tips

  validates :name, presence: true, uniqueness: true
  validates :total_price, numericality: { greater_than: 0, only_float: true }
  validates :image, presence: true  #Would we add uniqueness here as well?
end

# Update all recipe stuff to include serving attribute