defmodule ColocatedAssets do
  @moduledoc ~S|
  An experimental solution for colocated assets in Phoenix LiveView.

  Enables `~CSS`, `~CSSEEX` and `~HOOK`. 

  ```elixir
  defmodule MyAppWeb.CoreComponents do
    use Phoenix.Component
    use ColocatedAssets

    attr :rest, global: true
    slot :inner_block, required: true

    def badge(assigns) do
      ~CSS"""
      [data-component="badge"] {
        /* ... */ 
      }
      """

      ~H"""
      <span data-component="badge" {@rest}><%= render_slot(@inner_block) %></span>
      """
    end
  end
  ```
  |

  @doc false
  defmacro __using__(_opts) do
    Module.register_attribute(__CALLER__.module, :__colocated_assets_css__,
      accumulate: true,
      persist: true
    )

    Module.register_attribute(__CALLER__.module, :css_assigns,
      accumulate: true,
      persist: true
    )

    Module.register_attribute(__CALLER__.module, :__colocated_assets_hooks__,
      accumulate: true,
      persist: true
    )

    quote bind_quoted: [module: __CALLER__.module] do
      import ColocatedAssets

      defmacro __before_compile__(env) do
        for {:__colocated_assets_css__, css} <- __MODULE__.__info__(:attributes) do
          Module.put_attribute(env.module, :__colocated_assets_css__, css)
        end

        for {:css_assigns, assign} <- __MODULE__.__info__(:attributes) do
          Module.put_attribute(env.module, :__colocated_assets_css_assigns__, assign)
        end

        for {:__colocated_assets_hooks__, hook} <- __MODULE__.__info__(:attributes) do
          Module.put_attribute(env.module, :__colocated_assets_hooks__, hook)
        end
      end
    end
  end

  @doc ~S|
  A sigil for CSS.

  - Syntax highlighting
  - Code formatting with [Prettier](https://prettier.io/) via `mix format`
  - Optional extraction to CSS file with `ColocatedAssets.Registry`

  Formatting can be disabled with the `noformat` option:

  ```elixir
  ~CSS"""
  .one-liner {color: rebeccapurple;}
  """noformat
  ```
  |
  defmacro sigil_CSS({:<<>>, _meta, [expr]}, modifiers)
           when modifiers == [] or modifiers == ~c"noformat" do
    Module.put_attribute(__CALLER__.module, :__colocated_assets_css__, expr)
    expr
  end

  @doc ~S|
  A sigil for CSS in EEx.

  - Syntax highlighting
  - Optional template compilation to CSS file with `ColocatedAssets.Registry`
  - Assigns via `@css_assigns`


  ```elixir
  @css_assigns [colors: [{"primary", "rebeccapurple"}, {"secondary", "slategray"}]]
  ~CSSEEX"""
  <%= for {color, value} <- colors %>--color-<%= color %>: <%= value %>;
  """
  ```
  
  Formatting can be disabled with the `noformat` option.
  |
  defmacro sigil_CSSEEX({:<<>>, _meta, [expr]}, modifiers)
           when modifiers == [] or modifiers == ~c"noformat" do
    Module.put_attribute(__CALLER__.module, :__colocated_assets_css__, {:eex, expr})
    {:eex, expr}
  end

  @doc ~S|
  A sigil for Phoenix JS hooks.

  - Syntax highlighting
  - Code formatting with [Prettier](https://prettier.io/) via `mix format`
  - Optional extraction to JS hooks file with `ColocatedAssets.Registry`

  ```elixir
  ~HOOK"""
  export HelloHook {
    mounted() {console.log("Hello, world!"}
  }
  """
  ```

  Formatting can be disabled with the `noformat` option.
  |
  defmacro sigil_HOOK({:<<>>, _meta, [expr]}, modifiers)
           when modifiers == [] or modifiers == ~c"noformat" do
    Module.put_attribute(__CALLER__.module, :__colocated_assets_hooks__, expr)
    expr
  end
end
