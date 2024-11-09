require "rails_helper"

RSpec.describe "Users API", type: :request do
    describe "Create User Endpoint" do
        let(:user_params) do
            {
                name: "Me",
                username: "its_me",
                password: "QWERTY123",
                password_confirmation: "QWERTY123"
            }
        end

        context "request is valid" do
            it "returns 201 Created and provides expected fields" do
                post api_v1_users_path, params: user_params, as: :json

                expect(response).to have_http_status(:created)
                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:data][:type]).to eq("user")
                expect(json[:data][:id]).to eq(User.last.id.to_s)
                expect(json[:data][:attributes][:name]).to eq(user_params[:name])
                expect(json[:data][:attributes][:username]).to eq(user_params[:username])
                expect(json[:data][:attributes]).to have_key(:key)
                expect(json[:data][:attributes]).to_not have_key(:password)
                expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
            end
        end

        context "request is invalid" do
            it "returns an error for non-unique username" do
                User.create!(name: "me", username: "its_me", password: "abc123")

                post api_v1_users_path, params: user_params, as: :json
                json = JSON.parse(response.body, symbolize_names: true)

                expect(response).to have_http_status(:bad_request)
                expect(json[:message]).to eq("Username has already been taken")
                expect(json[:status]).to eq(400)
            end

            it "returns an error when password does not match password confirmation" do
                user_params = {
                name: "me",
                username: "its_me",
                password: "QWERTY123",
                password_confirmation: "QWERT123"
                }

                post api_v1_users_path, params: user_params, as: :json
                json = JSON.parse(response.body, symbolize_names: true)

                expect(response).to have_http_status(:bad_request)
                expect(json[:message]).to eq("Password confirmation doesn't match Password")
                expect(json[:status]).to eq(400)
            end

            it "returns an error for missing field" do
                user_params[:username] = ""

                post api_v1_users_path, params: user_params, as: :json
                json = JSON.parse(response.body, symbolize_names: true)

                expect(response).to have_http_status(:bad_request)
                expect(json[:message]).to eq("Username can't be blank")
                expect(json[:status]).to eq(400)
            end
        end
    end
end

RSpec.describe Api::V1::UsersController, type: :controller do
    describe "GET #index" do
        before do
            @user1 = User.create!(name:"Fred", username:"Fred-E", password:"pass123")
            @user2 = User.create!(name:"Freddy", username:"Freed-Fred", password:"pass321")
            @user3 = User.create!(name:"Frank", username:"Feed-Frank", password:"ImHungry")
        end
        it "returns a list of users" do
            get :index

            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq("application/json; charset=utf-8") 
            data = JSON.parse(response.body, symbolize_names:true)

            expect(data[:data].length).to eq(3)
        end
    end

    describe "GET #show" do
        it "returns a single users" do
            user1 = User.create!(name:"Fred", username:"Fred-E", password:"pass123")

            request.headers["Authorization"] = user1.key
            get :show, params: {id: user1.id}
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq("application/json; charset=utf-8") 
            data = JSON.parse(response.body, symbolize_names:true)

            expect(data[:data][:id].to_i).to eq(user1.id)
            expect(data[:data][:type]).to eq("user")
            expect(data[:data][:attributes][:name]).to eq(user1.name)
            expect(data[:data][:attributes][:username]).to eq(user1.username)
        end

        it "returns an error message if its not the right user" do
            user1 = User.create!(name:"Fred", username:"Fred-E", password:"pass123")
            user2 = User.create!(name:"Freddy", username:"Freed-Fred", password:"pass321")
            request.headers["Authorization"] = user1.key
            get :show, params: {id: user2.id}

            expect(response.status).to eq(401)
            data = JSON.parse(response.body, symbolize_names:true)
            expect(data[:message]).to eq("Not the user.")
        end
    end
end