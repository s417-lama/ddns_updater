defmodule DdnsUpdater.CLI do

  @default_minutes 10

  def main(argv) do
    argv
    |> parse_args
    |> process
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

  def process(:help) do
    IO.puts """
    usage: ./ddns_updater <service> <username> <password> (<minutes>)
    <service>: Specify the name of DDNS service. Only "mydns" is supported now.
    <minutes>: Set the interval between updates in minutes. Default value is 10.
    """
    System.halt(0);
  end

  def process({service, username, password, minutes}) do
    DdnsUpdater.Scheduler.loop(
      fn -> DdnsUpdater.update(service, username, password) end,
      minutes)
  end

end
