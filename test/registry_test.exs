defmodule ColocatedAssets.RegistryTest do
  alias Hex.Solver.Registry
  use ExUnit.Case, async: true
  doctest ColocatedAssets.Registry, import: true

  defmodule Components do
    use ColocatedAssets

    assign_colocated_eex :colors, ["red", "yellow", "green"]

    ~CSSEEX"""
    <%= for color <- @colors do %>
    .is-<%= color %> {
      --base-color: var(--color-<%= color %>-500);
    }
    <% end %>
    """

    ~CSS"""
    .badge {
      background: var(--base-color);
      color: black;
    }
    """

    ~HOOK"""
    export const BadgeHook = {
      mounted() {
        console.log('Hello, world!');
      }
    }
    """
  end

  defmodule Registry do
    use ColocatedAssets.Registry, extract_modules: [Components]
  end
end
