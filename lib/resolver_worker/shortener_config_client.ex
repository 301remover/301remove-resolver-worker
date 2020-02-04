defmodule ShortenerConfigClient do
  use GenServer

  @moduledoc """
  Client for the 301r API server. Fetches config from the API server, caches
  it, and makes it avaliable to other parts of the application.
  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def refresh_config() do
    GenServer.cast(__MODULE__, :refresh_config)
  end

  def get_domains() do
    GenServer.call(__MODULE__, :list_domains)
  end

  def get_config(shortener_domain) do
    GenServer.call(__MODULE__, {:get_domain, shortener_domain})
  end

  defp request_full_config() do
    # TODO: return :error when the API is down
    response = HTTPoison.get!("https://301r.dev/api/shorteners")

    Jason.decode!(response.body)
    |> Map.fetch!("data")
    |> Map.new(fn entry ->
      {
        Map.fetch!(entry, "domain"),
        Map.delete(entry, "domain") |> Map.delete("id")
      }
    end)
  end

  @impl true
  def handle_cast(:refresh_config, _state) do
    config = request_full_config()
    {:noreply, config}
  end

  @impl true
  def handle_call({:get_domain, shortener_domain}, _from, state) do
    {:reply, Map.fetch(state, shortener_domain), state}
  end

  @impl true
  def handle_call(:list_domains, _from, state) do
    {:reply, {:ok, Map.keys(state)}, state}
  end

  @impl true
  def init(state \\ %{}) do
    {:ok, state}
  end
end
