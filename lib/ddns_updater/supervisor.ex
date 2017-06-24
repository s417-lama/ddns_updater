defmodule DdnsUpdater.Supervisor do
  use Supervisor

  @doc """
  spawn Supervisor
  """
  def start_link(url, username, password, minutes) do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, [url, username, password, minutes])
  end

  @doc """
  GenServer's callback
  start Updater as a child.
  """
  def init([url, username, password, minutes]) do
    children = [
      worker(DdnsUpdater.Updater, [url, username, password, minutes])
    ]
    supervise children, strategy: :one_for_one
  end
end
