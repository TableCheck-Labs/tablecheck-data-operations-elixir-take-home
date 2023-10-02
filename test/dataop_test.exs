defmodule DataOpTest do
  use ExUnit.Case

  alias TablecheckDataOp, as: DataOp

  test ".run/1 returns :ok" do
    assert DataOp.run() == :ok
  end
end
