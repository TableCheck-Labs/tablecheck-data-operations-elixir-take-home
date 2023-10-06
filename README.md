# TableCheck Data Operations (Elixir Developer) - Take Home Project

Concurrently ingest data from CSV file and generate simple statistics using [Flow](https://hexdocs.pm/flow/Flow.html).

## Installation

```
mix deps.get
mix compile
```

## Usage

To see simple statistics run:

```
mix run -e "DataOp.print()"
```

To play with API inside IEx:

```
iex> {:ok, stats} = DataOP.run()
iex> DataOp.restaraunts(stats)
iex> DataOp.total_customers_for(stats, "the-restaurant-at-the-end-of-the-universe")
```

To generate test data:

```
mix generate
mv data.csv priv/
```

- - -

# Original README

Take a look at the dataset located in `/priv/data.csv`. Your goal is to interpret it and create an API that can answer the following questions:
  - [ ] How many customers visited the "Restaurant at the end of the universe"?
  - [ ] How much money did the "Restaurant at the end of the universe" make?
  - [ ] What was the most popular dish at each restaurant?
  - [ ] What was the most profitable dish at each restaurant?
  - [ ] Who visited each store the most, and who visited the most stores?

## Tasks

- [ ] Ingest the data into your database of choice.
- [ ] Create an API.
- [ ] Create API documentation that has explicit examples on how to answer the questions listed above.
- [ ] Document your solution as a whole.

Please document your solution, and provide answers to the following questions at the end as well.
* How would you build this differently if the data was being streamed from Kafka?
* How would you improve the deployment of this system?


## Questions
### What library should I use?
There is no limit on the choice of library or other semantics. Use what you are familiar with and what you would recommend.

### How should I ingest the data?
You can use any method you like to ingest the data. You can use a script, a tool, or even a direct database import if your chosen database supports that. The only requirement is that the data is eventually stored in some kind of database.
