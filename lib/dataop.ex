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

  def print do
    {:ok, stats} = run()

    IO.puts("\nSTATISTICS\n----------")

    IO.puts("\nTotal customers:\n")

    Stats.top_visited_restaraunts(stats)
    |> Enum.each(fn {name, count} -> IO.puts("- #{name}: #{count}") end)

    IO.puts("- TOTAL: #{Stats.total_customers(stats)}")

    IO.puts("\nTotal revenue:\n")

    Stats.top_profitable_restaraunts(stats)
    |> Enum.each(fn {name, revenue} ->
      IO.puts("- #{name}: #{revenue}")
    end)

    IO.puts("- TOTAL: #{Stats.total_revenue(stats)}")

    IO.puts("\nMost popular dish:\n")

    Stats.top_popular_dishes(stats)
    |> Enum.each(fn {name, {dish_name, count}} ->
      IO.puts("- #{name}: #{dish_name} (#{count})")
    end)

    IO.puts("\nMost profitable dish:\n")

    Stats.top_profitable_dishes(stats)
    |> Enum.each(fn {name, {dish_name, revenue}} ->
      IO.puts("- #{name}: #{dish_name} (#{revenue})")
    end)

    IO.puts("\nMost visited customers:\n")

    Stats.top_visited_customers(stats)
    |> Enum.each(fn {rname, {cname, count}} ->
      IO.puts("- #{rname}: #{cname} (#{count})")
    end)

    IO.puts("\nMost profitable customers:\n")

    Stats.top_profitable_customers(stats)
    |> Enum.each(fn {rname, {cname, revenue}} ->
      IO.puts("- #{rname}: #{cname} (#{revenue})")
    end)

    IO.puts("")
  end
end
