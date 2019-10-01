defmodule NodeMockWeb.BlockController do
  use NodeMockWeb, :controller

  def rpc(conn, %{"id" => id, "method" => "getblockhash", "params" => [height | _]}) do
    block = NodeMock.Block.block_at_height(height)
    json(conn, %{jsonrpc: "2.0", id: id, result: block.hash})
  end

  def rpc(conn, %{"id" => id, "method" => "getblock", "params" => [hash | _]}) do
    block = NodeMock.Block.block_by_hash(hash)
    json(conn, %{jsonrpc: "2.0", id: id, result: block})
  end

  def rpc(conn, %{"id" => id, "method" => "getblockchaininfo"}) do
    height = NodeMock.Block.last_block_height()
    json(conn, %{jsonrpc: "2.0", id: id, result: %{blocks: height}})
  end
end
