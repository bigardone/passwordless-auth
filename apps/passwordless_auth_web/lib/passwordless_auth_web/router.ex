defmodule PasswordlessAuthWeb.Router do
  use PasswordlessAuthWeb, :router

  if Mix.env() == :dev, do: forward("/sent_emails", Bamboo.EmailPreviewPlug)

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PasswordlessAuthWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/*path", PageController, :index)
  end

  # Other scopes may use custom stacks.
  scope "/api", PasswordlessAuthWeb do
    pipe_through(:api)

    post("/auth", AuthenticationController, :create)
  end
end
