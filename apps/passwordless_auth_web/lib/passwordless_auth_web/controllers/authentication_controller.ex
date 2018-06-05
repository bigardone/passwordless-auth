defmodule PasswordlessAuthWeb.AuthenticationController do
  use PasswordlessAuthWeb, :controller

  alias PasswordlessAuthWeb.{Emails.AuthEmail, Service.Mailer}

  @email_regex ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/

  def create(conn, params) do
    with %{"email" => email} <- params,
         true <- valid_email?(email),
         {:ok, token} <- PasswordlessAuth.provide_token_for(email) do
      build_and_deliver_email(email, token)
    end

    json(conn, %{message: gettext("auth.message")})
  end

  def valid_email?(email), do: Regex.match?(@email_regex, email)

  defp build_and_deliver_email(email, token) do
    email
    |> AuthEmail.build(token)
    |> Mailer.deliver_later()
  end
end
