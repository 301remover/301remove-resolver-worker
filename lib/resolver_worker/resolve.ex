defmodule ResolverWorker.Resolve do
  use GenServer

  @moduledoc """
  Documentation for ResolverWorker.
  """

  def start_link(default) when is_list(default) do
    state = %{}
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
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

  defp get_full(url) do
    url
    |> HTTPoison.get!()
    |> get_loc
    |> List.first()
    |> elem(1)
  end

  # TODO: check for more uses than accepted rate and cut off queue for future sprint
  defp increment_time(state, shortener) do
    # if the state doesn't have shortener
    if !Map.has_key?(state, shortener) do
      Kernel.put_in(state, [shortener], %{rem(System.monotonic_time(:second), 60) => 1})
    else
      # get specific shortener map
      val =
        Map.get(state, shortener)
        # get the last entry of the map
        |> Enum.take(-1)
        # get the tuple of last entry
        |> List.last()
        # get second element of tuple
        |> elem(1)
        # increment by one
        |> Kernel.+(1)

      Kernel.put_in(state, [shortener, rem(System.monotonic_time(:second), 60)], val)
    end
  end

  @doc """
  Handles a call back for tinyurl, bit.ly and goo.gl links
  """
  @impl true
  def handle_call({:tiny, code}, _from, state) do
    url = get_full("https://tinyurl.com/" <> code)
    {:reply, {:ok, url}, increment_time(state, :tiny)}
  end

  @impl true
  def handle_call({:bitly, code}, _from, state) do
    url = get_full("https://bit.ly/" <> code)
    {:reply, {:ok, url}, increment_time(state, :bitly)}
  end

  @impl true
  def handle_call({:google, code}, _from, state) do
    url = get_full("https://goo.gl/" <> code)
    {:reply, {:ok, url}, increment_time(state, :google)}

  # GenServer init stuff

  @impl true
  def init(state) do
    {:ok, state}
  end
end
