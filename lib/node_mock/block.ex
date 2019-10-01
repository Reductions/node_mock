defmodule NodeMock.Block do
  use Ecto.Schema

  alias NodeMock.Repo
  alias NodeMock.Block

  import Ecto.Query, only: [from: 2]

  @derive {Jason.Encoder,
           only: [:hash, :previousblockhash, :height, :nTx, :confirmations]}
  @primary_key {:hash, :string, autogenerate: false}
  schema "blocks" do
    field :previousblockhash, :string
    field :randomness, :string
    field :height, :integer
    field :nTx, :integer
    field :is_orphan, :boolean

    field :confirmations, :integer, virtual: true
  end

  def try_generate(bp, op) do
    if bp > rand() do
      generate(op)
    end
  end

  def generate(op, oc \\ 0) do
    if op > rand() do
      generate(op, oc + 1)
    else
      do_generate(oc)
    end
  end

  defp do_generate(orphans) do
    height = last_block_height()

    rewind_orphans(min(height, orphans), height)
  end

  defp rewind_orphans(number \\ 0, orphans, height, blocks \\ [])

  defp rewind_orphans(0, orphans, height, []) do
    new_block =
      block_at_height(height - orphans)
      |> new_block_after()

    rewind_orphans(1, orphans, height, [new_block])
  end

  defp rewind_orphans(number, orphans, height, [head_block | _] = blocks)
       when number <= orphans do
    new_block =
      head_block
      |> new_block_after()

    rewind_orphans(number + 1, orphans, height, [new_block | blocks])
  end

  defp rewind_orphans(_number, _orphans, _height, blocks) do
    Repo.transaction(fn ->
      blocks
      |> Enum.reverse()
      |> Enum.map(&insert_block_and_rewind_old/1)
    end)
  end

  defp insert_block_and_rewind_old(%{height: h} = block) do
    from(b in Block,
      where: b.height == ^h
    )
    |> Repo.update_all(set: [is_orphan: true])

    Repo.insert(block)
  end

  def last_block_height() do
    last_block_main_q()
    |> height_q()
    |> Repo.one()
  end

  defp last_block_main_q(q \\ Block) do
    from b in q,
      where: b.is_orphan == false,
      order_by: [desc: b.height],
      limit: 1
  end

  def block_by_hash(hash) do
    block =
      from(b in Block,
        where: b.hash == ^hash
      )
      |> Repo.one!()
    %{block | confirmations: calc_conf(block)}
  end

  defp calc_conf(%{is_orphan: true}), do: IO.inspect(-1)
  defp calc_conf(_), do: 0

  def block_at_height(height) do
    height
    |> block_at_height_q()
    |> Repo.one()
  end

  def block_at_height_q(height) do
    from b in Block,
      where: b.height == ^height and b.is_orphan == false
  end

  defp height_q(q \\ Block) do
    from b in q,
      select: b.height
  end

  def new_block_after(block) do
    rand_string = random_string()

    %Block{
      previousblockhash: block.hash,
      randomness: rand_string,
      height: block.height + 1,
      hash: sha256(block.hash <> rand_string),
      nTx: random_nTx()
    }
  end

  defp random_string() do
    :crypto.strong_rand_bytes(16)
    |> Base.encode16(case: :lower)
  end

  defp random_nTx() do
    :random.uniform(2701) - 1
  end

  defp rand() do
    :random.uniform()
  end

  defp sha256(to_hash) do
    :crypto.hash(:sha256, to_hash)
    |> Base.encode16(case: :lower)
  end
end
