defmodule PasswordlessAuthWeb.UserSocketTest do
  use PasswordlessAuthWeb.ChannelCase, async: true

  alias Phoenix.Socket
  alias PasswordlessAuth.Repo
  alias PasswordlessAuthWeb.UserSocket

  describe "connect/2" do
    test "errors when passing invalid params or token" do
      assert :error = connect(UserSocket, %{})
      assert :error = connect(UserSocket, %{"token" => "invalid-token"})
    end

    test "joins when passing valid token" do
      email = "foo@#{__MODULE__}.com"
      :ok = Repo.add_email(email)
      {:ok, token} = PasswordlessAuth.provide_token_for(email)

      assert {:ok, %Socket{assigns: %{user: %{email: ^email}}}} =
               connect(UserSocket, %{"token" => token})
    end
  end
end
