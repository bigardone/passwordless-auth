defmodule PasswordlessAuth.Application do
  @moduledoc """
  The PasswordlessAuth Application Service.

  The passwordless_auth system business domain lives in this application.

  Exposes API to clients such as the `PasswordlessAuthWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(
        PasswordlessAuth.Repo,
        [[emails: emails()]]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: PasswordlessAuth.Supervisor)
  end

  defp emails, do: Application.get_env(:passwordless_auth, :repo)[:emails]
end
