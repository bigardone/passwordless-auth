defmodule PasswordlessAuthWeb.AdminChannel do
  use PasswordlessAuthWeb, :channel

  require Logger

  def join("admin:lobby", _payload, socket) do
    Logger.info(fn -> "Joining AdminChannel" end)

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
end
