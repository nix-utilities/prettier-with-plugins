let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;

  prettier-with-plugins = import ./default.nix {
    inherit lib pkgs;
  };

  prettierCustomized = prettier-with-plugins.prettier {
    enabled = with prettier-with-plugins.plugins; [
      ## Third-party
      prettier-plugin-apex
      prettier-plugin-astro
      prettier-plugin-elm
      prettier-plugin-erb
      prettier-plugin-gherkin
      prettier-plugin-glsl
      prettier-plugin-go-template
      prettier-plugin-jinja-template
      prettier-plugin-kotlin
      prettier-plugin-motoko
      prettier-plugin-prisma
      prettier-plugin-properties
      prettier-plugin-rust
      prettier-plugin-sh
      prettier-plugin-solidity
      prettier-plugin-sql
      prettier-plugin-sql-cst
      prettier-plugin-svelte
      prettier-plugin-toml
    ]
    ++ (with prettier-with-plugins; [
      ## Official
      plugins."@prettier/plugin-php"
      plugins."@prettier/plugin-pug"
      plugins."@prettier/plugin-ruby"
      plugins."@prettier/plugin-xml"
      ## Third-party
      plugins."@stedi/prettier-plugin-jsonata"
    ]);
  };
in
pkgs.mkShellNoCC {
  packages = [
    prettierCustomized
  ];
}
