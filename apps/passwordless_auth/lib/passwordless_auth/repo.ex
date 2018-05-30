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

  def exists?(pid \\ @name, email), do: GenServer.call(pid, {:exists, email})

  def save(pid \\ @name, email, token),
    do: GenServer.call(pid, {:save, email, token})

  def fetch(pid \\ @name, email), do: GenServer.call(pid, {:fetch, email})

  def find_by_token(pid \\ @name, token), do: GenServer.call(pid, {:find_by_token, token})

  @impl true
  def init(emails) do
    state = Enum.reduce(emails, %{}, &Map.put(&2, &1, nil))

    {:ok, state}
  end

  @impl true
  def handle_call({:exists, email}, _from, state) do
    Logger.info(fn -> ">> Repo: handling {:exists, #{email}}" end)

    {:reply, Map.has_key?(state, email), state}
  end

  def handle_call({:save, email, token}, _from, state) do
    Logger.info(fn -> ">> Repo: handling {:save_token, #{email}, #{token}}" end)

    if Map.has_key?(state, email) do
      {:reply, :ok, Map.put(state, email, token)}
    else
      {:reply, {:error, :invalid_email}, state}
    end
  end

  def handle_call({:fetch, email}, _from, state) do
    Logger.info(fn -> ">> Repo: handling {:fetch, #{email}}" end)

    {:reply, Map.fetch(state, email), state}
  end

  def handle_call({:find_by_token, token}, _from, state) do
    Logger.info(fn -> ">> Repo: handling {:find_by_token, #{token}}" end)

    {:reply, Enum.find(state, &(elem(&1, 1) == token)), state}
  end
end
