defmodule PasswordlessAuthWeb.PageController do
  use PasswordlessAuthWeb, :controller

  def index(conn, params) do
    conn
    |> assign(:token, Map.get(params, "token", ""))
    |> render("index.html")
  end
end
