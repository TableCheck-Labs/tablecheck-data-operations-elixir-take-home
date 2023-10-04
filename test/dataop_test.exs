defmodule DataOpTest do
  use ExUnit.Case

  alias DataOp, as: DataOp

  test ".run/1 returns :ok" do
    assert {:ok, %{}} = DataOp.run()
  end
end
