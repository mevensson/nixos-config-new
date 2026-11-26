# Issue #270 verification

## Baseline and scope

Baseline revision: `9efc99e6f26c1dc71a0f80eace5274c55b41be94` (the starting
`origin/main`). The migration retains the same `flake.lock` and user profile
imports. A pre-change snapshot was captured before implementation; focused
comparisons were repeated at each implementation checkpoint.

The final comparison uses `tests/profile-snapshot.nix` for both the baseline and
the migrated flake. It evaluates the four system toplevels and the five Home
Manager activation packages, and compares:

- Ordered system package, font and shell lists.
- Profile-related service enables and systemd service names.
- Desktop, display manager, Steam/Gamescope session and Zwift settings.
- agenix, nix-index, Disko and Home Manager integration settings, plus NUR availability.
- Audio, graphics and controller settings.
- Kernel, bootloader and initrd module settings.
- Filesystems, swap, users, secret metadata and firewall configuration.
- llama-swap models, Cachix agent settings, Nix settings, locales and state versions.

## Results

| Configuration | Effective snapshot | Home Manager activation derivations |
| --- | --- | --- |
| `ryzen` | Matches, except the explained system toplevel hash | `matte` and `test` match exactly |
| `t14g1` | Matches, except the explained system toplevel hash | `matte` matches exactly |
| `game` | Matches, except the explained system toplevel hash | `matte` matches exactly |
| `live-installer` | Matches, except the explained system toplevel hash | `matte` matches exactly |

The only changed snapshot field for every host is `toplevel`.

### Why the system hashes change

Inspection with `nix derivation show` found that each system toplevel changes
only its output path and its `activate` derivation input. Each activation
derivation has identical dependency derivations and environment values apart
from its output path. Its script references the encrypted secret files through
`self`, whose repository source store path changes when repository files change.

Normalizing `/nix/store/<hash>-source` in the activation scripts produces four
matching before/after pairs. Secret files are unchanged. Package environments,
generated `/etc` content and the other toplevel dependency derivations match.
These are source-reference changes, not changes to selected machine behavior.

Static discovery also makes previously unimported upstream option definitions
available everywhere, including Zwift options and Disko build interfaces.
Their availability is intentional; disabled wrappers do not activate the
features or apply generated disk configuration.

## Checks

`nix develop --command fmt` followed by `nix develop --command check` passed
at each Nix implementation checkpoint. The check includes:

- `profile-discovery`: standalone modules, recursive categories, ignored
  documentation, deterministic ordering and directory-entrypoint ownership.
- `profile-options`: all enables default off; disabled imports add no packages,
  systemd service names or activation script names compared with plain NixOS;
  ordinary bundle overrides; standalone core children; overridable prerequisites;
  disabled upstream defaults; parent-gated models and Logitech driver;
  Disko device configuration remaining dormant until enabled; and selected
  Zwift, KDE and remote-filesystem effects.
- The existing treefmt check and evaluation of all four NixOS configurations
  and all three Cachix deployment outputs.

## Reproduce the comparison

From the repository root, with the baseline commit available locally:

```sh
nix eval --impure --json --expr '
  import ./tests/compare-profiles.nix {
    before = builtins.getFlake "git+file://${toString ./.}?rev=9efc99e6f26c1dc71a0f80eace5274c55b41be94";
    after = builtins.getFlake (toString ./.);
  }
'
```

For each host, expect `changedFields = [ "toplevel" ]` and
`homeManagerMatches = true`. The report includes both toplevel derivation paths
for further inspection. The snapshot projection deliberately avoids removed
options, functions, and unused options without defaults; it is a focused
behavior-preservation comparison rather than serialization of the entire NixOS
module result.
