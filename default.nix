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
        let
          scopeOf = plugin: builtins.head (lib.strings.split "/" plugin.packageName);

          flags = builtins.concatStringsSep " " (utils.cliFlagsFor enabled);

          NODE_PATH =
            builtins.concatStringsSep ":" (builtins.map (
              plugin:
              utils.directoryOf plugin
            ) enabled);
        in
        if builtins.length enabled > 0 then
          ''
            wrapProgram $out/bin/prettier --add-flags "${flags}" --prefix NODE_PATH ":" "${NODE_PATH}";

            mkdir -p $out/node_modules;
          ''
          + builtins.concatStringsSep "\n" (
            builtins.map (
              plugin:
              let
                pluginDirectory = utils.directoryOf plugin;
                pluginScope = scopeOf plugin;
              in
              if lib.strings.hasPrefix "@" plugin.packageName then
                ''
                  mkdir -p $out/node_modules/${pluginScope};
                  ln -s "${pluginDirectory}" $out/node_modules/${pluginScope};
                ''
              else
                ''
                  ln -s "${pluginDirectory}" $out/node_modules/;
                ''
            )
          enabled)
        else
          "";
    });
}

