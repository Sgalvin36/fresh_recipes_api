require 'rails_helper'

RSpec.describe Api::V1::RecipeBuildersController, type: :controller do
  let(:user) { User.create(name:"Fred", username: "Freddie", password: "pass1234") }
  let(:valid_attributes) do
    {
        "name": "Baked Potato1",
        "serving_size": "1",
        "image_url": "unknown1",
        "cooking_tips": [
            {
                "tip": "Poking holes in the potato allows steam to escape, if you don't the potato could explode, especially in the microwave!"
            }
        ],
        "cookware": [
            {
                "cookware": "Microwave-Safe Baking Dish"
            },
            {
                "cookware": "Oven-Safe Baking Dish"
            }
        ],
        "ingredients": [
            {
                "quantity": "1",
                "measurement": "each",
                "ingredient": "Russet Potato",
                "price": 0.89,
                "productId": "0000000004072"
            },
            {
                "quantity": "1",
                "measurement": "Tablespoon",
                "ingredient": "Kroger® Spreadable Butter With Olive Oil & Sea Salt",
                "price": 3.99,
                "productId": "0001111090593"
            },
            {
                "quantity": "2",
                "measurement": "Tablespoons",
                "ingredient": "Kroger® Sharp Cheddar Shredded Cheese",
                "price": 2.49,
                "productId": "0001111050158"
            }
        ],
        "instructions": [
            {
                "cookingStyle": "1",
                "step": "1",
                "instruction": "Wash the dirt off the potato"
            },
            {
                "cookingStyle": "1",
                "step": "2",
                "instruction": "Poke holes in the potato to allow steam to escape"
            },
            {
                "cookingStyle": "1",
                "step": "3",
                "instruction": "Put on plate in microwave and cook for 8 minutes"
            },
            {
                "cookingStyle": "1",
                "step": "4",
                "instruction": "If a fork is easily pushed in, its done, otherwise cook for an additional 2 minutes"
            },
            {
                "cookingStyle": "3",
                "step": "2",
                "instruction": "Wash the dirt off the potato"
            },
            {
                "cookingStyle": "3",
                "step": "3",
                "instruction": "Poke holes in the potato to allow steam to escape"
            },
            {
                "cookingStyle": "3",
                "step": "4",
                "instruction": "Place potato on oven safe tray and cook for 45 minutes"
            },
            {
                "cookingStyle": "3",
                "step": "5",
                "instruction": "If a fork is easily pushed in, its done, otherwise cook for an additional 10 minutes"
            },
            {
                "cookingStyle": "3",
                "step": "1",
                "instruction": "Preheat oven to 400 degrees"
            }
        ]
    }
  end

  let(:invalid_attributes) do
    {
        name: '',
        serving_size: -1,
        image_url: '',
        ingredients: [],
        instructions: [],
        cookware: [],
        cooking_tips: []
    }
  end

  let(:valid_attributes_without_cookware_and_tips) { valid_attributes.except(:cookware, :cooking_tips) }

  before do
    request.headers["Authorization"] = "#{user.key}"
  end

  describe 'POST #create' do
    context 'when valid attributes are provided' do
      it 'creates a new recipe and returns a success message' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.body).to include('Recipe created successfully')
      end
    end

    context 'when required valid attributes are provided but not optional' do
      it 'creates a new recipe and returns a success message' do
        post :create, params: valid_attributes_without_cookware_and_tips
        expect(response).to have_http_status(:created)
        expect(response.body).to include('Recipe created successfully')
      end
    end

    context 'when invalid attributes are provided' do
      it 'does not create a recipe and returns an error message' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("\"error\":\"Validation failed: Name can't be blank, Image can't be blank, Serving size must be greater than or equal to 0\"")

      end
    end

    context 'when an ActiveRecord::RecordInvalid exception is raised' do
      before do
        allow_any_instance_of(RecipeBuilder).to receive(:call).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'returns a validation error message' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('error')
      end
    end
  end

  describe 'PUT #update' do
    before do
        post :create, params: valid_attributes
        @recipe = Recipe.last
    end

    context 'when valid attributes are provided' do
      it 'updates the recipe and returns a success message' do
        put :update, params: valid_attributes.merge(id: @recipe.id)
        expect(response).to have_http_status(:created)
        expect(response.body).to include('Recipe updated successfully')
      end
    end

    context 'when invalid attributes are provided' do
      it 'does not update the recipe and returns an error message' do
        put :update, params: invalid_attributes.merge(id: @recipe.id)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Recipe update failed')
      end
    end

    context 'when an ActiveRecord::RecordInvalid exception is raised' do
      before do
        allow_any_instance_of(RecipeBuilder).to receive(:update_call).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'returns a validation error message' do
        put :update, params: valid_attributes.merge(id: @recipe.id)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("\"error\":\"Record invalid\"")
      end
    end
  end
end
