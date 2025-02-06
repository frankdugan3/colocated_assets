# Syntax Highlighting

For editors that use Treesitter, adding queries to support new sigils that embed other languages is trivial.

## Neovim

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
