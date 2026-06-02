# AGENTS.md

## Dev commands (devshell)

```sh
nix develop                    # enter dev shell (direnv auto-loads via .envrc)
fmt                            # format all Nix files (nixpkgs-fmt via treefmt)
check                          # nix flake check
nix fmt                        # same as `fmt` command
```

## Local verification

`nix flake check` — no test framework, no typecheck step.

## Architecture

- Flake-parts flake. 3 host configs: `ryzen`, `t14g1`, `game`.
- `hosts/<name>/configuration.nix` imports `hardware-configuration.nix`, `disks.nix`, `swap.nix`.
- Reusable config in `profiles/` (boot, core, graphical, llm, remotefs, shells, sound).
- User configs in `users/` — home-manager per user. User profile modules in `users/profiles/`.
- Secrets encrypted with [agenix](https://github.com/ryantm/agenix). Public key registry: `secrets/secrets.nix`. Decrypted paths appear at runtime via `config.age.secrets`.
- Deploy via cachix-deploy: `nix build .#cachix-deploy-<host>` → push to cachix → `cachix deploy activate`.
- Nixpkgs: `nixos-unstable` branch. `allowUnfree = true`.

## CI (GitHub Actions)

- Runs on push/PR to `main`.
- Job order: `check` (nix flake check) → `build-ryzen` + `build-t14g1` (in parallel) → `success`/`failure`.
- Build target: `nix build .#cachix-deploy-<host>`.
- Deploy step runs only on `main` branch. Uses `CACHIX_ACTIVATE_TOKEN` secret.
- Caches via cachix (`mevensson-nixos-config`, `nix-community`).
- `update-flake-lock` runs weekly (Saturday 02:00 UTC) via DeterminateSystems action, auto-merges PRs.

## Secrets (agenix)

```sh
# Edit a secret
agenix -e secrets/<name>.age

# Rekey after adding/removing public keys
agenix --rekey
```

Public keys in `secrets/secrets.nix`. Currently encrypted: `matte_password`, `matte_id_ed25519`, `test_password`, 3x `cachix-deploy-agent` keys.

## Editor

VS Code with nixd LSP. Format on save via `nixpkgs-fmt`. nixd uses `nixosConfigurations.ryzen.options` for option completion.

## GitHub

Use `gh` (GitHub CLI) for all GitHub operations (issues, PRs, checks, releases). Available in the devshell.

PRs should be set to auto-merge with a merge commit.