defmodule DdnsUpdater do
  @moduledoc """
  update client for DDNS written in Elixir.
  """

  require Logger

  @doc """
  Send GET request to the url of the specified service for updating DDNS.
  """
  def update("mydns", username, password) do
    result = HTTPoison.get(Application.get_env(:ddns_updater, :mydns_url),
                                    [{"Authorization",
                                      "Basic " <> Base.encode64(Enum.join([username, password], ":"))}])
    handle_response(result)
  end

  def update(_, _, _) do
    DdnsUpdater.CLI.run(:help)
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

end
