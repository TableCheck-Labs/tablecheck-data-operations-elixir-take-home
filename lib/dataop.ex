defmodule TablecheckDataOp do
  @moduledoc """
  TableCheck Data Operations (Elixir Developer) - Take Home Project.

  Benchmarking reading CSV data:

  - lazy parsing with Stream:                                   300ms
  - concurrent parsing with Flow and CSV.decode/1:              300ms (WAT???)
  - concurrent parsing with Flow and NimbleCSV.parse_string/2:  120ms

  Total time (reading and processing data) with Flow: 150ms for 150,000 rows.
  """

  alias TablecheckDataOp.Processor
  alias TablecheckDataOp.Stats

  def run do
    with {:ok, data} <- Processor.run(),
         stats <- Stats.build(data) do
      {:ok, stats}
    end
  end





    end)

  end
end
