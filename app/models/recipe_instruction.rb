class RecipeInstruction < ApplicationRecord
  belongs_to :recipe

  validates instruction: presence, true, cooking_style: presence, true
end