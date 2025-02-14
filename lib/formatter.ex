defmodule ColocatedAssets.Formatter do
  @moduledoc """
  Formats ~HOOK and ~CSS with [Prettier](https://prettier.io/).
  """

  @behaviour Mix.Tasks.Format

  @doc false
  def features(_opts), do: [sigils: [:CSS, :HOOK]]

  @doc false
  def format(contents, opts) do
    prettier = opts[:prettier_bin] || "prettier"
    sigil = opts[:sigil]

    if sigil in [:CSS, :HOOK] and opts[:modifiers] === ~c"noformat" do
      contents
    else
      c = """
      <<'EOF'
      #{contents}
      EOF
      """

      path =
        opts[:file]
        |> Path.relative_to(Path.dirname(Mix.Project.project_file()))
        |> Kernel.<>(":#{opts[:line]}")

      parser =
        case sigil do
          :HOOK -> "acorn"
          :CSS -> "css"
        end

      command = "#{prettier} --log-level warn --stdin-filepath #{path} --parser #{parser} #{c}"
      port = Port.open({:spawn, command}, [:binary])

      receive do
        {^port, {:data, d}} ->
          d

        _ ->
          contents
      after
        1_000 -> contents
      end
    end
  end
end
