defmodule ColocatedAssets.FormatterTest do
  use ExUnit.Case, async: true

  setup do
    opts = [file: __ENV__.file]

    %{opts: opts}
  end

  describe "formatter works" do
    test "~HOOK is formatted", %{opts: opts} do
      assert ColocatedAssets.Formatter.format(
               """
               export const SomeHook = {


                             mounted() {console.log(  'hello')        }
                     }
               """,
               [{:sigil, :HOOK}, {:line, 14} | opts]
             ) == """
             export const SomeHook = {
               mounted() {
                 console.log("hello");
               },
             };
             """
    end

    test "~CSS is formatted", %{opts: opts} do
      assert ColocatedAssets.Formatter.format(
               """
               .some-class     {    
                            background: rebeccapurple      



                    }
               """,
               [{:sigil, :CSS}, {:line, 32} | opts]
             ) == """
             .some-class {
               background: rebeccapurple;
             }
             """
    end
  end
end
