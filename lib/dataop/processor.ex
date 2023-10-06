defmodule DataOp.Processor do
  @moduledoc """
  TableCheck Data Operations (Elixir Developer) - Take Home Project.

  Benchmarking reading CSV data:

  - lazy parsing with Stream:                                   300ms
  - concurrent parsing with Flow and CSV.decode/1:              300ms (WAT???)
  - concurrent parsing with Flow and NimbleCSV.parse_string/2:  120ms

  Total time (reading and processing data) with Flow: 150ms for 150,000 rows.
  """

  alias NimbleCSV.RFC4180, as: CSV

  def run do
    data =
      dataset_csv()
      |> read_dataset()
      |> process_dataset()

    {:ok, data}
  end

  def read_dataset(csv_path) do
    csv_path
    |> File.stream!()
    |> Stream.drop(1)
    |> Flow.from_enumerable()
    |> Flow.map(&parse_csv_row/1)
  end

  defp parse_csv_row(row) do
    row
    |> CSV.parse_string(skip_headers: false)
    |> parse_row_data()
  end

  defp parse_row_data([[restaraunt, dish, customer, cost_binary]]) do
    {cost, _} = Float.parse(cost_binary)

    %{
      restaraunt: restaraunt,
      dish: dish,
      customer: customer,
      cost: cost
    }
  end

  def process_dataset(data) do
    data
    |> Flow.partition(key: {:key, :restaraunt})
    |> Flow.reduce(fn -> %{} end, fn item, acc ->
      initial_value =
        %{
          total_customers: 1,
          total_revenue: item.cost,
          dishes: %{item.dish => {1, item.cost}},
          customers: %{item.customer => {1, item.cost}}
        }

      Map.update(acc, item.restaraunt, initial_value, fn stats -> update_stats(stats, item) end)
    end)
    |> Enum.into(%{})
  end

  defp update_stats(stats, item) do
    stats
    |> Map.update!(:total_customers, &(&1 + 1))
    |> Map.update!(:total_revenue, &(&1 + item.cost))
    |> Map.update!(:dishes, fn dacc ->
      Map.update(dacc, item.dish, {1, item.cost}, fn {counts, cost} ->
        {counts + 1, cost + item.cost}
      end)
    end)
    |> Map.update!(:customers, fn dacc ->
      Map.update(dacc, item.customer, {1, item.cost}, fn {counts, cost} ->
        {counts + 1, cost + item.cost}
      end)
    end)
  end

  defp dataset_csv do
    Application.app_dir(:dataop, "/priv/data.csv")
  end
end
