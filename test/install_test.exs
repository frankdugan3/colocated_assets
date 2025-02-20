# Suppress output of testing mix task
# Mix.shell(Mix.Shell.Process)

defmodule ColocatedAssets.Mix.Tasks.Test.InstallTest do
  use ExUnit.Case, async: true

  import Igniter.Test

  describe "install" do
    test "files are patched" do
      app_css = """
      @import 'tailwindcss';
      """

      core_components = ~S|
      defmodule MyAppWeb.CoreComponents do
        use Phoenix.Component

        slot :inner_block, required: true

        def badge(assigns) do
          ~H"""
          <span>{render_slot(@inner_block)}</span>
          """
        end
      end
      |

      files = %{
        "assets/css/app.css" => app_css,
        "lib/my_app_web/components/core_components.ex" => core_components
      }

      igniter =
        [app_name: :my_app, files: files]
        |> test_project()
        |> Igniter.compose_task("colocated_assets.install", [])
        |> assert_has_patch(".formatter.exs", """
        4 + |  plugins: [ColocatedAssets.Formatter],
        5 + |  import_deps: [:colocated_assets]
        """)
        |> assert_has_patch("lib/my_app_web/components/core_components.ex", """
        4 + |  use ColocatedAssets
        """)
        |> assert_has_patch("lib/my_app_web/colocated_assets.ex", """
        1 |defmodule MyAppWeb.ColocatedAssets do
        2 |  use ColocatedAssets.Registry,
        3 |    extract_modules: [
        4 |      MyAppWeb.CoreComponents
        5 |    ]
        6 |end
        """)
        |> assert_has_patch("assets/css/app.css", """
        3 + |@import './colocated_assets.css';
        4 + |
        """)
        |> assert_has_patch(".gitignore", """
        27 + |assets/css/colocated_assets.css
        28 + |assets/js/hooks/colocated_assets_hooks.js
        """)

      assert %{notices: ["Import extracted JS hooks" <> _rest]} = igniter,
             "expected JS instructions in notices"
    end
  end
end
