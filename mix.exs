defmodule XTurnPluginApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :xturn_plugin_api,
      version: "0.1.0",
      elixir: ">= 1.16.0",
      description:
        "Shared plugin contract (behaviour + structs) for xturn data-plane plugins.",
      deps: []
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end
end
