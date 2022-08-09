defmodule Xcache do
  require Logger

  def bench_ets do
    initial_time = DateTime.utc_now()
    {_, pokemon} = GenServer.call(Xcache.EtsRepo, {:get, "1"})
    diff_time = DateTime.diff(DateTime.utc_now(), initial_time, :nanosecond)
    Logger.info("ETS - Request the pokemon: #{pokemon["name"]} in #{diff_time} ns")
  end

  def bench_redis do
    initial_time = DateTime.utc_now()
    pokemon = GenServer.call(Xcache.RedisRepo, {:get, "1"})
    diff_time = DateTime.diff(DateTime.utc_now(), initial_time, :nanosecond)
    Logger.info("Redis - Request the pokemon: #{pokemon["name"]} in #{diff_time} ns")
  end

  def seed_step do
    stream_data()
    |> Enum.take(200)
    |> Enum.map(fn pokemon ->
      GenServer.cast(Xcache.EtsRepo, {:insert, pokemon["pokedex_number"], pokemon})
      GenServer.cast(Xcache.RedisRepo, {:insert, pokemon["pokedex_number"], pokemon})
    end)
  end

  defp stream_data do
    "./pokemon.csv"
    |> File.stream!()
    |> CSV.decode!(headers: true)
  end
end
