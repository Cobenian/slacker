defmodule Slacker.ChannelId do
  # 6 hours
  @seconds_between_fetches 21600

  require Logger

  def start_link do
    Agent.start_link(fn -> {nil, %{}} end, name: __MODULE__)
  end

  def get_id(channel_name) do
    if fetch_needed?() do
      fetch_ids()
    end

    id_for_channel(channel_name)
  end

  def fetch_ids() do
    try do
      ids = Slacker.Channels.channel_ids()
      Agent.update(__MODULE__, fn _old -> {:calendar.universal_time(), ids} end)
    rescue
      e ->
        Logger.warn("Unable to fetch ids from Slack: " <> Exception.message(e))
    end
  end

  def id_for_channel(channel_name) do
    Agent.get(__MODULE__, fn {_fetched_at, ids} -> ids[channel_name] end)
  end

  def ids() do
    Agent.get(__MODULE__, fn {_fetched_at, ids} -> ids end)
  end

  def fetch_needed?() do
    fetched_at = Agent.get(__MODULE__, fn {fetched_at, _ids} -> fetched_at end)
    time_since_last_fetch = secs(:calendar.universal_time()) - secs(fetched_at)
    time_since_last_fetch > @seconds_between_fetches
  end

  defp secs(nil), do: 0
  defp secs(datetime), do: :calendar.datetime_to_gregorian_seconds(datetime)
end
