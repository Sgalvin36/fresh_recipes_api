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
  validates :total_price, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :image, presence: true, uniqueness: true
  validates :serving_size, numericality: { greater_than_or_equal_to: 0 }

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

  def update_total_price 
    total = self.ingredients.sum("national_price") 
    update(total_price: total)
  end

  def self.filter_recipes(search_params)
    return where("recipes.name ILIKE ?", "%#{search_params}%") if search_params.present?
    return all
  end

  def self.filter_by_ingredient(search_params)
    return joins(:ingredients).where("ingredients.name ILIKE ?", "%#{search_params}%") if search_params.present?
    return all
  end

  def self.filter_by_cooking_style(search_params)
    return joins(:recipe_instructions).where("cooking_style = ?", "#{search_params}").distinct if search_params.present?
    return all
  end

  def self.filter_by_price(search_params)
    price = 5.0 if search_params == "0" || search_params == "1"
    price = 10.0 if search_params == "2" || search_params == "3"
    # binding.pry
    return where("recipes.total_price < ?", price) if search_params == "0" || search_params == "2"
    return where("recipes.total_price > ?", price) if search_params == "1" || search_params == "3"
    return all
  end

  def self.filter_by_serving(search_params)
    return where("serving_size = ?", "#{search_params}") if search_params.present?
    return all
  end
end

# Could revisit and add `.dependent(:destroy)`
# We would want to make the dependency relate to the joins table instead of the parent table