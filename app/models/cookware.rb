class Cookware < ApplicationRecord
  has_many :recipe_cookware
  has_many :recipes, through: :recipe_cookware

  validates :name presence: true
end