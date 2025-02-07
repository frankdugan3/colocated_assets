if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.ColocatedAssets.Install do
    @moduledoc "Installs colocated assets by adding the `ColocatedAssets.Formatter` plugin, creating a basic registry, and adding your `CoreComponents` to it."
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
      |> Igniter.compose_task("spark.install")
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
      |> Igniter.add_notice("""
      Import extracted CSS in your app.css:

        import './#{extracted_assets_name}.css';
      """)
      |> Igniter.add_notice("""
      Import extracted JS hooks in your app.js:

        import * as ColocatedHooks from './hooks/#{extracted_assets_name}.js';
        
        // ...
        hooks: {
          ...ColocatedHooks
        }
      """)
    end
  end
else
  defmodule Mix.Tasks.ColocatedAssets.Install do
    @moduledoc "Installs colocated assets by adding the `ColocatedAssets.Formatter` plugin, creating a basic registry, and adding it to your `CoreComponents` file."
    @shortdoc @moduledoc

    use Mix.Task

    def run(_argv) do
      Mix.shell().error("""
      The task 'colocated_assets.install' requires igniter to be run.

      Please install igniter and try again.

      For more information, see: https://hexdocs.pm/igniter
      """)

      exit({:shutdown, 1})
    end
  end
end
