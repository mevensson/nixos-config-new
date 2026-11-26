# nixos-config-new
My new NixOS configuration

Uses:
* [NixOS](https://nixos.org/)
* [Home Manager](https://github.com/nix-community/home-manager)
* [Disko](https://github.com/nix-community/disko)

# System profiles

Each machine selects NixOS profiles in `hosts/<name>/profiles.nix` using
`myConfigs` enable options:

```nix
{
  myConfigs = {
    core.enable = true;
    core.printing.enable = false;
    graphical.gnome.enable = true;
    shells.fish.enable = true;
  };
}
```

Every profile enable option defaults to `false`. The core bundle supplies
overridable defaults for its existing curated selection: agenix, auto-gc,
auto-optimize, cachix, fwupd, home-manager, immutable-users, kernel, locales,
nix-index, nur, nixos, printing, and ssh. Ordinary assignments override these
defaults, as shown above. Disko and Cachix deployment are selected separately.
Core children can also be enabled independently of the bundle.

Options follow the directories under `profiles/`: `boot`, `core`, `graphical`,
`llm`, `remotefs`, `shells`, and `sound`. Categories do not need their own
enable option. Genuine child options only have effects while their parent is
enabled:

```nix
{
  myConfigs.llm.llama-swap = {
    enable = true;
    models.gemma4-12b.enable = true;
    models.gemma4-26b.enable = true;
    models.qwen3-5-9b.enable = true;
  };
  myConfigs.graphical.logitechg29 = {
    enable = true;
    new-lg4ff.enable = true;
  };
}
```

These children default off. Selecting a child while its parent is disabled
leaves it dormant; it does not enable the parent or produce an error.

Dependencies between separate profiles use `lib.mkDefault true`: Gamescope's
Steam session selects Steam, GSConnect selects GNOME, Cachix deployment and
DS920 mounts select agenix, and NUR selects the Home Manager integration profile.
An explicit assignment can override a dependency default. Normal Nix merging
and upstream module behavior handle the resulting configuration.

## Adding a profile

`profiles/default.nix` imports modules using `lib/discover-modules.nix`:

- Standalone `.nix` files are discovered automatically.
- Directories without `default.nix` are searched recursively.
- A directory with `default.nix` is imported through that entrypoint only;
  the entrypoint owns its internal imports.
- Discovery is static and independent of option values. It ignores non-module
  files and does not import an entrypoint into itself.

Add a standalone module under the appropriate category; no registry change is
needed. Declare an enable option and put all its effects behind that option:

```nix
{ config, lib, pkgs, ... }: {
  options.myConfigs.shells.hello.enable = lib.mkEnableOption "GNU Hello";

  config = lib.mkIf config.myConfigs.shells.hello.enable {
    environment.systemPackages = [ pkgs.hello ];
  };
}
```

Keep upstream module imports unconditional so their options are always available.
Audit upstream activation defaults and unconditional effects before importing
them globally. The current wrappers explicitly control agenix activation,
nix-index-database activation, Disko-generated configuration, and the NUR overlay.
Upstream options remain available for direct customization. Home Manager's
integration profile controls its shared settings; users are still selected
separately and retain their existing Home Manager profile imports.

## Verification

Run `nix develop --command fmt` and `nix develop --command check`. Flake checks
cover discovery, disabled defaults, bundle overrides, prerequisites, and dormant
child options. See [the issue #270 verification report](docs/verification-issue-270.md)
for the baseline comparison and a reproducible comparison command.

# Create live-installer

To create a live-installer on an USB stick run the following command:
```bash
./create-live-installer.sh <path/to/usb-device>
```

# Zwift

See the [Zwift profile documentation](profiles/graphical/zwift/README.md) for setup,
pairing, updates, and troubleshooting.
