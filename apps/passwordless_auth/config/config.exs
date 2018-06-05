use Mix.Config

config :passwordless_auth,
       :repo,
       emails: ~w(foo@email.com bar@email.com baz@email.com)

config :passwordless_auth,
       PasswordlessAuth.Token,
       secret_key_base: "Dmh48eAtU+zgDDQ/b3zy5xlkWhHVnA0DcmHbh7vqGvbExlU0p7nd2ng165VfvJsu"

import_config "#{Mix.env()}.exs"
