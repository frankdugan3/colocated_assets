defmodule ColocatedAssetsTest do
  use ExUnit.Case, async: true
  doctest ColocatedAssets, import: true

  use ColocatedAssets

  @colors ["red", "yellow", "green"]
  assign_colocated_eex :module_colors, @colors
  assign_colocated_eex :literal, true

  @compiled_template ~CSSEEX"""
  <%= for color <- @module_colors do %>.is-<%= color %> {
    --base-color: var(--color-<%= color %>-500);
  }
  <% end %>
  """

  test "able to assign to eex" do
    assert {:@, _, [{:colors, _, _}]} = @__colocated_assets_eex_assigns__[:module_colors]
    assert true = @__colocated_assets_eex_assigns__[:literal]
  end

  test "~CSSEEX with module attribute assign compiles" do
    assert @compiled_template == """
           .is-red {
             --base-color: var(--color-red-500);
           }
           .is-yellow {
             --base-color: var(--color-yellow-500);
           }
           .is-green {
             --base-color: var(--color-green-500);
           }
           """
  end

  test "~CSS works" do
    assert ~CSS"""
           .button {
             padding: 1rem;
           }
           """ == """
           .button {
             padding: 1rem;
           }
           """
  end

  test "~HOOK works" do
    assert ~HOOK"""
           export const HelloHook = {
             mounted() {
               console.log("Hello");
             },
           };
           """ == """
           export const HelloHook = {
             mounted() {
               console.log("Hello");
             },
           };
           """
  end
end
