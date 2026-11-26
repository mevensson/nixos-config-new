{ inputs }:
let
  lib = inputs.nixpkgs.lib;
  allDisabled = value:
    if builtins.isAttrs value then
      builtins.all allDisabled (builtins.attrValues value)
    else
      value == false;
  plain = (lib.nixosSystem {
    system = "x86_64-linux";
    modules = [{ system.stateVersion = "26.05"; }];
  }).config;
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
  withDevices = enable: evaluate {
    myConfigs.core.disko.enable = enable;
    disko.devices.disk.example = {
      type = "disk";
      device = "/dev/example";
      content = {
        type = "filesystem";
        format = "ext4";
        mountpoint = "/example";
      };
    };
  };
  zwift = evaluate { myConfigs.graphical.zwift.enable = true; };
  kde = evaluate { myConfigs.graphical.kde.enable = true; };
in
assert allDisabled disabled.myConfigs;
# Static imports must not add runtime effects when every profile is disabled.
assert map toString disabled.environment.systemPackages == map toString plain.environment.systemPackages;
assert builtins.attrNames disabled.systemd.services == builtins.attrNames plain.systemd.services;
assert builtins.attrNames disabled.system.activationScripts == builtins.attrNames plain.system.activationScripts;
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
assert !((withDevices false).fileSystems ? "/example");
assert (withDevices true).fileSystems."/example".fsType == "ext4";
assert zwift.programs.zwift.enable && zwift.virtualisation.podman.enable;
assert zwift.networking.firewall.allowedTCPPorts == [ 21587 21588 ];
assert zwift.networking.firewall.allowedUDPPorts == [ 3022 3024 ];
assert kde.services.desktopManager.plasma6.enable;
true
