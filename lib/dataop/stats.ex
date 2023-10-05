defmodule DataOp.Stats do
  @moduledoc ~S"""
  Generate more structable data from raw stats and provide API for accessing it.
  """

  alias DataOp.RestarauntStats

  @type t :: %{restaraunt_name() => RestarauntStats.t()}

  @typep restaraunt_name :: DataOp.restaraunt_name()

  @spec build(%{restaraunt_name() => RestarauntStats.raw_stats()}) :: t()
  def build(raw_stats) do
    Enum.reduce(raw_stats, %{}, fn {rname, rdata}, acc ->
      Map.put(acc, rname, RestarauntStats.build(rname, rdata))
    end)
  end

  def total_customers_for(stats, restaraunt) do
    Map.fetch!(stats, restaraunt).total_customers
  end

  def total_revenue_for(stats, restaraunt) do
    Map.fetch!(stats, restaraunt).total_revenue
  end

  def most_popular_dish_for(stats, restaraunt) do
    Map.fetch!(stats, restaraunt).most_popular_dish
  end

  def most_profitable_dish_for(stats, restaraunt) do
    Map.fetch!(stats, restaraunt).most_profitable_dish
  end

  def most_visited_customer_for(stats, restaraunt) do
    Map.fetch!(stats, restaraunt).most_visited_customer
  end

  def most_profitable_customer_for(stats, restaraunt) do
    Map.fetch!(stats, restaraunts).most_profitable_customer
  end

  def restaraunts(stats), do: Map.keys(stats)

  def total_customers(stats) do
    stats
    |> restaraunts()
    |> Enum.map(fn name -> total_customers_for(stats, name) end)
    |> Enum.sum()
  end

  def total_revenue(stats) do
    stats
    |> restaraunts()
    |> Enum.map(fn name -> total_revenue_for(stats, name) end)
    |> Enum.sum()
  end

  def top_visited_restaraunts(stats, limit \\ 5) do
    top_n_by(stats, limit, &total_customers_for/2)
  end

  def top_profitable_restaraunts(stats, limit \\ 5) do
    top_n_by(stats, limit, &total_revenue_for/2)
  end

  def top_popular_dishes(stats, limit \\ 5) do
    top_n_by(stats, limit, &most_popular_dish_for/2, &elem(&1, 1))
  end

  def top_profitable_dishes(stats, limit \\ 5) do
    top_n_by(stats, limit, &most_profitable_dish_for/2, &elem(&1, 1))
  end

  def top_visited_customers(stats, limit \\ 5) do
    top_n_by(stats, limit, &most_visited_customer_for/2, &elem(&1, 1))
  end

  def top_profitable_customers(stats, limit \\ 5) do
    top_n_by(stats, limit, &most_profitable_customer_for/2, &elem(&1, 1))
  end

  defp top_n_by(stats, limit, value_func, sort_by_func \\ & &1) do
    stats
    |> restaraunts()
    |> Enum.map(fn name -> {name, value_func.(stats, name)} end)
    |> Enum.sort_by(fn {_name, value} -> sort_by_func.(value) end, :desc)
    |> Enum.take(limit)
  end
end
