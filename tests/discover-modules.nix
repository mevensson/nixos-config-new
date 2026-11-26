let
  discover = import ../lib/discover-modules.nix;
  root = ./fixtures/discovery;
  relativePaths = directory:
    map (path: builtins.substring (builtins.stringLength (toString root) + 1) (builtins.stringLength (toString path)) (toString path))
      (discover directory);
in
assert relativePaths root == [
  "bundle/default.nix"
  "category/nested/profile.nix"
  "category/profile.nix"
  "standalone.nix"
];
# An entrypoint can use the same helper to discover its own children.
assert relativePaths (root + "/bundle") == [ "bundle/internal.nix" ];
true
