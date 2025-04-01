# Get Started

This guide steps through the installation process for ColocatedAssets.

> #### Note: {: .info}
>
> We assume you are adding ColocatedAssets to an existing Phoenix LiveView app, as generated from the most recent version of `phx.new`.

## Installation

<!-- tabs-open -->

### Using Igniter (recommended)

The easiest way to install is to use Igniter. If you haven't already installed it on your system:

```sh
mix archive.install hex igniter_new
```

Then, invoke the installer:

```sh
mix igniter.install colocated_assets
```

### Manual Steps

1. Add `:colocated_assets` to your dependencies:

   ```elixir
   def deps do
     [
       {:colocated_assets, "~> 0.0.1"},
     ]
   end
   ```

2. Add the formatter to your list of plugins in `.formatter.exs`:

   ```elixir
   [
     # ...
     # If prettier is not in your path, you can specify the binary:
     # prettier_bin: "/custom/path/to/prettier",
     plugins: [Phoenix.LiveView.HTMLFormatter, ColocatedAssets.Formatter],
     import_deps: [:colocated_assets]
   ]
   ```

3. Use `ColocatedAssets` in your component modules:

   ```elixir
   defmodule MyAppWeb.CoreComponents do
     use Phoenix.Component
     use ColocatedAssets
     # ...
   end
   ```

4. Create a registry and add your component modules to it `lib/my_app_web/colocated_assets.ex`:

   ```elixir
   defmodule MyAppWeb.ColocatedAssets do
     use ColocatedAssets, extract_modules: [
       MyAppWeb.CoreComponents
     ]
   end
   ```

5. Import the extracted css in `app.css`:

   ```css
   @import './colocated_assets.css`;
   ```

6. Import the extracted hooks in `app.js`:

   ```js
   import * as ColocatedAssetsHooks './hooks/colocated_assets_hooks';

   // ...
   hooks: {
     ...ColocatedAssetsHooks,
   }
   ```

7. Finally, you may wish to add the generated files to your `.gitignore`:

   ```gitignore
   assets/css/colocated_assets.css
   assets/js/hooks/colocated_assets_hooks.js
   ```

<!-- tabs-close -->

## Next Steps

To enable syntax highlighting in your editor, refer to the [syntax highlighting guide](syntax-highlighting.html).
