use Mix.Config

config :resolver_worker, :amqp,
  host: System.get_env("RABBITMQ_HOST"),
  username: System.get_env("RABBITMQ_USER"),
  password: System.get_env("RABBITMQ_PASS"),
  virtual_host: System.get_env("RABBITMQ_VHOST")
