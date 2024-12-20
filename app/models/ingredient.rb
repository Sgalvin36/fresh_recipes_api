class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true
  validates :national_price, numericality: { greater_than: 0, only_float: true }
  validates :taxable, inclusion: { in: [true, false] }
  validates :snap, inclusion: { in: [true, false] }
  validates :kroger_id, presence: true
  
  after_save :update_associated_recipes_total_price, if: :saved_change_to_national_price?

  def self.find_or_create_ingredient(ingredient)
    find_or_create_by(kroger_id: ingredient[:productId]) do |ing|
      ing.name = ingredient[:ingredient]
      ing.national_price = ingredient[:price].to_f
      ing.taxable = true
      ing.snap = true
    end
  end

  def self.filter_ingredients(search_params)
      return Ingredient.select("DISTINCT ON (name) *").where("name ILIKE ?", "%#{search_params}%").limit(5)
  end


  def update_associated_recipes_total_price 
    recipes.each(&:update_total_price) 
  end

  def self.fetch_kroger_data(search_params, location_id = 62000115)
    kroger_params = {
      "filter.locationId": location_id,
      "filter.term": search_params
    }
  
    response = KrogerGateway.instance.fetch_data("products", kroger_params)
    if response.status == 200
      data = JSON.parse(response.body, symbolize_names: true)
      data[:data].map do |ingredient|
        {
          product_ID: ingredient[:productId],
          description: ingredient[:description],
          price: ingredient.dig(:items, 0, :price, :regular) || 0.00
        }
      end
    else
      raise "Failed to fetch Kroger data: #{response.body}"
    end
  end
end