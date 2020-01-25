defmodule ResolverWorker.Resolve do
  use GenServer

  @moduledoc """
  Documentation for ResolverWorker.
  """

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def resolve("tinyurl.com", url) do
    GenServer.call(__MODULE__, {:tiny, url})
  end

  def resolve("bit.ly", url) do
    GenServer.call(__MODULE__, {:bitly, url})
  end

  def resolve("goo.gl", url) do
    GenServer.call(__MODULE__, {:google, url})
  end

  @doc """
  Handles a call back for tinyurl, bit.ly and goo.gl links
  """
  defp get_loc(response) do
    Enum.filter(response.headers, fn
      {key, _} -> String.match?(key, ~r/\Alocation\z/i)
    end)
  end

  @impl true
  def handle_call({:tiny, code}, _from, env) do
    short = "https://tinyurl.com/" <> code
    response = HTTPoison.get!(short)
    location = get_loc(response)
    loc = List.first(location)
    url = elem(loc, 1)
    {:reply, {:ok, url}, env}
  end

  @impl true
  def handle_call({:bitly, code}, _from, env) do
    short = "https://bit.ly/" <> code
    response = HTTPoison.get!(short)
    location = get_loc(response)
    loc = List.first(location)
    url = elem(loc, 1)
    {:reply, {:ok, url}, env}
  end

  @impl true
  def handle_call({:google, code}, _from, env) do
    short = "https://goo.gl/" <> code
    response = HTTPoison.get!(short)
    location = get_loc(response)
    loc = List.first(location)
    url = elem(loc, 1)
    {:reply, {:ok, url}, env}
  end

  # GenServer init stuff

  @impl true
  def init(_) do
    {:ok, 1}
  end
end
