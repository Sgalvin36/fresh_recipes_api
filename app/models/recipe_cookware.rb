class RecipeCookware < ApplicationRecord
  belongs_to :recipe
  belongs_to :cookware
end