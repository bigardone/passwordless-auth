defmodule PasswordlessAuthWeb.PageController do
  use PasswordlessAuthWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
