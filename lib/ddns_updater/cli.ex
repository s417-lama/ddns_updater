defmodule DdnsUpdater.CLI do

  require Logger
  
  @default_minutes 10

  def main(argv) do
    argv
    |> parse_args
    |> run
    |> wait_for_finishing
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
                               switches: [help: :boolean],
                               aliases: [h: :help])
    case parse do
      {[help: true], _, _} -> 
        :help
      {_, [service, username, password], _} ->
        {service, username, password, @default_minutes}
      {_, [service, username, password, minutes], _} ->
        {service, username, password, String.to_integer(minutes)}
      _ ->
        :help
    end
  end

  def run(:help) do
    IO.puts """
    usage: ./ddns_updater <service> <username> <password> (<minutes>)
    <service>: Specify the name of DDNS service. Only "mydns" is supported now.
    <minutes>: Set the interval between updates in minutes. Default value is 10.
    """
    System.halt(0);
  end

  def run({service, username, password, minutes}) do
    {:ok, pid} = DdnsUpdater.Supervisor.start_link(
      fn -> DdnsUpdater.update(service, username, password) end,
      minutes)
    pid
  end

  def wait_for_finishing(pid) do
    Process.flag(:trap_exit, true)
    receive do
      {:EXIT, ^pid, reason} ->
        Logger.error "EXIT (#{inspect reason})"
    end
  end

end
