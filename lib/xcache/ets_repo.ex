defmodule Xcache.EtsRepo do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    table = :ets.new(__MODULE__, [:set, :private, :named_table])
    {:ok, table}
  end

  @impl true
  def handle_cast({:insert, key, value}, table) do
    :ets.insert(table, {key, value})

    {:noreply, table}
  end

  @impl true
  def handle_call({:get, key}, _from, table) do
    case :ets.lookup(table, key) do
      [] -> {:reply, nil, table}
      [result] -> {:reply, result, table}
    end
  end
end
