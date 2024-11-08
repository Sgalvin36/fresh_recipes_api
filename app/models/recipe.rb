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
    return where("recipes.name ILIKE ?", "%#{search_params[:by_recipe]}%") if search_params[:by_recipe].present?
    return all
  end

  # Added distinct. Otherwise was returning duplicate recipe instances.
  def self.filter_by_ingredient(search_params)
    return joins(:ingredients).where("ingredients.name ILIKE ?", "%#{search_params[:by_ingredient]}%").distinct if search_params[:by_ingredient].present?
    return all
  end

  def self.filter_by_cooking_style(search_params)
    return joins(:recipe_instructions).where("cooking_style = ?", "#{search_params[:by_style]}").distinct if search_params[:by_style].present?
    return all
  end

  def self.filter_by_price(search_params)
    price = 5.0 if search_params[:by_price] == "0" || search_params[:by_price] == "1"
    price = 10.0 if search_params[:by_price] == "2" || search_params[:by_price] == "3"
    return where("recipes.total_price < ?", price) if search_params[:by_price] == "0" || search_params[:by_price] == "2"
    return where("recipes.total_price > ?", price) if search_params[:by_price] == "1" || search_params[:by_price] == "3"
    return all
  end

  def self.filter_by_serving(search_params)
    return where(serving_size: 1) if search_params[:by_serving] == 'Single'
    return where("serving_size > ?", 1) if search_params[:by_serving] == 'Multiple'
    return all
  end

  def fetch_update(ingredient_ids, location_id = 62000115)
    kroger_params = {
      "filter.locationId": location_id,
      "filter.productId": ingredient_ids
    }
  
    response = KrogerGateway.instance.fetch_data("products", kroger_params)
    if response.status == 200
      data = JSON.parse(response.body, symbolize_names: true)
      data[:data].map do |ingredient|
        {
          product_ID: ingredient[:productId],
          description: ingredient[:description],
          price: ingredient[:items][0][:price][:regular]
        }
      end
    else
      error_message = JSON.parse(response.body)['errors']['reason']
      raise "Failed to fetch Kroger data: #{error_message}"
    end
  end

  def update_ingredients_details(location_id)
    ingredient_ids = self.ingredients.map(&:kroger_id).sort()
    
    ingredient_id_string = ingredient_ids.join(", ")
    data = fetch_update(ingredient_id_string, location_id)
    ingredient_objects = self.ingredients.map do |ingredient|
      ingredient_data = data.find { |item| item[:product_ID] == ingredient.kroger_id }
      if ingredient_data.nil?
        puts "No data found for kroger_id: #{ingredient.kroger_id}"
        next
      end
      recipe_ingredient = ingredient.recipe_ingredients.find_by(recipe_id: self.id)
      {
        ingredient: ingredient.name,
        price: ingredient_data[:price],
        quantity: recipe_ingredient.quantity,
        measurement: recipe_ingredient.measurement.unit
      }
    end
    ingredient_objects
  end
end
