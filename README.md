# Slacker

![Slacker](https://goodmenproject.com/wp-content/uploads/2011/02/slacker.jpg)


Slacker is an OTP application for sending messages to slack.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add slacker to your list of dependencies in `mix.exs`:

        def deps do
          [{:slacker, "~> 0.0.1"}]
        end

  2. Ensure slacker is started before your application:

        def application do
          [applications: [:slacker]]
        end

  3. Configure the slack connection in `config/config.exs`

        config :slacker, :slack,
          enabled: true,
          url: "https://slack.com/api",
          url_action: "/chat.postMessage",
          channel: "devops",
          botname: "ops"

  4. Configure the slack API key in `config/<env>.exs`

        config :slacker, :slack,
          token: "<api token goes here>"

## Usage

```elixir
Slacker.Slack.send_message("<message goes here>")
```

The message must be a string so if there is any doubt that it is not a string
do the following:

```elixir
Slacker.Slack.send_message("#{inspect <value-to-send>}")
```
