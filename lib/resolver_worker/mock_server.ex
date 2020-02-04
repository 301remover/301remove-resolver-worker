defmodule MockServer do
  use Freddy.RPC.Server

  import Freddy.RPC.Server, only: [ack: 1, reply: 2]

  def start_link(conn, _domain) do
    config = [
      exchange: [name: "301remover-resolver", type: :direct, opts: [durable: false]],
      queue: [name: "throwaway"],
      # this is protection from DoS
      qos: [prefetch_count: 100],
      # this enables manual acknowledgements
      consumer: [no_ack: false]
    ]

    Freddy.RPC.Server.start_link(__MODULE__, conn, config, [])
  end

  @impl true
  def handle_request(request, meta, state) do
    ack(meta)
    {:reply, request, state}
  end
end
