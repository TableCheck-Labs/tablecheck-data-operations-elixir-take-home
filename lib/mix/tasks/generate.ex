defmodule Mix.Tasks.Generate do
  @moduledoc "Generate 150,000 rows of test data, stored in CSV file."
  @shortdoc "Generate test data"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info("Generating test data...")
    DataOp.Generator.run()
    Mix.shell().info("done!")
  end
end
