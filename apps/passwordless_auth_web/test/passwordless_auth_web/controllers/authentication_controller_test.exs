defmodule PasswordlessAuthWeb.AuthenticationControllerTest do
  use PasswordlessAuthWeb.ConnCase

  import PasswordlessAuthWeb.Gettext

  describe "POST /api/auth" do
    test "always returns success message no matter what parameters receives", %{conn: conn} do
      expected = %{"message" => gettext("auth.message")}

      conn = post(conn, authentication_path(conn, :create), email: "foo@test.com")
      assert ^expected = json_response(conn, 200)

      conn = post(conn, authentication_path(conn, :create), %{})
      assert ^expected = json_response(conn, 200)
    end
  end
end
