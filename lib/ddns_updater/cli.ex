defmodule DdnsUpdater.CLI do

  require Logger
  
  @default_minutes 10

  @doc """
  The main function that will be called first.
  """
  def main(argv) do
    argv
    |> parse_args
    |> run
    |> loop
  end

  @doc """
  parse arguments and show help if arguments are invalid.
  """
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

  @doc """
  show help texts to standard output.
  """
  def show_help do
    IO.puts """
    usage: ./ddns_updater <service> <username> <password> (<minutes>)
    <service>: Specify the name of DDNS service. Only "mydns" is supported now.
    <minutes>: Set the interval between updates in minutes. Default value is 10.
    """
  end

  @doc """
  run supervisor and updater
  """
  def run(:help) do
    show_help()
    System.halt(0)
  end

  def run({"mydns", username, password, minutes}) do
    {:ok, _pid} = DdnsUpdater.Supervisor.start_link(
      Application.get_env(:ddns_updater, :mydns_url), username, password
    )
    minutes
  end

  def run(_) do
    show_help()
    System.halt(0)
  end

  @doc """
  call Updater every specified minutes forever.
  """
  def loop(minutes) do
    DdnsUpdater.Updater.exec()
    :timer.sleep(minutes * 60_000)
    loop(minutes)
  end

end
