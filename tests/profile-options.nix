{ inputs }:
let
  lib = inputs.nixpkgs.lib;
  evaluate = extra: (lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ../profiles/core
      { system.stateVersion = "26.05"; }
      extra
    ];
  }).config;
  disabled = evaluate { };
  bundle = evaluate {
    myConfigs.core.enable = true;
    myConfigs.core.printing.enable = false;
  };
  standalone = evaluate { myConfigs.core.ssh.enable = true; };
  deploy = evaluate {
    networking.hostName = "ryzen";
    myConfigs.core.cachix-deploy.enable = true;
  };
  overriddenDependency = evaluate {
    networking.hostName = "ryzen";
    myConfigs.core.cachix-deploy.enable = true;
    myConfigs.core.agenix.enable = false;
  };
  nur = evaluate { myConfigs.core.nur.enable = true; };
in
assert !disabled.myConfigs.core.enable;
assert builtins.all (name: name == "enable" || !disabled.myConfigs.core.${name}.enable) (builtins.attrNames disabled.myConfigs.core);
assert !disabled.age.enable;
assert !disabled.programs.nix-index-database.enable;
assert !disabled.programs.nix-index.enable;
assert !disabled.disko.enableConfig;
assert disabled.nixpkgs.overlays == [ ];
assert disabled.home-manager.sharedModules == [ ];
assert !bundle.myConfigs.core.printing.enable;
assert !bundle.services.printing.enable;
assert bundle.services.openssh.enable;
assert bundle.programs.nix-index-database.enable;
assert bundle.age.enable;
assert !bundle.myConfigs.core.cachix-deploy.enable;
assert !bundle.myConfigs.core.disko.enable;
assert !standalone.myConfigs.core.enable && standalone.services.openssh.enable;
assert deploy.myConfigs.core.agenix.enable;
assert !overriddenDependency.myConfigs.core.agenix.enable && !overriddenDependency.age.enable;
assert nur.myConfigs.core.home-manager.enable;
true
