defmodule Calculator do
  use GenServer

  alias Periodic

  @doc """
  Starts the calculator.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    IO.puts("starting calculator")
    {:ok, 0}
  end

  @impl true
  def handle_call({:lookup}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:add, num}, _from, state) do
    result = state + num
    IO.puts(result)
    {:reply, {:ok, result}, result}
  end

  def add(server, num) do
    {:ok, result} = GenServer.call(server, {:add, num})
    result
  end

  def add_periodic(server, num) do
    {:ok, pid} = Periodic.start_link([])

    callback = fn -> add(server, num) end

    Periodic.retry(pid, %Periodic{freq: 1000, callback: callback})
  end

  def see_result(server) do
    GenServer.call(server, {:lookup})
  end
end
