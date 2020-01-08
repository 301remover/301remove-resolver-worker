use Mix.Config

config :resolver_worker, :amqp,
  host: "localhost",
  username: "301remover",
  password: "your_password_here",
  virtual_host: ""
