defmodule DdnsUpdater.Scheduler do
  use GenServer

  def start_link(fun, minutes) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [fun, minutes], name: __MODULE__)
  end

  def exec_now() do
    GenServer.call(__MODULE__, :exec_now)
  end

  def init([fun, minutes]) do
    fun.()
    timer = Process.send_after(__MODULE__, :exec, minutes * 60_000)
    {:ok, {fun, minutes, timer}}
  end

  def handle_call(:exec_now, _from, {fun, minutes, timer}) do
    Process.cancel_timer(timer)
    ret = fun.()
    timer = Process.send_after(__MODULE__, :exec, minutes * 60_000)
    {:reply, ret, {fun, minutes, timer}}
  end

  def handle_info(:exec, {fun, minutes, _timer}) do
    fun.()
    timer = Process.send_after(__MODULE__, :exec, minutes * 60_000)
    {:noreply, {fun, minutes, timer}}
  end

end
