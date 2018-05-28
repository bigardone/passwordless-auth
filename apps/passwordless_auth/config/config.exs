use Mix.Config

config :passwordless_auth, :repo, emails: ["valid@email.com"]

import_config "#{Mix.env()}.exs"
