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

## Recipes
### Get all recipes
`GET /api/v1/recipes/` **No authentication needed** <br>
To retrieve all the users in your user base. It will return only  the username and the name of the user.
### Parameters
**"by_recipe"**: |string| Will filter the recipes based off of the titles of the recipes <br>

**"by_ingredient"**: |string| Will filter the recipes looking for ingredients that match the provided parameter <br>\
**"by_style"**: |string| Accepts four different options <br>
 Each of these styles are searchable and will return all recipes that have the searched for cooking style
 - 0 : No cooking style
 - 1 : Microwave
 - 2 : Stovetop
 - 3 : Oven/ Toaster Oven <br>

**"by_price"**: |string| Accepts three different options <br>
 Each recipe will have a total price based off the price of the ingredients that make up the recipe, this filter will search through the recipes and return the ones that total fit the search parameter. <br>
 - "0" : Less then $5
 - "2" : Less than $10
 - "3" : More than $10 <br>

**"by_serving"**: |string| Accepts two different options <br>
 Each recipe is designed around serving size as well to allow for even more customized filtering.
 - "Single" : Serves 1
 - "Multiple" : Serves more than one <br>
#### Example of Parameters
```
params = { 
    "by_price": "2",
    "by_serving": "Single",
    "by_cooking_style": "2",
    "by_ingredient": "toMato",
    "by_recipe": "Soup"
     }
```

### Get one recipe
`GET /api/v1/recipes/:id` **No authentication needed** <br>
To retrieve one recipe from the database. It will return all the information of the recipe to include instructions, cookware, and cooking tips.
### Parameters
**"by_location"**: |string| This allows the user to generate the recipe details with the additional call to the provided grocery store location which will first update the prices before relaying the entire recipe to the user. <br>
#### Example of Parameters
```
params = { 
    "by_location": "59302144"
    }
```
## Ingredients 
### Get all ingredients
`GET /api/v1/ingredients/` **No authentication needed** <br>
An endpoint that will retrieve all the ingredients that are stored in the database.

### Parameters
**"for_ingredient"**: |string| Accepts the parameter and returns ingredients that meet the search query. It is part of the function for the recipes filter by ingredient.  <br>

**"for_dev"**: |string| Accepts the parameter and makes a call to the external API to gather relavent data about the search parameter and returns all products that match the search query. Helps the creation of recipes by fetching the store ids, prices, and store recognized names of ingredients. <br> 
#### Example of Parameters
```
params = { "for_ingredient": "tomato }
```
```
params = { "for_dev": "potato }
```

## Recipe Builder
### Create Recipe
`POST /api/v1/recipe_builders` **Authentication needed** <br>
This allows the qualified user to submit recipes to the database. A user needs to have a generated id, and the necessary role to submit the recipe.
### Parameters
**"name"**: |string| *required*<br>

**"serving_size"**: |integer| *required*<br>

**"image_url"**: |string| *required*<br>

**"ingredients"**: |array| *required*<br>
In the ingredients array, it is looking for an object built with several parameters
- **"quantity"**: |integer| *required*

- **"measurement"**: |string| *required* 
  - *Used to define the quantity (tsp, Tbls, cup, etc.)*
- **"ingredient"**: |string| *required*
  - *The name of the ingredient, ideally retrieved from the external API using the Ingredients endpoing (:for_dev)*
- **"price"**: |string| *required*
  - *The price of the ingredient, ideally retrieved from the external API using the Ingredients endpoing (:for_dev)*
- **"productID"**: |string| *required*
  - *The store specific ID of the ingredient, ideally retrieved from the external API using the Ingredients endpoing (:for_dev)*

**"instructions"**: |array| *required*<br>
In the instructions array, it is looking for an object built with several parameters.
- **"cookingStyle"**: |integer| *required*

- **"step"**: |integer| *required* 
  - *Used to establish the step per cooking style*
- **"instruction"**: |string| *required*

**"cookware"**: |array| <br>
In the cookware array, it is looking for an object containing the key of `cookware` and the value of the associate cookware.

**"cooking_tips"**: |array| <br>
In the cooking_tips array, it is looking for an object containing the key of `cookware` and the value of the associate cookware.

<br> 
#### Example of Parameters
```
    params = {
        name: "Baked Beans",
        serving_size: 1,
        image_url: "link to image",
        ingredients: [
            { 
                quantity: 2,
                measurement: "Tablespoons",
                ingredient: "Brown Sugar",
                price: 2.45,
                productID: "34295523"
            },
            {
                quantity: ...
            }
        ],
        instructions: [
            {
                cookingStyle: "2",
                step: "1",
                instruction: "Open can of beans
            },
            {
                cookingStyle: "2",
                step: "2",
                ...
            }
        ],
        cookware: [
            { cookware: "pot"},
            { cookware: "spoon"}
        ],
        cooking_tips: [
            { tip: "Edge of lid can be sharp when opening, be care not to cut yourself."},
            { tip: "Beans will be very hot after cooked"}
        ]
    }
```
## Users
### Get all users
`GET /api/v1/users/` **No authentication needed** <br>
To retrieve all the users in your user base. It will return only  the username and the name of the user.
### Parameters
No parameters needed outside of making the call to the endpoint.

### Get one user
`GET /api/v1/users/:id` **No authentication needed** <br>
To revieve one users info. 
### Parameters
**"id"**: string, *required*
#### Example of Parameters
```
params = { "id": 123 }
```

### Create a new user
`POST /api/v1/users/` **No authentication needed** <br>
To add a user to the database. It will store the password as a hash and automatically create a key for the user that can be used in other controllers.  
### Parameters
**"name"**: string, *required* <br>

**"username"**: string, *required* <br>

**"password"**: string, *required* <br>
#### Example of Parameters
```
params = { 
    "name": "Seth", 
    "username":"SeththeSith", 
    "password": "Pass123" 
    }
```

## Sessions
### Create a new session
`POST /api/v1/sessions/` **Option to provide persistant authentication** <br>
This allows a user to create a session token that can be utilized in other parts of the application.
### Parameters
**"username"**: string, *required* <br>

**"password"**: string, *required*
#### Example of Parameters
```
params = { 
    "username":"SeththeSith", 
    "password": "Pass123" 
    }
```

## Locations
### Get locational data
`POST /api/v1/users/` **No authentication needed** <br>
This makes a call to an external API that will return locations that are within range of the provided coordinates.
### Parameters
**"lat"**: string, *required* Latitude coordinates <br>

**"long"**: string, *required* Longitude coordinates
#### Example of Parameters
```
params = { 
    "lat":"40.7128", 
    "long": "74.0060" 
    }
```