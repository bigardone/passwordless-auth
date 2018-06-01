use Mix.Config

config :passwordless_auth, :repo, emails: ["valid@email.com"]

config :passwordless_auth, :token,
  secret_key_base: "Dmh48eAtU+zgDDQ/b3zy5xlkWhHVnA0DcmHbh7vqGvbExlU0p7nd2ng165VfvJsu"

config :passwordless_auth, PasswordlessAuth.Mailer, adapter: Bamboo.LocalAdapter

import_config "#{Mix.env()}.exs"
