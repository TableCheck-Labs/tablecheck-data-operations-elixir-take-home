defmodule TablecheckDataOp.Stats do
  @moduledoc """
  Process per-restaraunt stats and API to access stats:

  iex> stats = Stats.build(data)

  iex> Stats.total_customers_for(stats, "my-fav-restaraunt")
  1999

  iex> Stats.total_revenue_for(stats, "my-fav-restaraunt")
  59999.99

  iex> Stats.most_popular_dish_for(stats, "my-fav-restaraunt")
  {"curry", 1500}

  iex> Stats.most_profitable_dish_for(stats, "my-fav-restaraunt")
  {"curry", 49999.99}

  iex> Stats.most_visited_customer_for(stats, "my-fav-restaraunt")
  {"Crono-kun", 10000}

  iex> Stats.most_profitable_customer_for(stats, "my-fav-restaraunt")
  {"Crono-kun", 32500.0}
  """

  defmodule RestarauntStats do
    @moduledoc """
    Stats per restaraunt: total customers, total revenue, most popular dish,
    most profitable dish, customer with most visits, customer with most spendings. 
    """

    defstruct name: "",
              total_customers: 0,
              total_revenue: 0,
              most_popular_dish: {},
              most_profitable_dish: {},
              most_visited_customer: {},
              most_profitable_customer: {}

    def build(name, data) do
      %__MODULE__{}
      |> Map.put(:name, name)
      |> put_totals(data)
      |> put_best_dish(data)
      |> put_best_customer(data)
    end

    defp put_totals(stats, data) do
      stats
      |> Map.put(:total_customers, data.total_customers)
      |> Map.put(:total_revenue, data.total_revenue)
    end

    defp put_best_dish(stats, data) do
      {pname, {count, _}} = Enum.max_by(data.dishes, &by_count/1)
      {rname, {_, cost}} = Enum.max_by(data.dishes, &by_cost/1)

      stats
      |> Map.put(:most_popular_dish, {pname, count})
      |> Map.put(:most_profitable_dish, {rname, cost})
    end

    defp put_best_customer(stats, data) do
      {cname, {count, _}} = Enum.max_by(data.customers, &by_count/1)
      {rname, {_, cost}} = Enum.max_by(data.customers, &by_cost/1)

      stats
      |> Map.put(:most_visited_customer, {cname, count})
      |> Map.put(:most_profitable_customer, {rname, cost})
    end

    defp by_count({_name, {count, _cost}}), do: count
    defp by_cost({_name, {_count, cost}}), do: cost
  end

  def build(raw_stats) do
    Enum.reduce(raw_stats, %{}, fn {rname, rdata}, acc ->
      Map.put(acc, rname, RestarauntStats.build(rname, rdata))
    end)
  end

  def total_customers_for(stats, restaraunt), do: stats[restaraunt].total_customers
  def total_revenue_for(stats, restaraunt), do: stats[restaraunt].total_revenue
  def most_poular_dish_for(stats, restaraunt), do: stats[restaraunt].most_popular_dish
  def most_profitable_dish_for(stats, restaraunt), do: stats[restaraunt].most_profitable_dish
  def most_visited_customer_for(stats, restaraunt), do: stats[restaraunt].most_visited_customer

  def most_profitable_customer_for(stats, restaraunt),
    do: stats[restaraunt].most_profitable_customer
end