defmodule NodeMock.Repo.Migrations.CreateBlocksTable do
  use Ecto.Migration

  @zero for(_ <- 1..32, into: <<>>, do: <<0>>) |> Base.encode16(case: :lower)

  def change do
    create table(:blocks, primary_key: false) do
      add :hash, :string, primary_key: true
      add :previousblockhash, :string, null: false
      add :randomness, :string, null: false
      add :height, :integer, null: false
      add :nTx, :integer, null: false
      add :is_orphan, :boolean, null: false, default: false
    end

    flush()

    alias NodeMock.{Block, Repo}

    Block.new_block_after(%{hash: @zero, height: -1}) |> Repo.insert()
  end
end
