let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
in
pkgs.mkShellNoCC {
  packages = [
    (import ./default.nix {
      inherit lib pkgs;
      enableAll = true;
    })
  ];
}
