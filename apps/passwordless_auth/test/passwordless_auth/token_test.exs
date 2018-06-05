defmodule PasswordlessAuth.TokenTest do
  use ExUnit.Case, async: true

  alias PasswordlessAuth.Token

  describe ".generate/1" do
    test "returns {:error, :invalid} when value is nil" do
      assert {:error, :invalid} = Token.generate(nil)
      assert {:error, :invalid} = Token.generate("")
    end

    test "returns {:ok, token}" do
      assert {:ok, _token} = Token.generate("foo")
    end
  end

  describe ".verify/3" do
    test "returns {:ok, data} when token is valid" do
      {:ok, token} = Token.generate("foo")

      assert {:ok, "foo"} = Token.verify(token, "foo")
    end

    test "returns {:error, :invalid} when token is not valid" do
      {:ok, token} = Token.generate("foo")

      assert {:error, :invalid} = Token.verify(token, "bar")
    end

    test "returns {:error, reason} when token expires" do
      {:ok, token} = Token.generate("foo")

      Process.sleep(150)
      assert {:error, :expired} = Token.verify(token, "foo", 0.1)
    end
  end
end
