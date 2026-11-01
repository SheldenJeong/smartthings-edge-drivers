# SmartThings Edge Drivers

A collection of independently packaged SmartThings Edge drivers.

## Drivers

| Driver | Protocol | Device |
|---|---|---|
| [`tuya-ts0601-co2-zigbee`](drivers/tuya-ts0601-co2-zigbee/) | Zigbee | Tuya TS0601 Air Quality (`_TZE204_3ejwxpmu`) |

Each folder under `drivers/` is a standalone SmartThings Edge driver project with its own `config.yaml`, source, profile, and fingerprints. Keep driver-specific code and documentation inside that folder; shared build tooling and repository-wide guidance belong at the root.

## Build a driver

Requirements: SmartThings CLI installed and authenticated. Build a local package without uploading it:

```powershell
.\scripts\build-driver.ps1 -Driver tuya-ts0601-co2-zigbee
```

The generated archive is written to the ignored `dist/` directory. For direct CLI use:

```powershell
smartthings edge:drivers:package --build-only .\dist\tuya-ts0601-co2-zigbee.zip .\drivers\tuya-ts0601-co2-zigbee
```

Building does not upload the driver. Upload, channel assignment, Hub enrollment, installation, and switching a paired device are separate account-changing steps. Follow the driver-specific README and confirm the target Hub/device before making those changes.

## Add another driver

1. Create a kebab-case folder under [`drivers/`](drivers/), named for the device and protocol, for example `vendor-device-protocol`.
2. Keep that driver as an independent package: add `config.yaml`, `src/`, `profiles/`, and protocol-specific files such as `fingerprints.yaml` where required.
3. Use a unique `packageKey`, exact device fingerprints, minimum protocol permissions, and a profile that only exposes verified capabilities.
4. Add a driver README describing supported device variants, evidence/known limitations, build and installation steps, and physical verification status.
5. Add the driver to the table above and build it with `.\scripts\build-driver.ps1 -Driver <folder-name>`.
6. Validate with the actual device and Hub before claiming compatibility. Do not assume siblings with the same marketing model use the same protocol mapping.

See [`drivers/README.md`](drivers/README.md) for the per-driver layout and checklist.

## Terms of Service

The bilingual [Terms of Service](tos.html) are maintained at the repository root. After this change is published, verify that <https://sheldenjeong.github.io/smartthings-edge-drivers/tos.html> is accessible, then update the SmartThings channel to use that URL. Keep the URL within the channel's 75-character limit. GitHub Pages is configured from the `main` branch root.
