#"!/usr/bin/env bash

set -x

disk=$1

decrypt() {
  local name=$1
  local destination=$2
  pushd secrets
  agenix -d $name > $destination
  popd
}

decrypt luks-password.age /tmp/luks-password
decrypt live-install-ssh-host-ed25519.age /tmp/live-install-ssh-host-ed25519

sudo nix run 'github:nix-community/disko/latest#disko-install' \
  -- \
  --flake .#live-installer \
  --disk main $disk \
  --extra-files /tmp/live-install-ssh-host-ed25519 /etc/ssh/ssh_host_ed25519_key \
  --extra-files hosts/live-installer/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub \
