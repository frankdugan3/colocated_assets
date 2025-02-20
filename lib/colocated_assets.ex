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

    Module.register_attribute(__CALLER__.module, :__colocated_assets_hooks__,
      accumulate: true,
      persist: true
    )

    Module.register_attribute(__CALLER__.module, :__colocated_assets_eex_assigns__,
      accumulate: true
    )

    quote bind_quoted: [module: __CALLER__.module] do
      import ColocatedAssets

      defmacro __before_compile__(env) do
        :ok
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

  @doc """
  A sigil for CSS in EEx.

  - Syntax highlighting
  - Automatic template compilation
  - Compile-time assigns via `assign_colocated_eex :key, "value"`
  - Optional extraction to CSS file with `ColocatedAssets.Registry`
  - Formatting can be disabled with the `noformat` option.
  """
  defmacro sigil_CSSEEX({:<<>>, meta, [expr]}, modifiers)
           when modifiers == [] or modifiers == ~c"noformat" do
    quote bind_quoted: binding() do
      assigns =
        @__colocated_assets_eex_assigns__
        |> Enum.map(fn {key, value} ->
          # 👋 Feel free to tell me a better way to do this... 🙈🙉🙊
          {value, _bindings} = Code.eval_quoted(value, [], __ENV__)
          {key, value}
        end)

      compiled =
        EEx.eval_string(expr, [assigns: assigns],
          engine: EEx.SmartEngine,
          file: __ENV__.file,
          line: __ENV__.line + 1,
          indentation: meta[:indentation] || 0,
          trim: true
        )

      @__colocated_assets_css__ compiled

      compiled
    end
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

  defmacro assign_colocated_eex(key, value) when is_atom(key) do
    for {^key, _value} <-
          Module.get_attribute(__CALLER__.module, :__colocated_assets_eex_assigns__) do
      raise "@#{key} already assigned"
    end

    Module.put_attribute(__CALLER__.module, :__colocated_assets_eex_assigns__, {key, value})
  end
end
