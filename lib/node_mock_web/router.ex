defmodule NodeMockWeb.Router do
  use NodeMockWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NodeMockWeb do
    pipe_through :api
  end
end
