use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :passwordless_auth_web, PasswordlessAuthWeb.Endpoint,
  http: [port: 4001],
  server: false

# Bamboo mailer configuration
config :passwordless_auth_web,
       PasswordlessAuthWeb.Service.Mailer,
       adapter: Bamboo.TestAdapter
