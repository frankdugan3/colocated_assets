# ColocatedAssets

An experimental solution for colocated assets in Phoenix LiveView.

## Installation

The easiest way to install is to use Igniter. First, add the dependency to your project:

```elixir
def deps do
  [
    {:igniter, "~> 0.5", only: [:dev, :test]},
  ]
end
```

Then, invoke the installer:

```sh
mix igniter.install colocated_assets@github:/frankdugan3/colocated_assets
```

Alternatively, you can look at the module documentation for `ColocatedAssets`, `ColocatedAssets.Formatter` and `ColocatedAssets.Registry` for instructions for how to utilize each module.

## Syntax Highlighting

For editors that use Treesitter, adding queries to support new sigils that embed other languages is trivial.

To add support in Neovim, add the following to `.config/nvim/queries/elixir/injections.scm`:

```scheme
;; extends
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "JS" "HOOK")
  (#set! injection.language "javascript"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "CSS")
  (#set! injection.language "css"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "CSSEEX")
  (#set! injection.language "eex"))
```
