defmodule Xcache.RedisRepo do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Redix.start_link(name: :redix)
  end

  @impl true
  def handle_cast({:insert, key, value}, conn) do
    Redix.command(conn, ["SET", key, value])

    {:noreply, conn}
  end

  @impl true
  def handle_call({:get, key}, _from, conn) do
    case Redix.command(conn, ["GET", key]) do
      {:ok, value} -> {:reply, value, conn}
      _ -> {:reply, nil, conn}
    end
  end
end
