defmodule ResolverWorker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      {ResolverWorker, []},
      {ShortenerConfigClient, []},
      worker(ResolverWorker.AmqpConnection, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ResolverWorker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
