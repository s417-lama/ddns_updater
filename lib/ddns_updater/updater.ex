defmodule DdnsUpdater.Updater do
  use GenServer

  require Logger

  @doc """
  Send GET request to the url of the specified service for updating DDNS.
  """
  def update(url, username, password) do
    result = HTTPoison.get(url, [{"Authorization", "Basic " <> Base.encode64(Enum.join([username, password], ":"))}])
    handle_response(result)
  end

  @doc """
  Handle the response from HTTPoison.get
  """
  def handle_response({:ok, %{status_code: 200}}) do
    Logger.info "Update successed."
    :ok
  end

  def handle_response({:ok, %{status_code: code, body: body}}) do
    Logger.error "Update failed (#{code}): #{inspect body}"
    :error
  end

  def handle_response({:error, reason}) do
    Logger.error "Failed to get the response: #{HTTPoison.Error.message(reason)}"
    :error
  end

  @doc """
  Spawn GenServer
  """
  def start_link(url, username, password) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [url, username, password], name: __MODULE__)
  end

  @doc """
  call GenServer to update
  """
  def exec() do
    GenServer.call(__MODULE__, :exec)
  end

  @doc """
  Genserver's callback
  """
  def init([url, username, password]) do
    {:ok, {url, username, password}}
  end

  @doc """
  Genserver's callback
  :exec: execute update
  """
  def handle_call(:exec, _from, acc = {url, username, password}) do
    update(url, username, password)
    {:noreply, acc}
  end

end
