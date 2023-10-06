defmodule DataOp.RestarauntStats do
  @moduledoc ~S"""
  Stats per restaraunt: total customers, total revenue, most popular dish,
  most profitable dish, customer with most visits, customer with most spendings. 
  """

  @type t :: %__MODULE__{
          name: restaraunt_name(),
          total_customers: count(),
          total_revenue: count(),
          most_popular_dish: {dish_name(), count()},
          most_profitable_dish: {dish_name(), revenue()},
          most_visited_customer: {customer_name(), count()},
          most_profitable_customer: {customer_name(), revenue()}
        }

  @type raw_stats :: %{
          total_customers: count(),
          total_revenue: revenue(),
          dishes: %{
            dish_name() => {count(), revenue()}
          },
          customers: %{
            customer_name() => {count(), revenue()}
          }
        }

  @typep restaraunt_name :: DataOp.restaraunt_name()
  @typep dish_name :: DataOp.dish_name()
  @typep customer_name :: DataOp.customer_name()
  @typep count :: DataOp.count()
  @typep revenue :: DataOp.revenue()

  defstruct name: "",
            total_customers: 0,
            total_revenue: 0,
            most_popular_dish: {},
            most_profitable_dish: {},
            most_visited_customer: {},
            most_profitable_customer: {}

  @doc "Generate stats for restaraunt from raw stats."
  @spec build(String.t(), raw_stats()) :: t()
  def build(name, data) do
    struct!(__MODULE__, %{
      name: name,
      total_customers: data.total_customers,
      total_revenue: data.total_revenue
    })
    |> put_best_dish(data)
    |> put_best_customer(data)
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
