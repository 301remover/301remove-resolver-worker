defmodule ResoverWorker.RpcServer do
  use Freddy.RPC.Server

  require Logger

  import Freddy.RPC.Server, only: [ack: 1, reply: 2]

  def start_link(conn, handler) when is_function(handler, 1) do
    config = [
      exchange: [name: "301remover", type: :direct, opts: [durable: false]],
      queue: [name: "bit.ly"],
      routing_keys: ["bit.ly"],
      binds: [[routing_key: "bit.ly"]],
      # this is protection from DoS
      qos: [prefetch_count: 100],
      # this enables manual acknowledgements
      consumer: [no_ack: false]
    ]

    Freddy.RPC.Server.start_link(__MODULE__, conn, config, handler)
  end

  @impl true
  def init(handler) do
    {:ok, task_sup} = Task.Supervisor.start_link()

    {:ok, {task_sup, handler}}
  end

  @impl true
  def handle_request(request, meta, {task_sup, handler} = state) do
    Task.Supervisor.start_child(task_sup, fn ->
      result = handler.(request)
      ack(meta)
      reply(meta, result)
    end)

    {:noreply, state}
  end
end
