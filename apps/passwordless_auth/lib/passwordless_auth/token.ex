defmodule PasswordlessAuth.Token do
  @moduledoc """
  Token helper module
  """

  require Logger

  alias Phoenix.Token, as: PhoenixToken

  @salt "token salt"
  @max_age :timer.minutes(5) / 1000
  @context Application.get_env(:passwordless_auth, :token)[:secret_key_base]

  def generate(nil), do: {:error, :invalid}

  def generate(data) do
    {:ok, PhoenixToken.sign(@context, @salt, data)}
  end

  def verify(token, data, max_age \\ @max_age) do
    case PhoenixToken.verify(
           @context,
           @salt,
           token,
           max_age: max_age
         ) do
      {:ok, ^data} ->
        Logger.info(fn -> "Token: valid value" end)
        :ok

      {:ok, _other} ->
        Logger.info(fn -> "Token: invalid value" end)
        {:error, :invalid}

      {:error, reason} ->
        Logger.info(fn -> "Token: invalid value, reason: #{inspect(reason)}" end)
        {:error, reason}
    end
  end
end
