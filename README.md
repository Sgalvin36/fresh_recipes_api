# Fresh Recipes API

This is a backend database that helps store recipes to include instructions, ingredients with links to grocery items that you can find in a nearby grocery store (currently only Kroger stores), cookware, cooking tips, and different styles of cooking. When given a store id it will update the prices to the current store so the recipe has the most up to date prices.

## About this Application

Viewing Party is an application that allows users to explore movies and create a Viewing Party Event that invites users and keeps track of a host. Once completed, this application will collect relevant information about movies from an external API, provide CRUD functionality for creating a Viewing Party and restrict its use to only verified users. 

## Setup

#### Versions
- Ruby: 3.2.2  
- Rails: 7.1.4.2


1. Fork and clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{drop,create,migrate}`

## Database Overview
Schema: 
```
  "cooking_tips", force: :cascade do |t|
    t.string "tip"
  end

  "cookware", force: :cascade do |t|
    t.string "name"
  end

  "ingredients", force: :cascade do |t|
    t.string "name"
    t.float "national_price"
    t.boolean "taxable"
    t.boolean "snap"
    t.string "kroger_id"
  end

  "measurements", force: :cascade do |t|
    t.string "unit"
  end

  "recipe_cooking_tips", force: :cascade do |t|
    t.bigint "cooking_tip_id", null: false
    t.bigint "recipe_id", null: false
    t.index ["cooking_tip_id"], name: "index_recipe_cooking_tips_on_cooking_tip_id"
    t.index ["recipe_id"], name: "index_recipe_cooking_tips_on_recipe_id"
  end

  create_table "recipe_cookwares", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "cookware_id", null: false
    t.index ["cookware_id"], name: "index_recipe_cookwares_on_cookware_id"
    t.index ["recipe_id"], name: "index_recipe_cookwares_on_recipe_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.bigint "measurement_id", null: false
    t.float "quantity"
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["measurement_id"], name: "index_recipe_ingredients_on_measurement_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipe_instructions", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.integer "cooking_style"
    t.string "instruction"
    t.integer "instruction_step"
    t.index ["recipe_id"], name: "index_recipe_instructions_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.float "total_price"
    t.string "image"
    t.integer "serving_size"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "role", default: 1
    t.string "key"
    t.string "password_digest"
    t.string "username"
    t.index ["key"], name: "index_users_on_key", unique: true
  end

  add_foreign_key "recipe_cooking_tips", "cooking_tips"
  add_foreign_key "recipe_cooking_tips", "recipes"
  add_foreign_key "recipe_cookwares", "cookware"
  add_foreign_key "recipe_cookwares", "recipes"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "measurements"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipe_instructions", "recipes"
end

```
The database should create 10 tables for you and is now ready to take in the required things for a recipe. Due to the interconnectedness of the database, designing a front end application that utilizes the functionality of the api to input recipes is advised.

## Testing the API
Utilizing RSpec, WebMock, and VCR, there is a wide array of built in tests to help troubleshoot your databases.
- Use `bundle exec rspec spec/...` to run rspec within the api

## Updating the external API access
You will need to delete the `credentials.yml.enc` and add in your own API keys. 
Run the command `EDITOR="code --wait" rails credentials:edit` which should open the credentials file for you to add in your own API key. From there, you will need to update the gateway file to the locations of your API keys.

# Endpoints


## Users
### Get all users
`GET /api/v1/users/` **No authentication needed** <br>
To find a list of top 20 highest rated movies.
### Parameters
No parameters needed outside of making the call to the endpoint.

### Finding Movies that match a Query
`GET /api/v1/movies/index` **No authentication needed** <br>
To find a list of movies that matches the search parameter.
#### Parameters
**"query"**: string, *required*
#### Example of Parameters
```
params = { "query": "Star Wars" }
```

### Getting detailed information on one Movie
`GET /api/v1/movies/:id` **No authentication needed** <br>
To find detailed information about a specific movie to include cast members and reviews of the movie.
#### Parameters
**"id"**: integer, *required*
#### Example of Parameters
```
params = { "id": 4 }
```

### Getting similar movies based of one Movie
`GET /api/v1/movies/:id` **No authentication needed** <br>
To find similar movies to the specific movie that is searched.
#### Parameters
**"id"**: integer, *required*
**"similar"**: boolean, *required*
#### Example of Parameters
```
params = { "id": 4, "similar": true }
```

## Viewing Party Endpoints
### Creating a Viewing Party
`POST /api/v1/viewing_parties` **Authentication needed and should be included in header** <br>
To create a viewing party and invite other users to be a part of the event.
#### Parameters
**"name"**: string, *required* <br>
**"start_time"**: string, *required* <br>
**"end_time"**: string, *required*<br>
**"movie_id"**: integer, *required*<br>
**"movie_title"**: string, *required*<br>
**"user_id"**: integer, *required*<br>
**"api_key"**: string, *required*<br>
**"users"**: array of user IDs, *required*<br>
#### Example of Parameters
```
params = {
    name: "Friends for ever and ever",
    start_time: "2025-05-01 10:00:00",
    end_time: "2025-05-01 14:30:00",
    movie_id: 456,
    movie_title: "Princess Bride",
    api_key: <API_KEY>,
    user_id: 413,
    users: [647, 925]
}
```

### Adding more Users to a Viewing Party
`PATCH` or `PUT /api/v1/viewing_parties/:id` **Authentication needed and should be included in header** <br>
To update the list of a viewing party and invite additional users.
#### Parameters
**"id"**: integer of party ID, *required* <br>
**"users"**: array of user IDs, *required* <br>
#### Example of Parameters
```
params = {
    "id": 4,
    "users": [3412, 7665]
    }
```

## User Endpoints
### Getting detailed User information
`GET /api/v1/users/:id` **Authentication needed and should be included in header** <br>
To get a detailed record of the current users activity to include viewing parties that they have hosted and the parties they have been invited to.
#### Parameters
**"id"**: integer of user ID, *required* <br>
#### Example of Parameters
```
params = { "id": 0 }
```
