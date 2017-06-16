defmodule DdnsUpdater.Supervisor do
  use Supervisor

  def start_link(fun, minutes) do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, [fun, minutes])
  end

  def init([fun, minutes]) do
    children = [
      worker(DdnsUpdater.Scheduler, [fun, minutes])
    ]
    supervise children, strategy: :one_for_one
  end
end
