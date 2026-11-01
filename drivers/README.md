# Driver package conventions

Each immediate child directory of `drivers/` is an independent SmartThings Edge driver package. Build and upload only the selected driver directory, never the monorepo root.

## Recommended layout

```text
drivers/
  <vendor-device-protocol>/
    config.yaml
    fingerprints.yaml
    profiles/
      <profile-name>.yaml
    src/
      init.lua
    README.md
```

Include only files required by that driver. `fingerprints.yaml` is used by fingerprint-based protocols; LAN or other driver types may need different discovery/configuration files. Confirm the current SmartThings CLI and SDK conventions rather than copying protocol-specific files blindly.

## Adding a driver checklist

- [ ] Confirm protocol, exact vendor/model identifiers, and device variants from SmartThings/device evidence.
- [ ] Choose a unique kebab-case folder name and unique `packageKey`.
- [ ] Set only the protocol permissions the driver actually needs.
- [ ] Add profile capabilities/components and fingerprints that match verified behavior.
- [ ] Keep source, tests, and device-specific docs within the driver folder.
- [ ] Add the driver to the root catalog and document build, limitations, and physical test status.
- [ ] Run `.\scripts\build-driver.ps1 -Driver <folder-name>` from the repository root.

Do not share a profile, fingerprint, or decoder between drivers unless the devices have verified identical behavior.
