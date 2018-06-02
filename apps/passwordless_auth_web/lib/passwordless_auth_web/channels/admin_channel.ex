defmodule PasswordlessAuthWeb.AdminChannel do
  use PasswordlessAuthWeb, :channel

  require Logger

  def join("admin:lobby", _payload, socket) do
    Logger.info(fn -> "AdminChannel: Joining" end)

    {:ok, socket.assigns.user, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (admin:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("data", _, socket) do
    Logger.info(fn -> "AdminChannel: handling data" end)

    admin_emails = Application.get_env(:passwordless_auth, :repo)[:emails]

    {:reply, {:ok, %{data: admin_emails}}, socket}
  end
end
