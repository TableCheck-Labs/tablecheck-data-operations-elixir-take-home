# TableCheck Data Operations Assignment

## Description
This is a simple Elixir application that reads a CSV file and performs some operations on the data to answer the questions that were asked in the assignment.

## Running the assignment
```
# Install dependencies and compile application.
mix do deps.get, compile

# Run the answers mix task.
mix do_answers
```

You should get answers to each question that was asked, in order of the questions in the README file.

## Structure of this application
For this, I decided to use SQLite's built-in functionality which allows us to import the CSV file in a format that's easy to query.

Once the data is imported as an SQLite, I use Ecto to query the database and generate the answers to the questions as raw SQL in the mix task. If I had more time, I would have liked to use Ecto's query syntax to generate the answers.

An example of doing this would be:
```elixir
query =
  from r in "restaurants",
  select r.restaurant_names, r.food_cost,
  where: r.food_names == "grains",
  order_by: [desc: r.food_cost],
  limit: 10

MyRepo.all(query)
```

## Further information

This is a dummy assignment. If you are copying from this, just don't!
