defmodule PasswordlessAuth do
  require Logger

  alias PasswordlessAuth.{Repo, Token}

  def provide_token_for(repo \\ Repo, email)
  def provide_token_for(_, email) when email in [nil, ""], do: {:error, :invalid_email}

  def provide_token_for(repo, email) do
    with true <- Repo.exists?(repo, email),
         {:ok, token} <- Token.generate(email),
         :ok <- save(repo, email, token) do
      {:ok, token}
    else
      false ->
        {:error, :not_found}

      other ->
        {:error, :internal_error, other}
    end
  end

  def verify_token(repo \\ Repo, token) do
    repo
    |> Repo.find_by_token(token)
    |> do_verify()
  end

  defp save(repo, email, token), do: Repo.save(repo, email, token)

  defp do_verify(nil), do: {:error, :not_found}

  defp do_verify({email, token}), do: Token.verify(token, email)
end
