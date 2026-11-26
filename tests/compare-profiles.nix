# Use the same projection for the old and new flakes, with their own inputs.
{ before, after }:
let
  old = import ./profile-snapshot.nix { flake = before; };
  new = import ./profile-snapshot.nix { flake = after; };
in
builtins.mapAttrs
  (host: snapshot: {
    changedFields = builtins.filter (field: snapshot.${field} != new.${host}.${field}) (builtins.attrNames snapshot);
    toplevels = { before = snapshot.toplevel; after = new.${host}.toplevel; };
    homeManagerMatches = snapshot.homeManager == new.${host}.homeManager;
  })
  old
