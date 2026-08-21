defmodule XTurnPluginApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :xturn_plugin_api,
      version: "0.1.0",
      elixir: ">= 1.16.0",
      description:
        "Shared plugin contract (behaviour + structs) for xturn data-plane plugins.",
      deps: deps(),
      package: package(),
      docs: [
        extras: ["README.md", "LICENSE.md"],
        main: "readme"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps() do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp package do
    %{
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "LICENSE.md"
      ],
      maintainers: ["Jahred Love"],
      licenses: ["Apache-2.0"],
      links: %{"Github" => "https://github.com/Lazarus404/xturn-plugin-api"}
    }
  end
end
