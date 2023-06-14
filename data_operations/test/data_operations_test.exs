defmodule DataOperationsTest do
  use ExUnit.Case
  doctest DataOperations

  test "greets the world" do
    assert DataOperations.hello() == :world
  end
end
