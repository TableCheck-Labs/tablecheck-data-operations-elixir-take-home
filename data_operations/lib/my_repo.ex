defmodule MyRepo do
  use Ecto.Repo,
  otp_app: :data_operations,
  adapter: Ecto.Adapters.SQLite3
end
