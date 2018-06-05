defmodule PasswordlessAuthWeb.AuthenticationControllerTest do
  use PasswordlessAuthWeb.ConnCase
  use Bamboo.Test

  import PasswordlessAuthWeb.Gettext

  alias PasswordlessAuth.Repo
  alias PasswordlessAuthWeb.Emails.AuthEmail

  describe "POST /api/auth" do
    test "always returns success message no matter what parameters receives", %{conn: conn} do
      expected = %{"message" => gettext("auth.message")}

      conn = post(conn, authentication_path(conn, :create), email: "foo@test.com")
      assert ^expected = json_response(conn, 200)

      conn = post(conn, authentication_path(conn, :create), %{})
      assert ^expected = json_response(conn, 200)
    end

    test "delivers the email only when valid email", %{conn: conn} do
      email = "#{__MODULE__}@email.com"
      Repo.add_email(email)

      post(conn, authentication_path(conn, :create), email: email)

      {:ok, token} = Repo.fetch(email)

      assert_delivered_email(AuthEmail.build(email, token))
    end

    test "does not deliver the email only when invalid email format", %{conn: conn} do
      email = "#{__MODULE__}emailcom"
      Repo.add_email(email)

      post(conn, authentication_path(conn, :create), email: email)

      {:ok, token} = Repo.fetch(email)

      refute_delivered_email(AuthEmail.build(email, token))
    end
  end
end
