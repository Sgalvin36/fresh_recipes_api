class RecipeUtensil < ApplicationRecord
  belongs_to :recipe
  belongs_to :cooking_utensils
end