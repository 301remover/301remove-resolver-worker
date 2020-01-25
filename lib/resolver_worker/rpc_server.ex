defmodule ResolverWorker.RPCServer do
  use Freddy.RPC.Server
  alias DatabaseWorker.Storage

  import Freddy.RPC.Server, only: [ack: 1, reply: 2]

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
  def handle_request(_request, meta, state) do
    ack(meta)
    {:reply, "resolved url", state}
  end

  def init(handler) do
    {:ok, task_sup} = Task.Supervisor.start_link()

    {:ok, {task_sup, handler}}
  end
end
