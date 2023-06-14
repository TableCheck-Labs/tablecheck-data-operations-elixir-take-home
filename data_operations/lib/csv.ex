defmodule CSV do
  @moduledoc """
    Documentation for `CSV`.
  """

  @doc """
    The CSV module imports data from a CSV file to a SQLite database.

    ## Examples
        iex> CSV.import("data.csv")
  """

  @doc """
    Imports data from a CSV file to a SQLite database.
    This is the ideal solution since it relies exclusively on a paradigm that already exists (SQLite supports native CSV imports and handles the table.)
  """
  def import_csv(file) do
    System.cmd("sqlite3", ["data.db", ".mode csv", ".import #{file} restaurants"])
  end

  @doc """
    Drops the restaurants table from the database.
  """
  def drop() do
    Ecto.Adapters.SQL.query!(
      MyRepo, "DROP TABLE IF EXISTS restaurants;"
    )
  end

  @doc """
    Cleans the database and creates a new restaurants table from data.csv.
  """
  def clean_and_create() do
    drop()
    import_csv("../data/data.csv")
  end
end
