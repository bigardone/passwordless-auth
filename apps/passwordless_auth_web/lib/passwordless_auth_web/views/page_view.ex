defmodule PasswordlessAuthWeb.PageView do
  use PasswordlessAuthWeb, :view

  def socket_url do
    PasswordlessAuthWeb.Endpoint.url()
    |> String.replace("http", "ws")
    |> Kernel.<>("/socket/websocket")
  end
end
