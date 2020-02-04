defmodule ResolverWorker.RPCServer do
  use Freddy.RPC.Server

  import Freddy.RPC.Server, only: [ack: 1, reply: 2]

  def start_link(conn, domain) do
    config = [
      exchange: [name: "301remover-resolver", type: :direct, opts: [durable: false]],
      queue: [name: domain <> "-resolver"],
      routing_keys: [domain],
      # this is protection from DoS
      qos: [prefetch_count: 100],
      # this enables manual acknowledgements
      consumer: [no_ack: false]
    ]

    Freddy.RPC.Server.start_link(__MODULE__, conn, config, [])
  end

  @impl true
  def handle_request(shortcode, meta, state) do
    domain = meta[:routing_key]
    {:ok, resolved_url} = ResolverWorker.resolve(domain, shortcode)
    ack(meta)
    {:reply, resolved_url, state}
  end
end
