# Syntax Highlighting

For editors that use Treesitter, adding queries to support new sigils that embed other languages is trivial.

## Neovim

To add support in Neovim, add the following to `.config/nvim/queries/elixir/injections.scm`:

```scheme
;; extends
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#eq? @_sigil_name "HOOK")
  (#set! injection.language "javascript"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#eq? @_sigil_name "CSS")
  (#set! injection.language "css"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#eq? @_sigil_name "CSSEEX")
  (#set! injection.language "eex"))
```

## Helix

> #### Not Working {: .warning}
>
> As far as I can tell, there is currently a lack of support for multicharacter sigils in Helix's treesitter. If you know more in this space, feel free to let me know how to get this working.

Add something like the following to `.config/helix/runtime/queries/elixir/injections.scm`:

```scheme
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#eq? @_sigil_name "HOOK")
  (#set! injection.language "javascript"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#eq? @_sigil_name "CSS")
  (#set! injection.language "css"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#eq? @_sigil_name "CSSEEX")
  (#set! injection.language "eex"))
```
