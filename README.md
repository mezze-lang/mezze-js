# mezze-js

JavaScript interop for [Mezze](https://mezze-lang.org) — packaged as an
external `mez` dependency (polyglot-as-a-package Phase 5, mirroring
[mezze-python](https://github.com/mezze-lang/mezze-python)).

## Install

```toml
# your Mezze.toml

[dependencies]
mezze_js = "github:mezze-lang/mezze-js@0.1.0"

[polyglot.js]
# Optional: npm packages for CommonJS `require(...)`.
# Leave empty for pure ECMAScript eval.
packages = []
```

Then `mez sync` and you can:

```mezze
use mezze_js::js::{ Js, GraalJs, JsForeign }

pub let main = {} -> perform GraalJs in do
  let pi_r = Js.eval { source = "Math.PI" }
  match pi_r is
    Ok { val = f } -> match f.as_float{} is
      Ok { val = d } -> ...
      Err { error = _ } -> ...
    Err { error = _ } -> ...
```

## What ships

- `src/js.mz` — `effect Js`, `impl Js for GraalJs`, inherent methods
  on `JsForeign` (JS-idiomatic + universal InteropLibrary
  vocabulary), language-tagged constructors.
- `src/codec.mz` — `JsC` codec + tier-4 `ToJs` / `FromJs` sugar.
- `[polyglot.provider]` — `npm install --prefix {dest} {packages}`
  install template used by `mez sync` when a user project declares
  `[polyglot.js] packages`. Packages land under `<dest>/node_modules`
  and `NODE_PATH` points GraalJS at them.
- `[maven]` — resolves the GraalJS runtime jars
  (`org.graalvm.js:js-language`, `org.graalvm.js:js-scriptengine`)
  from Maven Central plus the native-handler jar
  (`dev.mezze:polyglot-js-natives`) from
  [mezze-lang/mezze-maven](https://github.com/mezze-lang/mezze-maven).
  Aether pulls the full transitive graph — no manual sha
  bookkeeping.

## Requirements

- `mez` (Mezze CLI) 0.1 or later.
- GraalVM 25.0.3.
- `npm` on PATH iff the consuming project declares
  `[polyglot.js].packages` — `mez sync` runs the provider's install
  template into the local `.deps/node/node_modules/` directory. No
  packages, no npm needed (pure eval works out of the box).

## License

MIT — see `LICENSE`.
