# NodeMock

To run the *Node Mock* server you need to have Postgres installed on the machine and run the folowing commands:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

The server is now exposed on: http://localhost:4000

To connect the exported to the server you need to set the `NODE_URL` evn varaiable to http://localhost:4000 when running the exporter.
