require "rails_helper"

RSpec.describe "Ingredient controller", type: :request do
    describe "GET all ingredients Endpoint" do
        it "can make the request successfully" do
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            get api_v1_ingredients_path
            expect(response).to be_successful
        end

        it "can return the data as requested" do
            ingredient = Ingredient.create!(name:"American Cheese", national_price:4.32, taxable:true, snap:true)
            ingredient2 = Ingredient.create!(name:"Bread", national_price:2.43, taxable:false, snap:true)
            
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            get api_v1_ingredients_path
            expect(response).to be_successful
            # binding.pry
        
            json = JSON.parse(response.body, symbolize_names:true)
            json[:data].each do |ingredient|
                expect(ingredient).to have_key(:id)
                expect(ingredient[:attributes]).to have_key(:name)
            end
        end
    end
end