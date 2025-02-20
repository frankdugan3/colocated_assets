defmodule ColocatedAssets.MixProject do
  use Mix.Project

  @version "0.0.1"
  @source_url "https://github.com/frankdugan3/colocated_assets"
  @app :colocated_assets

  def project do
    [
      app: @app,
      description: "An experimental solution for colocated assets in Phoenix LiveView.",
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        name: @app,
        maintainers: ["Frank Dugan III"],
        links: %{
          "GitHub" => @source_url
        },
        licenses: ["MIT"],
        files: [
          "lib",
          "documentation",
          "CHANGELOG*",
          "LICENSE*",
          "mix.exs",
          ".formatter.exs"
        ]
      ],
      docs: [
        main: "about",
        source_url: @source_url,
        source_ref: "v#{@version}",
        extra_section: "Guides",
        extras: extras(),
        groups_for_extras: [
          Tutorials: [~r'documentation/tutorials']
        ]
      ],
      preferred_cli_env: [
        "test.watch": :test
      ],
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  defp extras do
    ordered =
      [
        {"documentation/about.md", [default: true]},
        "CHANGELOG.md",
        "documentation/tutorials/get-started.md"
      ]

    unordered = Path.wildcard("documentation/**/*.{md,cheatmd,livemd}")

    Enum.uniq_by(ordered ++ unordered, fn
      {file, _opts} -> file
      file -> file
    end)
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, ">= 0.0.0", only: [:dev], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:doctor, ">= 0.0.0", only: [:dev], runtime: false},
      {:ex_check, "~> 0.14.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:git_ops, "~> 2.0", only: [:dev]},
      {:igniter, "~> 0.5", optional: true},
      {:mix_audit, ">= 0.0.0", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
