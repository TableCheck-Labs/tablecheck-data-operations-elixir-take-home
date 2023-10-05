defmodule DataOp do
  @moduledoc ~S"""
  TableCheck Data Operations (Elixir Developer) - Take Home Project.

  Read data from CSV file, process and generate stats about restaraunt visits,
  revenue, popular dishes, etc.

  ## Usage

      iex> {:ok, stats, _data} = DataOp.run()

      iex> DataOp.restaraunts(stats)
      ["my-fav-restaraunt", "other-restaraunt", ... ]

      iex> DataOp.total_customers_for(stats, "my-fav-restaraunt")
      1999

      iex> DataOp.total_revenue_for(stats, "my-fav-restaraunt")
      59999.99

      iex> DataOp.most_popular_dish_for(stats, "my-fav-restaraunt")
      {"curry", 1500}

      iex> DataOp.most_profitable_dish_for(stats, "my-fav-restaraunt")
      {"curry", 49999.99}

      iex> DataOp.most_visited_customer_for(stats, "my-fav-restaraunt")
      {"Crono-kun", 10000}

      iex> DataOp.most_profitable_customer_for(stats, "my-fav-restaraunt")
      {"Crono-kun", 32500.0}

  ## (Naive) Benchmarking

  Reading CSV data:

  - lazy parsing with Stream:                                   300ms
  - concurrent parsing with Flow and CSV.decode/1:              300ms (WAT???)
  - concurrent parsing with Flow and NimbleCSV.parse_string/2:  120ms

  Total time (reading and processing data) with Flow: 150ms for 150,000 rows.
  """

  alias DataOp.PrintStats
  alias DataOp.Processor
  alias DataOp.Stats

  @typep restaraunt_name :: String.t()
  @typep dish_name :: String.t()
  @typep customer_name :: String.t()
  @typep count :: non_neg_integer()
  @typep revenue :: float()

  @doc "Read and process data and generate stats."
  @spec run() :: {:ok, Stats.t()}
  def run do
    with {:ok, data} <- Processor.run(),
         stats <- Stats.build(data) do
      {:ok, stats}
    end
  end

  @doc "Parse data and print simple stats to STDOUT."
  @spec print() :: :ok
  def print do
    {:ok, stats} = run()
    PrintStats.run(stats)
  end

  @doc "Returns the list of all restaraunts."
  @spec restaraunts(Stats.t()) :: [String.t()]
  defdelegate restaraunts(stats), to: Stats

  @doc "Returns total visits for a restaraunt."
  @spec total_customers_for(Stats.t(), restaraunt_name()) :: count()
  defdelegate total_customers_for(stats, restaraunt), to: Stats

  @doc "Returns total revenue for a restaraunt."
  @spec total_revenue_for(Stats.t(), restaraunt_name) :: revenue
  defdelegate total_revenue_for(stats, restaraunt), to: Stats

  @doc """
  Returns most popular dish for a restaraunt.
  Return value is the name of the dish and how much times it has been ordered.
  """
  @spec most_popular_dish_for(Stats.t(), restaraunt_name) :: {dish_name, count}
  defdelegate most_popular_dish_for(stats, restaraunt), to: Stats

  @doc """
  Returns most profitable dish for a restaraunt.
  Return value is the name of the dish and total revenue.
  """
  @spec most_profitable_dish_for(Stats.t(), restaraunt_name) :: {dish_name, revenue}
  defdelegate most_profitable_dish_for(stats, restaraunt), to: Stats

  @doc """
  Returns the customer who visited the restaurant more times.
  Return value is a customer name and a number of visits.
  """
  @spec most_visited_customer_for(Stats.t(), restaraunt_name) :: {customer_name, count}
  defdelegate most_visited_customer_for(stats, restaraunt), to: Stats

  @doc """
  Returns the customer who spend most at the restaurant.
  Return value is a customer name and total revenue.
  """
  @spec most_profitable_customer_for(Stats.t(), restaraunt_name) :: {customer_name, revenue}
  defdelegate most_profitable_customer_for(stats, restaraunt), to: Stats

  @doc """
  Returns list of most visited restaraunts in descending order.
  By default returns only 5 results.
  """
  @spec top_visited_restaraunts(Stats.t(), pos_integer) :: [{restaraunt_name, count}]
  defdelegate top_visited_restaraunts(stats, limit), to: Stats

  @doc """
  Returns list of most profitable restaraunts in descending order.
  By default returns only 5 results.
  """
  @spec top_profitable_restaraunts(Stats.t(), pos_integer) :: [{restaraunt_name, revenue}]
  defdelegate(top_profitable_restaraunts(stats, limit), to: Stats)

  @doc """
  Returns most popular dish for each restaraunt.
  By default returns only 5 results.
  """
  @spec top_popular_dishes(Stats.t(), pos_integer) :: [{restaraunt_name, {dish_name, count}}]
  defdelegate top_popular_dishes(stats, limit), to: Stats

  @doc """
  Returns most profitable dish for each restaraunt.
  By default returns only 5 results.
  """
  @spec top_profitable_dishes(Stats.t(), pos_integer) :: [{restaraunt_name, {dish_name, revenue}}]
  defdelegate top_profitable_dishes(stats, limit), to: Stats

  @doc """
  Returns most visited customer for each restaraunt.
  By default returns only 5 results.
  """
  @spec top_visited_customers(Stats.t(), pos_integer) :: [
          {restaraunt_name, {customer_name, count}}
        ]
  defdelegate top_visited_customers(stats, limit), to: Stats

  @doc """
  Returns most profitable customer for each restaraunt.
  By default returns only 5 results.
  """
  @spec top_profitable_customers(Stats.t(), pos_integer) :: [
          {restaraunt_name, {customer_name, revenue}}
        ]
  defdelegate top_profitable_customers(stats, limit), to: Stats
end
