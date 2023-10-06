defmodule DataOp.PrintStats do
  @moduledoc """
  Print simple statistics to STDOUT.
  """

  alias DataOp.Stats

  def run(stats) do
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
