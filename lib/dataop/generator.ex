defmodule DataOp.Generator do
  @moduledoc "Generate test data."

  @restaurant_names [
    "the-restaurant-at-the-end-of-the-universe",
    "johnnys-cashew-stand",
    "bean-juice-stand",
    "the-ice-cream-parlor"
  ]

  @food_names [
    "beans",
    "cashews",
    "chips",
    "chocolate",
    "coffee",
    "cookies",
    "corn",
    "candy",
    "cereal",
    "chicken",
    "cheese",
    "eggs",
    "fish",
    "fruit",
    "grains",
    "honey",
    "ice cream",
    "juice",
    "milk",
    "meat",
    "nuts",
    "oil",
    "pasta",
    "rice",
    "salad",
    "sandwiches",
    "soup",
    "spices",
    "sugar",
    "tea",
    "vegetables",
    "water",
    "wine",
    "yogurt"
  ]

  @food_cost [
    1.00,
    1.50,
    2.00,
    2.50,
    3.00,
    3.50,
    4.00,
    4.50,
    5.00,
    5.50,
    6.00,
    6.50,
    7.00,
    7.50,
    8.00,
    8.50,
    9.00
  ]

  @first_names [
    "Aaron",
    "Barbara",
    "Cameron",
    "Dagmar",
    "Earl",
    "Fabian",
    "Gabe",
    "Hadley",
    "Ian",
    "Jabari",
    "Kacey",
    "Lambert",
    "Mabel",
    "Nadia",
    "Obie",
    "Pablo",
    "Queen",
    "Rachael",
    "Sabina",
    "Tabitha",
    "Ubaldo",
    "Vada",
    "Wade",
    "Xavier",
    "Yvonne",
    "Zachary"
  ]

  @headers ["restaurant_names", "food_names", "first_name", "food_cost"]

  def run do
    opts = [separator: ?,, escape_character: ?|, headers: @headers]

    Stream.repeatedly(fn ->
      %{
        "restaurant_names" => Enum.random(@restaurant_names),
        "food_names" => Enum.random(@food_names),
        "first_name" => Enum.random(@first_names),
        "food_cost" => Enum.random(@food_cost)
      }
    end)
    |> Stream.take(150_000)
    |> CSV.encode(opts)
    |> Stream.into(File.stream!("data.csv", [:write, :utf8]))
    |> Stream.run()
  end
end
