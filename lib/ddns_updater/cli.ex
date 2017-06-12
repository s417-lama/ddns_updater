defmodule DdnsUpdater.CLI do

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
                               switches: [ help: :boolean ],
                               aliases: [ h: :help ])
    case parse do
      { [ help: true ], _, _ }
        -> :help
      { _, [ service, username, password ], _ }
        -> { service, username, password }
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: ./ddns_updater <service> <username> <password>
    <service>: Specify the name of DDNS service. Only "mydns" is supported now.
    """
    System.halt(0);
  end

  def process({service, username, password}) do
    DdnsUpdater.update(service, username, password)
  end

end
