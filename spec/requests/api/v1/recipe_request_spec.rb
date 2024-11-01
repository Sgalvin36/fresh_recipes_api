require "rails_helper"

RSpec.describe "Recipe controller", type: :request do
    describe "GET all recipes Endpoint" do
        xit "can make the request successfully" do
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            get api_v1_recipes_path
            expect(response).to be_successful
        end

        xit "can return the data as requested" do
            recipe = Recipe.new()

            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            get api_v1_recipes_path
            expect(response).to be_successful
        
        end
    end
end