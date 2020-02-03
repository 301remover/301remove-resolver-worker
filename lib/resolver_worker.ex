defmodule ResolverWorker do
  use GenServer

  @moduledoc """
  Documentation for ResolverWorker.
  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  """

  def get_loc(response) do
    Enum.filter(response.headers, fn
      {key, _} -> String.match?(key, ~r/\Alocation\z/i)
    end)
  end

  @doc """
  Handles a call back for tinyurl and bit.ly links
  """
  def resolve(shortener_domain, shortcode) do
    GenServer.call(__MODULE__, {shortener_domain, shortcode})
  end

  defp get_full(url) do
    url
    |> HTTPoison.get!()
    |> get_loc
    |> List.first()
    |> elem(1)
  end

  @impl true
  def handle_call({"tinyurl.com", code}, _from, state) do
    url = get_full("https://tinyurl.com/" <> code)
    {:reply, {:ok, url}, state}
  end

  @impl true
  def handle_call({"bit.ly", code}, _from, state) do
    url = get_full("https://bit.ly/" <> code)
    {:reply, {:ok, url}, state}
  end

  @impl true
  def handle_call({"goo.gl", code}, _from, state) do
    url = get_full("https://goo.gl/" <> code)
    {:reply, {:ok, url}, state}
  end

  @impl true
  def init(state \\ %{}) do
    {:ok, state}
  end
end
