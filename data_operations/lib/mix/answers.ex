defmodule Mix.Tasks.DoAnswers do
  @moduledoc "The answers mix task: `mix help DOAnswers`"
  use Mix.Task

  @requirements ["app.start"]
  @shortdoc "Answers questions for the DO assignment."
  def run(_) do
    # Startup
    MyRepo.start_link([])
    CSV.clean_and_create()

    # How many customers visited the 'Restaurant at the end of the universe'?
    IO.puts("How many customers visited the 'Restaurant at the end of the universe'?")
    Query.query("SELECT COUNT(*) FROM restaurants WHERE restaurant_names = 'the-restaurant-at-the-end-of-the-universe';") |> IO.inspect()

    # How much money did the "Restaurant at the end of the universe" make?
    IO.puts("How much money did the 'Restaurant at the end of the universe' make?")
    Query.query("SELECT SUM(food_cost) FROM restaurants WHERE restaurant_names = 'the-restaurant-at-the-end-of-the-universe';") |> IO.inspect()

    # What was the most popular dish at each restaurant?
    IO.puts("What was the most popular dish at each restaurant?")
    Query.query("SELECT DISTINCT restaurant_names, food_names, COUNT(food_names) as popularity FROM restaurants GROUP BY restaurant_names ORDER BY popularity DESC;") |> IO.inspect()

    # What was the most profitable dish at each restaurant?
    IO.puts("What was the most profitable dish at each restaurant?")
    Query.query("SELECT DISTINCT restaurant_names, food_names, SUM(food_cost) as profitability FROM restaurants GROUP BY restaurant_names ORDER BY profitability DESC;") |> IO.inspect()

    # Who visited each store the most?
    IO.puts("Who visited each store the most?")
    Query.query("SELECT DISTINCT first_name, restaurant_names, COUNT(restaurant_names) as visits FROM restaurants GROUP BY restaurant_names ORDER BY visits DESC;") |> IO.inspect()

    # Who visited the most stores?
    IO.puts("Who visited the most stores?")
    Query.query("SELECT DISTINCT first_name, COUNT(restaurant_names) as visits FROM restaurants GROUP BY first_name ORDER BY visits DESC LIMIT 3;") |> IO.inspect()
  end
end
