defmodule PasswordlessAuth do
  require Logger

  alias PasswordlessAuth.{Repo, Token}

  @doc """
  Generates a new token for the given `email`.

  ### Returns

  - `{:ok, token}` on success.
  - `{:error, :invalid_email}` when email in blank or nil.
  - `{:error, :not_found}` when email not found in store.
  - `{:error, :internal_error, error}` when something else happens.
  """
  def provide_token_for(repo \\ Repo, email)
  def provide_token_for(_, email) when email in [nil, ""], do: {:error, :invalid_email}

  def provide_token_for(repo, email) do
    Logger.info(fn -> "PasswordlessAuth: providing token for #{email} in #{inspect(repo)}" end)

    with true <- Repo.exists?(repo, email),
         {:ok, token} <- Token.generate(email),
         :ok <- Repo.save(repo, email, token) do
      {:ok, token}
    else
      false ->
        {:error, :not_found}

      other ->
        {:error, :internal_error, other}
    end
  end

  @doc """
  Verifies a given token

  ### Returns

  - `{:ok, data}` when token is valid.
  - `{:error, :not_found}` when `token` not found.
  - `{:error, :invalid}` then token is invalid.
  - `{:error, reason}` it here is any other issue like token expiration.
  """
  def verify_token(repo \\ Repo, token) do
    Logger.info(fn -> "PasswordlessAuth: verifying token in #{inspect(repo)}" end)

    repo
    |> Repo.find_by_token(token)
    |> do_verify()
  end

  defp do_verify(nil), do: {:error, :not_found}
  defp do_verify({email, token}), do: Token.verify(token, email)
end
