class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipe_instructions
  has_many :recipe_cookware
  has_many :recipe_cooking_tips
  
  has_many :ingredients, through: :recipe_ingredients
  has_many :measurements, through: :recipe_ingredients
  has_many :cookware, through: :recipe_cookware
  has_many :cooking_tips, through: :recipe_cooking_tips

  validates :name, presence: true, uniqueness: true
  validates :total_price, numericality: { greater_than: 0, only_float: true }
  validates :image, presence: true, uniqueness: true

  def get_ingredient_list
    ingredients = []
    self.recipe_ingredients.each do |rec_ingr|
      build_data = {
      ingredient_id: rec_ingr.ingredient.id,  
      ingredient: rec_ingr.ingredient.name,
      price: rec_ingr.ingredient.national_price
      }
      ingredients.push(build_data)
    end
    ingredients
  end

  def self.filter_recipes(search_params)
    return Recipe.where("name ILIKE ?", "%#{search_params}%")
  end

  def self.filter_by_ingredient(search_params)
    return Recipe.joins(:ingredients).where("ingredient ILIKE ?", "%#{search_params}%")
  end
end

# Could revisit and add `.dependent(:destroy)`
# We would want to make the dependency relate to the joins table instead of the parent table