# Zwift

Zwift uses [netbrain/zwift](https://github.com/netbrain/zwift) with rootless
Podman, host networking, and GPU passthrough. After deploying the configuration,
log out and back in so the GPU group memberships take effect.

## First launch

Run these commands as `matte`, without `sudo`, from a GNOME terminal:

```sh
podman info --format '{{.Host.Security.Rootless}}'
podman pull docker.io/netbrain/zwift:latest
zwift
```

The first command should print `true`. Zwift is also available in GNOME's
application menu. Sign in interactively on first launch.

For Bluetooth trainers and sensors:

1. Connect the phone and host to the same LAN and open Zwift Companion on the
   phone with Bluetooth enabled.
2. In Zwift's paired devices screen, select **Pairing Options**, enable
   **Companion Bridging**, and save.
3. Pair the trainer and sensors, then verify graphics, audio, and device data
   during a short ride. Exit and relaunch to check persistence.

Wi-Fi/Ethernet trainers can use direct discovery on the same LAN. Direct host
Bluetooth access is disabled; ANT+ is not supported by this solution. USB
trainers require device-specific passthrough and potentially a udev rule.

## Updates and storage

The launcher is pinned by `flake.lock`. Update it with `nix flake update zwift`,
then check, build, and deploy the configuration as usual. Its built-in updater
is disabled because it attempts to install outside Nix. This also disables
automatic container-image pulls, so update the game image manually as `matte`
before launching:

```sh
podman pull docker.io/netbrain/zwift:latest
```

The `latest` image is updated independently of the Nix-pinned launcher. Podman
stores images and the persistent `zwift-matte` volume under
`~/.local/share/containers/storage` by default. The volume preserves Zwift data,
including activities and workouts, across container restarts and image updates.
Do not remove this volume when cleaning up old images.

Saved credentials can be configured later using upstream's
[keyring or Podman secret support](https://netbrain.github.io/zwift/configuration/authentication/).

## Troubleshooting

- Inspect the generated container command from the graphical session with
  `DRYRUN=1 zwift`.
- Inspect the running container with `podman ps` and its output with
  `podman logs zwift-matte`. Use `ZWIFT_FG=1 zwift` to launch in the foreground.
- For GPU permission errors, check `id` includes `video` and `render`, then
  check access to `/dev/dri`. Log out and back in after group changes.
- For pairing problems, check the phone/trainer and host are on the same LAN
  without Wi-Fi client isolation. This profile uses host networking and allows
  UDP ports 3022/3024 and TCP ports 21587/21588 as documented upstream.
- The default display path is XWayland under GNOME. For display or audio issues,
  launch from a terminal inside the desktop session and inspect the logs. Audio
  uses the PulseAudio-compatible socket provided by PipeWire.
