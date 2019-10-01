defmodule NodeMock.Repo do
  use Ecto.Repo,
    otp_app: :node_mock,
    adapter: Ecto.Adapters.Postgres
end
