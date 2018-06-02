defmodule PasswordlessAuthWeb.UserSocket do
  use Phoenix.Socket

  require Logger

  alias PasswordlessAuth

  ## Channels
  channel("admin:*", PasswordlessAuthWeb.AdminChannel)

  ## Transports
  transport(:websocket, Phoenix.Transports.WebSocket)

  def connect(%{"token" => token}, socket) do
    Logger.info(fn -> "UserSocket: connecting with token: #{token}" end)

    case PasswordlessAuth.verify_token(token) do
      {:ok, email} ->
        Logger.info(fn -> "UserSocket: connection success" end)

        {:ok, assign(socket, :user, %{email: email})}

      other ->
        Logger.info(fn -> "UserSocket: connection error #{inspect(other)}" end)
        :error
    end
  end

  def connect(_, _socket), do: :error

  def id(socket), do: "user_socket:#{socket.assigns.user.email}"
end
