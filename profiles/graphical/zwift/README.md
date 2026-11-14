# Zwift

## Launch and update

As `matte`, pull the game image before first launch and whenever an update is
needed. Image updates are manual:

```sh
podman pull docker.io/netbrain/zwift:latest
zwift
```

Zwift is also available in the application menu. Use `ZWIFT_FG=1 zwift` to see
logs in the terminal.

## Pair devices

Keep the phone and host on the same LAN, open Zwift Companion with Bluetooth
enabled, then select **Pairing Options → Enable Companion Bridging** in Zwift.
Wi-Fi/Ethernet trainers can connect directly on the same LAN. ANT+ is unsupported.

## Change the password

From the repository's `secrets` directory:

```sh
agenix -e zwift_password.age
```

Enter only the password on one line, then rebuild and activate the configuration.
The next launch imports the updated password automatically.

## Save settings

Exit through Zwift's own controls and wait for **“Synchronized Zwift settings”**
before closing the terminal. Interrupting the container can prevent settings from
being saved. Keep the persistent Podman volume `zwift-matte` when cleaning up
images; it holds settings, activities, and workouts.
