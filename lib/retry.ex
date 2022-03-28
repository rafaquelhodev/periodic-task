defmodule Retry do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:retry, data}, _from, state) do
    Process.send_after(data.server, {:tick, data}, data.freq)

    {:reply, data, state}
  end

  @impl true
  def handle_info({:tick, data}, state) do
    time =
      DateTime.utc_now()
      |> DateTime.to_time()
      |> Time.to_iso8601()

    IO.puts("The time is now: #{time}")

    data.callback.()

    Process.send_after(data.server, {:tick, data}, data.freq)

    {:noreply, state}
  end

  def retry(server, data) do
    data = Map.put(data, :server, server)
    GenServer.call(data.server, {:retry, data})
  end
end
