class RecipeCookingTip < ApplicationRecord
  belongs_to :recipe
  belongs_to :cooking_tip
end