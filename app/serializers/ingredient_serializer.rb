class IngredientSerializer
    include JSONAPI::Serializer
    attributes :name

    def self.kroger(ingredients)
        {data: ingredients}
    end
end