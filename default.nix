/**
  Check `prettierCustomized` in ./shell.nix for example customization/usage
*/
{
  lib,
  pkgs,

  prettier ? pkgs.prettier,
  system ? builtins.currentSystem,
  nodejs ? pkgs."nodejs_22",

  utils ? import ./utils.nix { inherit lib; },
}:
let
  nodePackages =
    final:
    import ./composition.nix {
      inherit pkgs;
      inherit (pkgs) nodejs;
      inherit (pkgs.stdenv.hostPlatform) system;
    };
in
{
  plugins = (nodePackages { inherit pkgs system nodejs; });

  prettier =
    { enabled ? [] }:
    ((prettier.override { }).overrideAttrs{
      nativeBuildInputs = prettier.nativeBuildInputs ++ enabled;

      postInstall =
        if builtins.length enabled > 0 then
          ''
            wrapProgram $out/bin/prettier --add-flags "${builtins.concatStringsSep " " (utils.cliFlagsFor enabled)}";
          ''
        else
          "";
    });
}

