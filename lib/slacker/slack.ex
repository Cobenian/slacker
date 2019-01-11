defmodule Slacker.Slack do
  require Logger

  @doc """
  The slack documentation says that you should be able to use #channel_name
  however real world tests have proven that it doesn't work.  Rather than
  check some crazy id into the config file that could be wrong from environment
  to environment, we have some code that looks up the channel id based on the
  channel name.
  """
  def send_message(msg) do
    spawn(fn -> do_send_message!(nil, msg) end)
  end

  def send_message(channel_name, msg) when is_binary(channel_name) do
    spawn(fn -> do_send_message!(channel_name, msg) end)
  end

  @doc """
  Send a message to the slack channel for the configured account.
  """
  def do_send_message!(nil, msg) do
    slack_config = Application.get_env(:slacker, :slack)
    channel_name = slack_config[:channel]

    if channel_name == nil do
      raise "You did not configure the default slack channel"
    end

    do_send_message!(channel_name, msg)
  end

  def do_send_message!(channel_name, msg) do
    channel_id = Slacker.ChannelId.get_id(channel_name)

    if channel_id do
      send_message_to_channel_id(channel_id, msg)
    else
      Logger.warn(
        "No channel id found for channel: #{channel_name}. NOT sending msg: #{inspect(msg)}"
      )
    end
  end

  def send_message_to_channel_id(channel_id, msg) do
    slack_config = Application.get_env(:slacker, :slack)
    enabled = slack_config[:enabled]

    if enabled do
      token = slack_config[:token]
      botname = slack_config[:botname]
      url_base = slack_config[:url]
      url_action = slack_config[:url_action]

      url =
        "#{url_base}#{url_action}?token=#{token}&channel=#{channel_id}&username=#{botname}&text=#{
          msg
        }"

      Logger.debug("slack message url: #{inspect(url)}")
      body = [text: msg]
      resp = HTTPoison.post!(URI.encode(url), {:form, body})
      Logger.debug("slack response: #{inspect(resp)}")
      rc = resp.status_code
      ok = resp.body |> Jason.decode!() |> Map.get("ok")

      if rc == 200 and ok do
        Logger.debug("sent message to slack ok")
      else
        Logger.warn("error sending message to slack")
      end
    else
      Logger.debug("ignoring slack messages...")
    end
  end
end
