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
    def igniter(igniter, _argv) do
      igniter
      |> Igniter.Project.Formatter.add_formatter_plugin(ColocatedAssets.Formatter)

      # TODO: Add `use ColocatedAssets` to CoreComponents
      # TODO: Add registry that includes CoreComponents
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
