defmodule PasswordlessAuthWeb.AuthenticationController do
  use PasswordlessAuthWeb, :controller

  alias PasswordlessAuth.Service.Mailer
  alias PasswordlessAuthWeb.Emails.AuthEmail

  def create(conn, params) do
    with %{"email" => email} <- params,
         {:ok, token} <- PasswordlessAuth.provide_token_for(email) do
      build_and_deliver_email(email, token)
    end

    json(conn, %{
      message: gettext("auth.message")
    })
  end

  defp build_and_deliver_email(email, token) do
    email
    |> AuthEmail.build(token)
    |> Mailer.deliver_later()
  end
end
