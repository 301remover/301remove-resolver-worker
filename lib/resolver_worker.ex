defmodule ResolverWorker do
  use GenServer

  @moduledoc """
  Documentation for ResolverWorker.
  """

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
  def tinyurl(server_pid, url) do
    GenServer.call(server_pid, {:tiny, url})
  end

  def bitly(server_pid, url) do
    GenServer.call(server_pid, {:bitly, url})
  end

  def handle_call({:tiny, short}) do
    response = HTTPoison.get!(short)
    location = get_loc(response)
    loc = List.first(location)
    url = elem(loc, 1)
    {:reply, :ok, url}
  end

  def handle_call({:bitly, short}) do
    response = HTTPoison.get!(short)
    location = get_loc(response)
    loc = List.first(location)
    url = elem(loc, 1)
    {:reply, :ok, url}
  end

  # GenServer init stuff
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    {:ok, 1}
  end
end
