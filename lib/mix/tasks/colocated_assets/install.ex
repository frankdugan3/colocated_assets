if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.ColocatedAssets.Install do
    @moduledoc "Automatic installation of `ColocatedAssets` via `Igniter`."
    @shortdoc @moduledoc

    use Igniter.Mix.Task

    @impl true
    def info(_argv, _parent) do
      %Igniter.Mix.Task.Info{}
    end

    @impl true
    def igniter(igniter) do
      colocated_assets_module =
        igniter
        |> Igniter.Libs.Phoenix.web_module_name("ColocatedAssets")

      extracted_assets_name =
        colocated_assets_module
        |> ColocatedAssets.Registry.filename()

      core_components_module =
        igniter
        |> Igniter.Libs.Phoenix.web_module()
        |> Module.concat("CoreComponents")

      igniter
      |> Igniter.Project.Formatter.add_formatter_plugin(ColocatedAssets.Formatter)
      |> Igniter.Project.Module.find_and_update_module!(core_components_module, fn zipper ->
        zipper
        |> Igniter.Code.Module.move_to_use(Phoenix.Component)
        |> case do
          {:ok, zipper} -> {:ok, zipper |> Igniter.Code.Common.add_code("use ColocatedAssets")}
          _ -> {:ok, zipper}
        end
      end)
      |> Igniter.Project.Module.create_module(colocated_assets_module, """
      use ColocatedAssets.Registry,
        extract_modules: [
          #{core_components_module}
        ]
      """)
      |> Igniter.update_file("assets/css/#{extracted_assets_name}.css", fn css ->
        css <> "\nimport './#{extracted_assets_name}.css'"
      end)
      |> Igniter.add_notice("""
      Import extracted JS hooks in your app.js:

        import * as ColocatedAssetsHooks from './hooks/#{extracted_assets_name}_hooks';

        // ...
        hooks: {
          ...ColocatedAssetsHooks,
        }
      """)
    end
  end
else
  defmodule Mix.Tasks.ColocatedAssets.Install do
    @moduledoc "Automatic installation of `ColocatedAssets` via `Igniter`."
    @shortdoc @moduledoc

    use Mix.Task

    def run(_argv) do
      Mix.shell().error("""
      The colocated_assets installer requires igniter.

      Add igniter to your mix.exs deps:

        {:igniter, "~> 0.5", only: [:dev, :test]},

      Then, run the installer:

        mix igniter.install colocated_assets
      """)

      exit({:shutdown, 1})
    end
  end
end
