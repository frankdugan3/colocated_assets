locals = [assign_colocated_eex: 2]

[
  locals_without_parens: locals,
  exports: [locals_without_parens: locals],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
]
