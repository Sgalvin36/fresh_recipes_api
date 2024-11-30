class Cookware < ApplicationRecord
  has_many :recipe_cookware
  has_many :recipes, through: :recipe_cookware

  validates :name, presence: true

  def self.find_or_create_cookware(cookware)
    find_by("LOWER(name) = ?", cookware[:cookware].downcase) || create!(name:cookware[:cookware])
  end
end