defmodule Slacker.Channels do
  require Logger

  def channels!() do
    slack_config = Application.get_env(:slacker, :slack)
    url_base = slack_config[:url]
    url_action = "channels.list"
    token = slack_config[:token]
    url = "#{url_base}/#{url_action}?token=#{token}"
    Logger.debug("slack url: #{inspect(url)}")
    resp = HTTPoison.get!(url)
    json = resp.body |> Jason.decode!()
    %{"ok" => true, "channels" => channels} = json
    channels
  end

  def channel_ids() do
    channels!()
    |> Enum.reduce(%{}, fn c, acc ->
      Map.put(acc, c["name"], c["id"])
    end)
  end

  def channel_id(channel) do
    Enum.find(channels!(), fn c ->
      c["name"] == channel
    end)
    |> Map.get("id")
  end
end
