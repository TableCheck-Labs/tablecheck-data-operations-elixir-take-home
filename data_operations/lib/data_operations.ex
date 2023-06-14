defmodule DataOperations do
  use Supervisor

  @moduledoc """
  Documentation for `DataOperations`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DataOperations.hello()
      :world

  """

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      %{
        id: MyRepo,
        start: {MyRepo,  []}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
