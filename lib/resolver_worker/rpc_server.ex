defmodule ResolverWorker.RPCServer do
  use Freddy.RPC.Server
  alias ResolverWorker.Resolve

  require Logger

  import Freddy.RPC.Server, only: [ack: 1, reply: 2]

  # TODO: Add additional queue names and routing keys for more shorteners in future sprints 
  def start_link(conn) do
    config = [
      exchange: [name: "301remover-resolver", type: :direct, opts: [durable: false]],
      queue: [name: "bit.ly-resolver"],
      routing_keys: ["bit.ly"],
      binds: [[routing_key: "bit.ly"]],
      # this is protection from DoS
      qos: [prefetch_count: 100],
      # this enables manual acknowledgements
      consumer: [no_ack: false]
    ]

    Freddy.RPC.Server.start_link(__MODULE__, conn, config, [])
  end

  @impl true
  def handle_request(request, meta, state) do
    {:ok, full} = Resolve.resolve(meta[:routing_key], request)
    ack(meta)
    {:reply, full, state}
  end

  @impl true
  def init(handler) do
    {:ok, task_sup} = Task.Supervisor.start_link()

    {:ok, {task_sup, handler}}
  end
end
