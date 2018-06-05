defmodule PasswordlessAuth.Repo do
  @moduledoc """
  Emails and authentication tokens in-memory repository
  """
  use GenServer

  require Logger

  @name __MODULE__

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @name)
    {:ok, emails} = Keyword.fetch(opts, :emails)

    GenServer.start_link(__MODULE__, emails, opts)
  end

  @doc """
  Checks if given email exists in the repo.
  """
  def exists?(pid \\ @name, email),
    do: GenServer.call(pid, {:exists, email})

  @doc """
  Saves a token for a given email, if the email exists.
  """
  def save(pid \\ @name, email, token),
    do: GenServer.call(pid, {:save, email, token})

  @doc """
  Fetches the token for a given email.
  """
  def fetch(pid \\ @name, email),
    do: GenServer.call(pid, {:fetch, email})

  @doc """
  Returns a tuple with the email and the token.
  """
  def find_by_token(pid \\ @name, token),
    do: GenServer.call(pid, {:find_by_token, token})

  @doc """
  Adds a new email to the repository. Only used for
  testing purposes.
  """
  def add_email(pid \\ @name, email),
    do: GenServer.call(pid, {:add_email, email})

  @doc """
  Resets a token for a given email.
  """
  def invalidate(pid \\ @name, email),
    do: GenServer.call(pid, {:invalidate, email})

  @impl true
  def init(emails) when is_list(emails) and length(emails) > 0 do
    state = Enum.reduce(emails, %{}, &Map.put(&2, &1, nil))

    {:ok, state}
  end

  def init(_), do: {:stop, "Invalid list of emails"}

  @impl true
  def handle_call({:exists, email}, _from, state) do
    Logger.info(fn -> "Repo: handling {:exists, #{email}}" end)

    {:reply, Map.has_key?(state, email), state}
  end

  def handle_call({:save, email, token}, _from, state) do
    Logger.info(fn -> "Repo: handling {:save_token, #{email}, #{token}}" end)

    if Map.has_key?(state, email) do
      {:reply, :ok, Map.put(state, email, token)}
    else
      {:reply, {:error, :invalid_email}, state}
    end
  end

  def handle_call({:fetch, email}, _from, state) do
    Logger.info(fn -> "Repo: handling {:fetch, #{email}}" end)

    {:reply, Map.fetch(state, email), state}
  end

  def handle_call({:find_by_token, token}, _from, state) do
    Logger.info(fn -> "Repo: handling {:find_by_token, #{token}}" end)

    {:reply, Enum.find(state, &(elem(&1, 1) == token)), state}
  end

  def handle_call({:add_email, email}, _from, state) do
    Logger.info(fn -> "Repo: handling {:add_email, #{email}" end)

    if Map.has_key?(state, email) do
      {:reply, {:error, :email_exists}, state}
    else
      {:reply, :ok, Map.put(state, email, "")}
    end
  end

  def handle_call({:invalidate, email}, _from, state) do
    Logger.info(fn -> "Repo: handling {:invalidate, #{email}}" end)

    if Map.has_key?(state, email) do
      {:reply, :ok, Map.put(state, email, nil)}
    else
      {:reply, {:error, :invalid_email}, state}
    end
  end
end
