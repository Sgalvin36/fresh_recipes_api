class RecipeInstruction < ApplicationRecord
  belongs_to :recipe

  validates :instruction, presence: true
  validates :cooking_style, presence: true
end