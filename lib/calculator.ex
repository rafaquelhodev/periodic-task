defmodule Calculator do
  use GenServer

  alias Retry

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
  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
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
    {:ok, pid} = Retry.start_link([])

    callback = fn -> add(server, num) end

    Retry.retry(pid, %{freq: 1000, callback: callback})
  end
end
