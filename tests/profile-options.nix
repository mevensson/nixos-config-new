{ inputs }:
let
  lib = inputs.nixpkgs.lib;
  evaluate = extra: (lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ../profiles
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
  gamescope = evaluate { myConfigs.graphical.gamescope-steam-session.enable = true; };
  gsconnect = evaluate { myConfigs.graphical.gsconnect.enable = true; };
  dormantDriver = evaluate { myConfigs.graphical.logitechg29.new-lg4ff.enable = true; };
  driver = evaluate {
    myConfigs.graphical.logitechg29 = {
      enable = true;
      new-lg4ff.enable = true;
    };
  };
  dormantModels = evaluate {
    myConfigs.llm.llama-swap.models = {
      gemma4-12b.enable = true;
      gemma4-26b.enable = true;
      qwen3-5-9b.enable = true;
    };
  };
  model = evaluate {
    myConfigs.llm.llama-swap = {
      enable = true;
      models.gemma4-12b.enable = true;
    };
  };
  remoteMounts = evaluate { myConfigs.remotefs.sshfs.ds920.enable = true; };
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
assert !disabled.services.desktopManager.gnome.enable;
assert !disabled.services.desktopManager.plasma6.enable;
assert !disabled.services.displayManager.gdm.enable;
assert !disabled.programs.zwift.enable;
assert !disabled.virtualisation.podman.enable && !disabled.virtualisation.docker.enable;
assert disabled.networking.firewall.allowedTCPPorts == [ ];
assert disabled.networking.firewall.allowedUDPPorts == [ ];
assert gamescope.myConfigs.graphical.steam.enable && gamescope.programs.steam.enable;
assert gsconnect.myConfigs.graphical.gnome.enable;
assert !dormantDriver.myConfigs.graphical.logitechg29.enable && !dormantDriver.hardware.new-lg4ff.enable;
assert driver.hardware.new-lg4ff.enable;
assert !disabled.services.llama-swap.enable;
assert !dormantModels.myConfigs.llm.llama-swap.enable && !dormantModels.services.llama-swap.enable;
assert (dormantModels.services.llama-swap.settings.models or { }) == { };
assert !(dormantModels.users.users ? llama-swap);
assert !(dormantModels.systemd.services ? llama-swap);
assert model.services.llama-swap.enable;
assert builtins.attrNames model.services.llama-swap.settings.models == [ "gemma4:12b" ];
assert !disabled.boot.loader.systemd-boot.enable;
assert !disabled.programs.fish.enable;
assert !disabled.services.pipewire.enable;
assert !(disabled.fileSystems ? "/media/ds920/Media");
assert remoteMounts.myConfigs.core.agenix.enable;
assert remoteMounts.fileSystems."/media/ds920/Media".fsType == "sshfs";
true
