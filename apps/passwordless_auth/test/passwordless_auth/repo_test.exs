defmodule PasswordlessAuth.RepoTest do
  use ExUnit.Case, async: true

  alias PasswordlessAuth.Repo

  describe ".init/1" do
    test "returns error when emails are wrong" do
      Process.flag(:trap_exit, true)

      name = :repo_test_1
      Repo.start_link(name: name, emails: "")

      assert_receive {:EXIT, _, "Invalid list of emails"}
    end

    test "starts the repo when emails is a list" do
      name = :repo_test_1
      assert {:ok, _pid} = Repo.start_link(name: name, emails: ["foo@email.com"])
    end
  end

  describe ".exists?/2" do
    test "returns true when passed email is in the repo's state" do
      name = :repo_test_2
      email = "foo@test.com"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])

      assert Repo.exists?(name, email)
    end

    test "returns false when passed email no it repo's state" do
      name = :repo_test_3
      email = "foo@test.com"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])

      refute Repo.exists?(name, "not_found@test.com")
    end
  end

  describe ".save/3" do
    test "returns :ok and sets token value in state when email exists" do
      name = :repo_test_4
      email = "foo@test.com"
      token = "token-value"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])

      assert :ok = Repo.save(name, email, token)
      assert %{"foo@test.com" => ^token} = :sys.get_state(name)
    end

    test "returns {:error, :invalid_email} when email does not exist" do
      name = :repo_test_5
      email = "foo@test.com"
      token = "token-value"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])

      assert {:error, :invalid_email} = Repo.save(name, "bar@test.com", token)
    end
  end

  describe ".fetch/2" do
    test "returns {:ok, token} for passed email" do
      name = :repo_test_6
      email = "foo@test.com"
      token = "token-value"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])
      :ok = Repo.save(name, email, token)

      assert {:ok, ^token} = Repo.fetch(name, email)
    end

    test "returns :error when token not found" do
      name = :repo_test_7
      email = "foo@test.com"
      token = "token-value"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])
      :ok = Repo.save(name, email, token)

      assert :error = Repo.fetch(name, "not_found@test.com")
    end
  end

  describe ".find_by_token/2" do
    test "returns {email, token} when token exists" do
      name = :repo_test_8
      email = "foo@test.com"
      token = "token-value"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])
      :ok = Repo.save(name, email, token)

      assert {^email, ^token} = Repo.find_by_token(name, token)
    end

    test "returns nil when token not found" do
      name = :repo_test_9
      email = "foo@test.com"
      token = "token-value"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])
      :ok = Repo.save(name, email, token)

      assert nil == Repo.find_by_token(name, "other-token")
    end
  end

  describe ".invalidate/2" do
    test "returns :ok and sets token value to nil when email exists" do
      name = :repo_test_10
      email = "foo@test.com"
      token = "token-value"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])
      :ok = Repo.save(name, email, token)

      assert :ok = Repo.invalidate(name, email)
      assert %{"foo@test.com" => nil} = :sys.get_state(name)
    end

    test "returns {:error, :invalid_email} when email does not exist" do
      name = :repo_test_11
      email = "foo@test.com"
      {:ok, _pid} = Repo.start_link(name: name, emails: [email])

      assert {:error, :invalid_email} = Repo.invalidate(name, "bar@test.com")
    end
  end
end
