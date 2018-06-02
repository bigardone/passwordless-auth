defmodule PasswordlessAuthWeb.AdminChannelTest do
  use PasswordlessAuthWeb.ChannelCase, async: true

  alias PasswordlessAuth.Repo
  alias PasswordlessAuthWeb.{AdminChannel, UserSocket}

  setup do
    email = "foo@#{__MODULE__}.com"
    Repo.add_email(email)
    {:ok, token} = PasswordlessAuth.provide_token_for(email)
    {:ok, socket} = connect(UserSocket, %{"token" => token})

    {:ok, socket: socket, email: email}
  end

  describe "join/3" do
    test "returns assigned user", %{socket: socket, email: email} do
      assert {:ok, %{email: ^email}, _} = join(socket, AdminChannel, "admin:lobby")
    end
  end

  describe "handle_in/3" do
    test "ping replies with status ok", %{socket: socket} do
      {:ok, _, socket} = subscribe_and_join(socket, AdminChannel, "admin:lobby")
      ref = push(socket, "ping", %{"hello" => "there"})
      assert_reply(ref, :ok, %{"hello" => "there"})
    end
  end

  describe "broadcast" do
    test "shout broadcasts to admin:lobby", %{socket: socket} do
      {:ok, _, socket} = subscribe_and_join(socket, AdminChannel, "admin:lobby")
      push(socket, "shout", %{"hello" => "all"})
      assert_broadcast("shout", %{"hello" => "all"})
    end

    test "broadcasts are pushed to the client", %{socket: socket} do
      {:ok, _, socket} = subscribe_and_join(socket, AdminChannel, "admin:lobby")
      broadcast_from!(socket, "broadcast", %{"some" => "data"})
      assert_push("broadcast", %{"some" => "data"})
    end
  end
end
