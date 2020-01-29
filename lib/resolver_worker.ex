defmodule ResolverWorker do
  use GenServer
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

  # @impl true
  def handle_call({:tiny, code}) do
    url = get_full("https://tinyurl.com/" <> code)
    {:reply, {:ok, url}}
  end

  #  @impl true
  def handle_call({:bitly, code}) do
    url = get_full("https://bit.ly/" <> code)
    {:reply, {:ok, url}}
  end

  #  @impl true
  def handle_call({:google, code}) do
    url = get_full("https://goo.gl/" <> code)
    {:reply, {:ok, url}}
  end

  # GenServer init stuff

  # @impl true
  def init(state \\ %{}) do
    {:ok, state}
  end
end
