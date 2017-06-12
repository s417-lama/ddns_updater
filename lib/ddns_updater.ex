defmodule DdnsUpdater do
  @moduledoc """
  update client for DDNS written in Elixir.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DdnsUpdater.hello
      :world

  """
  def hello do
    :world
  end

  @doc """
  Send GET request to the url of the specified service for updating DDNS.
  """
  def update("mydns", username, password) do
    {:ok, response} = HTTPoison.get(Application.get_env(:ddns_updater, :mydns_url),
                                    [{"Authorization",
                                      "Basic " <> Base.encode64(Enum.join([username, password], ":"))}])
    response
  end

  def update(_, _, _) do
    DdnsUpdater.CLI.process(:help);
  end

end
