{
  lib
}:
rec {
  recAtterByPath =
    addresses:
    default:
    attrs:
    if builtins.length addresses == 0 then
      default
    else
      let
        addressesNext = builtins.head addresses;
        addressesRemaning = lib.lists.drop 1 addresses;
      in
      lib.attrByPath addressesNext (recAtterByPath addressesRemaning default attrs) attrs;

  knownNodeAddresses = [
    ["main"]
    ["exports" "." "default"]
    ["exports" "."]
    ["exports" "default"]
    ["exports"]
  ];

  directoryOf = plugin: "${plugin.outPath}/lib/node_modules/${plugin.packageName}";

  packageJsonAttrOf =
    plugin:
    let
      path = "${directoryOf plugin}/package.json";
      file =
        if builtins.pathExists path then
          builtins.readFile path
        else
          throw ''${plugin.packageName}: does not provide package.json at "${path}"'';
    in
    builtins.fromJSON file;

  entryPointOf =
    plugin:
    let
      attrs = packageJsonAttrOf plugin;

      pathRelative = recAtterByPath knownNodeAddresses (
        builtins.head (lib.attrByPath ["prettier" "plugins"] ["null"] attrs)
      ) attrs;

      directory = directoryOf plugin;
      pathAbsoluteNaive = "${directory}/${pathRelative}";
      pathAbsoluteFallback = "${directory}/${pathRelative}.js";
    in
    if builtins.pathExists pathAbsoluteNaive then
      pathAbsoluteNaive
    else if builtins.pathExists pathAbsoluteFallback then
      pathAbsoluteFallback
    else
      lib.warn ''
        ${plugin.packageName}: error context, tried finding entryp point under;
        pathAbsoluteNaive -> ${pathAbsoluteNaive}
        pathAbsoluteFallback -> ${pathAbsoluteFallback}
      ''
      throw ''${plugin.packageName}: does not provide parse-able entry point'';

  cliFlagsFor = lib.map (
    plugin:
    "--plugin=${entryPointOf plugin}"
  );
}

