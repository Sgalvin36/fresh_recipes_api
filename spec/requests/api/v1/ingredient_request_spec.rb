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
    
        
            json = JSON.parse(response.body, symbolize_names:true)

            expect(json[:data].length).to eq 2
            json[:data].each do |ingredient|
                expect(ingredient).to have_key(:id)
                expect(ingredient[:attributes]).to have_key(:name)
            end
        end

        it "returns data that matches the parameter" do
            ingredient = Ingredient.create!(name:"American Cheese", national_price:4.32, taxable:true, snap:true)
            ingredient2 = Ingredient.create!(name:"Bread", national_price:2.43, taxable:false, snap:true)
            ingredient3 = Ingredient.create!(name:"Blue Cheese", national_price:6.32, taxable:true, snap:true)
            ingredient4 = Ingredient.create!(name:"Hot Dogs", national_price:4.73, taxable:false, snap:true)
            
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            params = {
                for_ingredient: "che"
            }

            get api_v1_ingredients_path(params)
            expect(response).to be_successful

            json = JSON.parse(response.body, symbolize_names:true)

            expect(json[:data].length).to eq 2
            json[:data].each do |ingredient|
                expect(["American Cheese", "Blue Cheese"]).to include(ingredient[:attributes][:name])
            end
        end

        it "returns a limit of 5 matches for search parameter" do
            ingredient = Ingredient.create!(name:"American Cheese", national_price:4.32, taxable:true, snap:true)
            ingredient2 = Ingredient.create!(name:"Bread", national_price:2.43, taxable:false, snap:true)
            ingredient3 = Ingredient.create!(name:"Blue Cheese", national_price:6.32, taxable:true, snap:true)
            ingredient4 = Ingredient.create!(name:"Hot Dogs", national_price:4.73, taxable:false, snap:true)
            ingredient5 = Ingredient.create!(name:"French Cheese", national_price:4.32, taxable:true, snap:true)
            ingredient6 = Ingredient.create!(name:"Red Cheese", national_price:2.43, taxable:false, snap:true)
            ingredient7 = Ingredient.create!(name:"Green Cheese", national_price:6.32, taxable:true, snap:true)
            ingredient8 = Ingredient.create!(name:"Cheese", national_price:4.73, taxable:false, snap:true)

            
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }

            params = {
                for_ingredient: "che"
            }

            get api_v1_ingredients_path(params)
            expect(response).to be_successful

            json = JSON.parse(response.body, symbolize_names:true)
            expect(json[:data].length).to eq 5
            json[:data].each do |ingredient|
                expect(["American Cheese", "Blue Cheese", "French Cheese", "Cheese", "Green Cheese" ]).to include(ingredient[:attributes][:name])
            end
        end
    end

    describe "GET ingredients fetched from kroger" do
        it "can make the request successfully", :vcr do
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }
            params = {
                for_dev: "tomato"
            }
            get api_v1_ingredients_path(params)
            expect(response).to be_successful
            data = JSON.parse(response.body, symbolize_names:true)
            expect(data[:data].length).to eq 10
            data[:data].each do |ingredient|
                expect(ingredient[:description]).to include("Tomato")
                expect(ingredient).to have_key(:price)
                expect(ingredient).to have_key(:product_ID)
                expect(ingredient[:price]).not_to be_nil
                expect(ingredient[:product_ID]).not_to be_nil
            end
        end

        it "can make the request successfully with more than one search word", :vcr do
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }
            params = {
                for_dev: "green onion"
            }
            KrogerGateway.instance.authorize_connection
            get api_v1_ingredients_path(params)
            expect(response).to be_successful
            data = JSON.parse(response.body, symbolize_names:true)
            expect(data[:data].length).to eq 10
            data[:data].each do |ingredient|
                expect(ingredient).to have_key(:price)
                expect(ingredient).to have_key(:product_ID)
                expect(ingredient[:price]).not_to be_nil
                expect(ingredient[:product_ID]).not_to be_nil
            end
        end
    end
end