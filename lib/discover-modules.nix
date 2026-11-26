# Discover the children of an entrypoint, never the entrypoint itself.
# A nested default.nix owns its directory, so do not discover its internals.
directory:
let
  entries = builtins.readDir directory;
  discoverEntry = name:
    let
      path = directory + "/${name}";
      type = entries.${name};
    in
    if type == "directory" then
      if builtins.pathExists (path + "/default.nix") then
        [ (path + "/default.nix") ]
      else
        import ./discover-modules.nix path
    else if type == "regular" && name != "default.nix" && builtins.match ".*\\.nix" name != null then
      [ path ]
    else
      [ ];
in
builtins.concatLists (map discoverEntry (builtins.attrNames entries))
