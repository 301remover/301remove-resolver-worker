defmodule ResolverWorker.AmqpConnection do
  defp start_server(conn, domain) do
    unless "#{Mix.env()}" === "test" do
      ResolverWorker.RPCServer.start_link(conn, domain)
    else
      MockServer.start_link(conn, domain)
    end
  end

  def start_link() do
    {:ok, conn} =
      unless "#{Mix.env()}" === "test" do
        params = Application.get_env(:resolver_worker, :amqp)
        Freddy.Connection.start_link(params)
      else
        Freddy.Connection.start_link(adapter: :sandbox)
      end

    {:ok, _server} = start_server(conn, "bit.ly")
    {:ok, _server} = start_server(conn, "goo.gl")
    {:ok, _server} = start_server(conn, "tinyurl.com")
  end
end
