defmodule DdnsUpdater do
  @moduledoc """
  update client for DDNS written in Elixir.
  """

  require Logger

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
    result = HTTPoison.get(Application.get_env(:ddns_updater, :mydns_url),
                                    [{"Authorization",
                                      "Basic " <> Base.encode64(Enum.join([username, password], ":"))}])
    case result do
      {:ok, response} ->
        response
      {:error, reason} ->
        Logger.error "Failed to get the response: #{HTTPoison.Error.message(reason)}"
        exit "Failed to connect to server."
    end
  end

  def update(_, _, _) do
    DdnsUpdater.CLI.process(:help);
  end

end
