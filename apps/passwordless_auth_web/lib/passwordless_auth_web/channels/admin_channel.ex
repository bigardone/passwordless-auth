defmodule PasswordlessAuthWeb.AdminChannel do
  use PasswordlessAuthWeb, :channel

  require Logger

  alias PasswordlessAuth.Repo

  def join("admin:lobby", _payload, socket) do
    Logger.info(fn -> "AdminChannel: Joining" end)

    {:ok, socket.assigns.user, socket}
  end

  def handle_in("data", _, socket) do
    Logger.info(fn -> "AdminChannel: handling data" end)

    admin_emails = Application.get_env(:passwordless_auth, :repo)[:emails]

    {:reply, {:ok, %{data: admin_emails}}, socket}
  end

  def handle_in("sign_out", _, socket) do
    Logger.info(fn -> "AdminChannel: handling sign_out" end)

    email = socket.assigns.user.email
    :ok = Repo.invalidate(email)

    {:reply, {:ok, %{success: true}}, socket}
  end

  def terminate(reason, socket) do
    Logger.info(fn -> "AdminChannel: terminating with reason #{inspect(reason)}" end)

    {:noreply, socket}
  end
end
