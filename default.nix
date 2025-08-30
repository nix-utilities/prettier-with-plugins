{
  lib,
  pkgs,

  prettier ? pkgs.prettier,
  system ? builtins.currentSystem,
  nodejs ? pkgs."nodejs_22",

  ## Official
  enablePhp ? false,
  enablePug ? false,
  enableRuby ? false,
  enableXml ? false,

  ## Third-party
  enableApex ? false,
  enableAstro ? false,
  enableElm ? false,
  enableErb ? false,
  enableGherkin ? false,
  enableGlsl ? false,
  enableGoTemplate ? false,
  enableJinjaTemplate ? false,
  enableJsonata ? false,
  enableKotlin ? false,
  enableMotoko ? false,

  ## TODO: figure out how Nginx is more broken than other NodeJS stuff
  #
  #> Executing versionCheckPhase
  #> Did not find version 3.5.3 in the output of the command /nix/store/7lq1xka7vfl5zyg17hggsbvbc3ya7l1a-prettier-3.5.3/bin/prettier --help
  #> [error] Cannot find module 'prettier/doc'
  #> [error] Require stack:
  #> [error] - {{storeDir}}/lib/node_modules/prettier-plugin-nginx/dist/index.js
  #> Did not find version 3.5.3 in the output of the command /nix/store/7lq1xka7vfl5zyg17hggsbvbc3ya7l1a-prettier-3.5.3/bin/prettier --version
  #> [error] Cannot find module 'prettier/doc'
  #> [error] Require stack:
  #> [error] - {{storeDir}}/lib/node_modules/prettier-plugin-nginx/dist/index.js
  # enableNginx ? false,

  enablePrisma ? false,
  enableProperties ? false,
  enableRust ? false,
  enableSh ? false,
  enableSolidity ? false,
  enableSql ? false,
  enableSqlCst ? false,
  enableSvelte ? false,
  enableToml ? false,

  enableAll ? false,

  ...
}:
let
  nodePackages =
    final:
    import ./composition.nix {
      inherit pkgs;
      inherit (pkgs) nodejs;
      inherit (pkgs.stdenv.hostPlatform) system;
    };

  plugins = (nodePackages { inherit pkgs system nodejs; });

  enabled = []
    ++ (lib.optional (enablePhp           || enableAll) plugins."@prettier/plugin-php")
    ++ (lib.optional (enablePug           || enableAll) plugins."@prettier/plugin-pug")
    ++ (lib.optional (enableRuby          || enableAll) plugins."@prettier/plugin-ruby")
    ++ (lib.optional (enableXml           || enableAll) plugins."@prettier/plugin-xml")
    ## Third-party
    ++ (lib.optional (enableApex          || enableAll) plugins."prettier-plugin-apex")
    ++ (lib.optional (enableAstro         || enableAll) plugins."prettier-plugin-astro")
    ++ (lib.optional (enableElm           || enableAll) plugins."prettier-plugin-elm")
    ++ (lib.optional (enableErb           || enableAll) plugins."prettier-plugin-erb")
    ++ (lib.optional (enableGherkin       || enableAll) plugins."prettier-plugin-gherkin")
    ++ (lib.optional (enableGlsl          || enableAll) plugins."prettier-plugin-glsl")
    ++ (lib.optional (enableGoTemplate    || enableAll) plugins."prettier-plugin-go-template")
    ++ (lib.optional (enableJinjaTemplate || enableAll) plugins."prettier-plugin-jinja-template")
    ++ (lib.optional (enableJsonata       || enableAll) plugins."@stedi/prettier-plugin-jsonata")
    ++ (lib.optional (enableKotlin        || enableAll) plugins."prettier-plugin-kotlin")
    ++ (lib.optional (enableMotoko        || enableAll) plugins."prettier-plugin-motoko")
    # ++ (lib.optional (enableNginx         || enableAll) plugins."prettier-plugin-nginx")
    ++ (lib.optional (enablePrisma        || enableAll) plugins."prettier-plugin-prisma")
    ++ (lib.optional (enableProperties    || enableAll) plugins."prettier-plugin-properties")
    ++ (lib.optional (enableRust          || enableAll) plugins."prettier-plugin-rust")
    ++ (lib.optional (enableSh            || enableAll) plugins."prettier-plugin-sh")
    ++ (lib.optional (enableSolidity      || enableAll) plugins."prettier-plugin-solidity")
    ++ (lib.optional (enableSql           || enableAll) plugins."prettier-plugin-sql")
    ++ (lib.optional (enableSqlCst        || enableAll) plugins."prettier-plugin-sql-cst")
    ++ (lib.optional (enableSvelte        || enableAll) plugins."prettier-plugin-svelte")
    ++ (lib.optional (enableToml          || enableAll) plugins."prettier-plugin-toml")
    ;

  /**
    Key by `prettier-plugins."<KEY>".packageName` and provides relative path to
    plugin entry point, and for each `enabled` plugin create an attribute set
    similar to;

    ```nix
    {
      "@prettier/plugin-php" = {
        relative = "./src/index.mjs";
        directory = "/nix/store/2ws8z4pmyj6wagsli3hhk86ks8si1vq8-_at_prettier_slash_plugin-php-0.24.0/lib/node_modules/@prettier/plugin-php";
        absolute = "/nix/store/2ws8z4pmyj6wagsli3hhk86ks8si1vq8-_at_prettier_slash_plugin-php-0.24.0/lib/node_modules/@prettier/plugin-php/./src/index.mjs";
      };
      # ...
    }
    ```

    Entry points are defined by `package.json` `"exports"`

    ```bash
    jq '.exports.".".default' <NIX_STORE>/lib/node_modules/@prettier/plugin-php/package.json
    #> "./src/index.mjs"

    jq '.exports' <NIX_STORE>/lib/node_modules/prettier-plugin-apex/package.json
    #> "./dist/src/index.js"
    ```

    `pluginEntryPoint` function tries for the longer form(s) first, defaults to
    shorter option, and failing all known options throws an error

    ...  why, NodeJS,,, WHY?!
  */
  pluginAttrs =
    let
      pluginModulePath = plugin: "${plugin.outPath}/lib/node_modules/${plugin.packageName}";

      ## Extend `lib.attrByPath` by operating on list of attr addresses recursively
      pluginPath =
        addresses:
        default:
        data:
        if builtins.length addresses == 0 then
          default
        else
          lib.attrByPath (builtins.head addresses) (pluginPath (lib.lists.drop 1 addresses) default data) data;

      ## WARN: order here matters
      addresses = [
        ["main"]
        ["exports" "." "default"]
        ["exports" "."]
        ["exports" "default"]
        ["exports"]
      ];

      pluginEntryPoint =
        plugin:
        let
          data =
            builtins.fromJSON (
              builtins.readFile "${pluginModulePath plugin}/package.json"
            );

          path = pluginPath addresses (
            builtins.head (lib.attrByPath ["prettier" "plugins"] ["null"] data)
          ) data;

          directory = pluginModulePath plugin;
        in
        if builtins.pathExists "${directory}/${path}" then
          path
        else if builtins.pathExists "${directory}/${path}.js" then
          ## Because prettier-plugin-go-template and prettier-plugin-nginx
          ## defined "main" in `package.json` but without file extension :-|
          "${path}.js"
        else
          throw ''
            Cannot handle plugin: ${plugin.packageName}
            Store path: ${plugin.outPath}
          '';

    in
    builtins.listToAttrs (builtins.map (
      plugin: {
        name = plugin.packageName;
        # value = "${plugin.outPath}/lib/node_modules/${plugin.packageName}/${pluginEntryPoint plugin}";
        value = rec {
          directory = "${pluginModulePath plugin}";
          relative = "${pluginEntryPoint plugin}";
          absolute = "${directory}/${relative}";
        };
      }
    ) enabled);

in
((prettier.override { }).overrideAttrs{
  buildInputs = prettier.buildInputs ++ [pkgs.makeWrapper];

  nativeBuildInputs = prettier.nativeBuildInputs ++ enabled;

  postInstall =
    let
      flags = builtins.concatStringsSep " " (lib.map (
        x:
        "--plugin=${x.absolute}"
      ) (builtins.attrValues pluginAttrs));
    in
    if builtins.length enabled > 0 then
      ''
        echo '${builtins.toJSON pluginAttrs}' > $out/prettier-plugins.json;

        wrapProgram $out/bin/prettier --add-flags "${flags}";
      ''
    else
      "";
})
