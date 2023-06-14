defmodule Query do
  alias MyRepo
  @moduledoc """
    Documentation for `Query`.
  """
  @doc """
    The Query module is responsible for querying the database.
  """
  def query(query) do
    Ecto.Adapters.SQL.query!(MyRepo, query)
  end
end
