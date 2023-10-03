defmodule TablecheckDataOp do
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
      read_dataset()
      |> process_dataset()
      |> Enum.into(%{})

    {:ok, data}
  end

  def read_dataset do
    dataset_csv()
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

  @default_stats %{
    total_customers: 0,
    total_revenue: 0,
    dishes_count: %{},
    dishes_cost: %{},
    customers_count: %{}
  }

  # TODO: maybe instead one-pass split into many data-consumer-producers and
  # process data separataly with Flow.group_by/2? Could be more readable.
  def process_dataset(data) do
    data
    |> Flow.partition(key: {:key, :restaraunt})
    |> Flow.reduce(fn -> %{} end, fn item, acc ->
      Map.update(acc, item.restaraunt, @default_stats, fn stats ->
        stats
        |> Map.update!(:total_customers, &(&1 + 1))
        |> Map.update!(:total_revenue, &(&1 + item.cost))
        |> Map.update!(:dishes_count, fn dacc ->
          Map.update(dacc, item.dish, 0, &(&1 + 1))
        end)
        |> Map.update!(:dishes_cost, fn dacc ->
          Map.update(dacc, item.dish, 0, &(&1 + item.cost))
        end)
        |> Map.update!(:customers_count, fn cacc ->
          Map.update(cacc, item.customer, 0, &(&1 + 1))
        end)
      end)
    end)
  end

  def dataset_csv do
    Application.app_dir(:dataop, "/priv/data.csv")
  end
end
