defmodule PasswordlessAuth.Token do
  @moduledoc """
  Token helper module
  """

  require Logger

  alias Phoenix.Token, as: PhoenixToken

  @salt "token salt"
  @max_age :timer.minutes(5) / 1000
  @secret Application.get_env(:passwordless_auth, __MODULE__)[:secret_key_base]

  @doc """
  Generates token for the given data.

  ### Returns

  - `{:ok, token}` on success
  - `{:error, :invalid}` when data is empty string or nil
  """
  def generate(data) when data in [nil, ""], do: {:error, :invalid}

  def generate(data) do
    {:ok, PhoenixToken.sign(@secret, @salt, data)}
  end

  @doc """
  Verifies the `token` against the given `data`.

  ### Returns

  - `{:ok, data}` when token is valid.
  - `{:error, :invalid}` then token is invalid.
  - `{:error, reason}` it here is any other issue like token expiration.
  """
  def verify(token, data, max_age \\ @max_age) do
    case PhoenixToken.verify(
           @secret,
           @salt,
           token,
           max_age: max_age
         ) do
      {:ok, ^data} ->
        Logger.info(fn -> "Token: valid value" end)
        {:ok, data}

      {:ok, _other} ->
        Logger.info(fn -> "Token: invalid value" end)
        {:error, :invalid}

      {:error, reason} ->
        Logger.info(fn -> "Token: invalid value, reason: #{inspect(reason)}" end)
        {:error, reason}
    end
  end
end
