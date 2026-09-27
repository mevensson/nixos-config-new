{ mattpocock-skills, lib, ... }:

let
  skills = {
    productivity = [
      "grill-me"
      "grilling"
      "handoff"
      "teach"
      "wait-what"
    ];
    engineering = [
      "domain-modeling"
      "grill-with-docs"
      "research"
      "setup-matt-pocock-skills"
      "to-spec"
      "to-tickets"
      "triage"
    ];
  };

  entries = lib.concatLists (
    lib.mapAttrsToList
      (category: names: map (name: { inherit name category; }) names)
      skills
  );
in
{
  home.file = builtins.listToAttrs (
    map
      (entry: {
        name = ".agents/skills/${entry.name}";
        value.source = "${mattpocock-skills}/skills/${entry.category}/${entry.name}";
      })
      entries
  );
}
