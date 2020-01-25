defmodule ResolverWorker.AmqpConnection do
  def start_link() do
    params = Application.get_env(:resolver_worker, :amqp)

    unless "#{Mix.env()}" === "test" do
      {:ok, conn} = Freddy.Connection.start_link(params)
      {:ok, _server} = ResolverWorker.RPCServer.start_link(conn)
    else
      {:ok, conn} = Freddy.Connection.start_link(adapter: :sandbox)
      {:ok, _server} = MockServer.start_link(conn)
    end
  end
end
