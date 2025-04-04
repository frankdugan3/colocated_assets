defmodule ColocatedAssets.Registry do
  @moduledoc """
  Extracts CSS and JS Hooks from registered modules.

  - Content from all modules `~CSS` and `~CSSEEX` sigils will be compiled/extracted into `assets/css/[registry module].css`.
  - Content from all modules `~HOOK` sigils will be extracted into `assets/js/hooks/[registry module]_hooks.js`

  You can then import them into your `app.css` and `app.js` files.
  """
  require EEx

  @doc false
  defmacro __using__(opts) do
    extract_modules =
      opts[:extract_modules] ||
        raise """
        Must provide "extract_modules" list.
        """

    Module.register_attribute(__CALLER__.module, :__extract_modules__,
      accumulate: true,
      persist: true
    )

    for module <- extract_modules do
      Module.put_attribute(__CALLER__.module, :before_compile, Macro.expand(module, __CALLER__))

      Module.put_attribute(
        __CALLER__.module,
        :__extract_modules__,
        Macro.expand(module, __CALLER__)
      )
    end

    quote do
      @before_compile unquote(__MODULE__)
    end
  end

  @doc false
  defmacro __before_compile__(env) do
    registry = env.module
    extract_modules = Module.get_attribute(registry, :__extract_modules__)

    css_file = css_file(registry)
    File.mkdir_p!(Path.dirname(css_file))
    File.write!(css_file, render_css(modules: extract_modules))

    hooks_file = hooks_file(registry)
    File.mkdir_p!(Path.dirname(hooks_file))
    File.write!(hooks_file, render_hooks(modules: extract_modules))
  end

  EEx.function_from_string(
    :defp,
    :render_css,
    """
    /* WARNING: THIS FILE WAS AUTOMATICALLY GENERATED BY EXTRACTING ~CSS and ~CSSEEX. */

    <%= for module <- @modules do %><%= for {:__colocated_assets_css__, css} <- module.__info__(:attributes) do %><%= css %><% end %><% end %>
    """,
    [:assigns],
    trim: true
  )

  EEx.function_from_string(
    :defp,
    :render_hooks,
    """
    /* WARNING: THIS FILE WAS AUTOMATICALLY GENERATED BY EXTRACTING ~HOOK. */

    <%= for module <- @modules do %><%= for {:__colocated_assets_hooks__, hook} <- module.__info__(:attributes) do %><%= hook %><% end %><% end %>
    """,
    [:assigns],
    trim: true
  )

  defp assets_path() do
    Mix.Project.project_file()
    |> Path.dirname()
    |> Path.join("assets")
  end

  @doc false
  def filename(module) do
    module
    |> Module.split()
    |> List.last()
    |> Macro.underscore()
    |> String.replace("/", "_")
  end

  @doc false
  def css_file(module) do
    Path.join(assets_path(), "css/#{filename(module)}.css")
  end

  @doc false
  def hooks_file(module) do
    Path.join(assets_path(), "js/hooks/#{filename(module)}_hooks.js")
  end
end
