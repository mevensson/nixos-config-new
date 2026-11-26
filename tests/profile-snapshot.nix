# Project effective values rather than serialising all options: removed options,
# functions and unused options without defaults cannot be evaluated as JSON.
{ flake }:
let
  lib = flake.inputs.nixpkgs.lib;
  snapshot = _: system:
    let
      c = system.config;
    in
    {
      toplevel = c.system.build.toplevel.drvPath;
      homeManager = lib.mapAttrs (_: user: user.home.activationPackage.drvPath) c.home-manager.users;
      packages = map toString c.environment.systemPackages;
      fonts = map toString c.fonts.packages;
      shells = map toString c.environment.shells;
      services = lib.mapAttrs (_: service: service.enable) (lib.getAttrs [
        "openssh"
        "printing"
        "avahi"
        "fwupd"
        "flatpak"
        "pipewire"
        "pulseaudio"
        "llama-swap"
        "cachix-agent"
        "libinput"
        "xserver"
      ]
        c.services);
      systemdServices = builtins.attrNames c.systemd.services;
      graphical = {
        gnome = c.services.desktopManager.gnome.enable;
        plasma = c.services.desktopManager.plasma6.enable;
        gdm = c.services.displayManager.gdm.enable;
        xkb = c.services.xserver.xkb;
        steam = c.programs.steam.enable;
        gamescope = c.programs.gamescope;
        steamSession = c.programs.steam.gamescopeSession;
        zwift = if c.programs.zwift.enable or false then c.programs.zwift else { enable = false; };
        kdeconnect = c.programs.kdeconnect.enable;
        sshAskPassword = toString c.programs.ssh.askPassword;
      };
      integrations = {
        agenix = c.age.enable;
        nixIndex = c.programs.nix-index.enable;
        nixIndexDatabase = c.programs.nix-index-database.enable;
        comma = c.programs.nix-index-database.comma.enable;
        disko = c.disko.enableConfig or false;
        nur = system.pkgs ? nur;
        inherit (c.home-manager) backupFileExtension useUserPackages;
      };
      audio = {
        rtkit = c.security.rtkit.enable;
        inherit (c.services.pipewire) alsa pulse;
      };
      hardware = {
        graphics32Bit = c.hardware.graphics.enable32Bit;
        xone = c.hardware.xone.enable;
        xpadneo = c.hardware.xpadneo.enable;
        newLg4ff = c.hardware.new-lg4ff.enable;
      };
      boot = {
        kernel = c.boot.kernelPackages.kernel.drvPath;
        inherit (c.boot) kernelParams kernelModules;
        systemdBoot = c.boot.loader.systemd-boot.enable;
        configurationLimit = c.boot.loader.systemd-boot.configurationLimit;
        canTouchEfiVariables = c.boot.loader.efi.canTouchEfiVariables;
        initrdModules = c.boot.initrd.availableKernelModules;
      };
      fileSystems = c.fileSystems;
      swapDevices = map (swap: { inherit (swap) device priority options; }) c.swapDevices;
      users = lib.mapAttrs
        (_: user: {
          inherit (user) uid group extraGroups isNormalUser isSystemUser hashedPasswordFile;
          shell = toString user.shell;
        })
        c.users.users;
      mutableUsers = c.users.mutableUsers;
      secrets = lib.mapAttrs
        (_: secret: {
          inherit (secret) path owner group mode;
          file = builtins.baseNameOf secret.file;
        })
        c.age.secrets;
      firewall = c.networking.firewall;
      llamaSwap = c.services.llama-swap;
      cachixAgent = c.services.cachix-agent;
      nix = { inherit (c.nix) settings gc optimise; };
      console = { inherit (c.console) font keyMap; };
      i18n = { inherit (c.i18n) defaultLocale extraLocaleSettings; };
      timeZone = c.time.timeZone;
      stateVersion = c.system.stateVersion;
    };
in
lib.mapAttrs snapshot flake.nixosConfigurations
