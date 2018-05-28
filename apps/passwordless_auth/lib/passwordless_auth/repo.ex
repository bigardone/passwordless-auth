defmodule PasswordlessAuth.Repo do
  @moduledoc """
  Emails and authentication tokens in-memory repository
  """
  use GenServer

  require Logger

  @name __MODULE__
  @token_max_age :timer.minutes(5)

  def start_link(opts) do
    {emails, opts} =
      opts
      |> Keyword.put_new(:name, @name)
      |> Keyword.pop(:emails)

    GenServer.start_link(__MODULE__, emails, opts)
  end

  def valid_email?(pid \\ @name, email), do: GenServer.call(pid, {:valid_email, email})

  def save(pid \\ @name, email, token),
    do: GenServer.call(pid, {:save, email, token})

  def fetch(pid \\ @name, email), do: GenServer.call(pid, {:fetch, email})

  def find_by_token(pid \\ @name, token), do: GenServer.call(pid, {:find_by_token, token})

  @impl GenServer
  def init(emails) do
    state = Enum.reduce(emails, %{}, &Map.put(&2, &1, nil))

    {:ok, state}
  end

  @impl GenServer
  def handle_call({:valid_email, email}, _from, state) do
    Logger.info(fn -> ">> Repo: handling {:find_email, #{email}}" end)

    {:reply, Map.has_key?(state, email), state}
  end

  def handle_call({:save, email, token}, _from, state) do
    Logger.info(fn -> ">> Repo: handling {:save_token, #{email}, #{token}}" end)

    {:reply, :ok, Map.put(state, email, token)}
  end

  def handle_call({:fetch, email}, _from, tokens) do
    Logger.info(fn -> ">> Repo: handling {:fetch, #{email}}" end)

    {:reply, Map.fetch(tokens, email), tokens}
  end

  def handle_call({:find_by_token, token}, _from, tokens) do
    Logger.info(fn -> ">> Repo: handling {:find_by_token, #{token}}" end)

    {:reply, Enum.find(tokens, &(elem(&1, 1) == token)), tokens}
  end
end
