defmodule Littlechat.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Littlechat.Repo,
      # Start the Telemetry supervisor
      LittlechatWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Littlechat.PubSub},
      # Start the Endpoint (http/https)
      LittlechatWeb.Endpoint,
      # Start our Presence module.
      LittlechatWeb.Presence,
    ]

    opts = [strategy: :one_for_one, name: Littlechat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    LittlechatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
