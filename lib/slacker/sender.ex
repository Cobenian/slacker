defmodule Slacker.Sender do
  def start_link do
    pid = spawn(&message_sender/0)
    {:ok, pid}
  end

  def message_sender() do
    receive do
      msg ->
        Slacker.Slack.send_message(msg)
    end
  end
end
