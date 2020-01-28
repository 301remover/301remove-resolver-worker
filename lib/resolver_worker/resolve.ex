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

  defp get_full(url) do
    url
    |> HTTPoison.get!()
    |> get_loc
    |> List.first()
    |> elem(1)
  end

  @impl true
  def handle_call({:tiny, code}, _from, state) do
    url = get_full("https://tinyurl.com/" <> code)
    {:reply, {:ok, url}, state}
  end

  @impl true
  def handle_call({:bitly, code}, _from, state) do
    url = get_full("https://bit.ly/" <> code)
    {:reply, {:ok, url}, state}
  end

  @impl true
  def handle_call({:google, code}, _from, state) do
    url = get_full("https://goo.gl/" <> code)
    {:reply, {:ok, url}, state}
  end

  # GenServer init stuff

  @impl true
  def init(state \\ %{}) do
    {:ok, state}
  end
end
