defmodule NodeMock.BlockProducer do
  use GenServer

  defmodule State do
    @enforce_keys [:block_p, :orphan_p]
    defstruct [:block_p, :orphan_p]
  end

  alias NodeMock.Block
  alias NodeMock.BlockProducer.State

  defguard is_prob(prob) when prob < 1 and prob > 0

  def child_spec([]) do
    child_spec([0.2, 0.05])
  end

  def child_spec(params) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [params]}
    }
  end

  def start_link(params) do
    GenServer.start_link(__MODULE__, params)
  end

  @impl true
  def init([prob_block, prob_orphan])
      when is_prob(prob_block) and is_prob(prob_orphan) do
    schedule_work()

    {:ok, %State{block_p: prob_block, orphan_p: prob_orphan}}
  end

  @impl true
  def handle_info(:work, state) do
    Block.try_generate(state.block_p, state.orphan_p)
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1_000)
  end
end
