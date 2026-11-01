# Tuya TS0601 CO2 Zigbee Edge Driver

SmartThings Edge driver for the Tuya TS0601 Zigbee sensor reporting
manufacturer `_TZE204_3ejwxpmu`.

The driver handles Tuya EF00 reports for:

| Measurement | Tuya datapoint | Conversion |
|---|---:|---|
| Carbon dioxide | 2 | ppm |
| Temperature | 18 | raw value / 10 °C |
| Relative humidity | 19 | raw value / 10 % |

These datapoints are based on community references for this manufacturer.
Verify readings on the physical device after installation.

## Requirements

- SmartThings CLI
- A SmartThings Hub supporting Edge drivers
- A SmartThings account and a driver channel enrolled on the Hub

## Build

From the monorepo root, build a local package without uploading it:

```powershell
.\scripts\build-driver.ps1 -Driver tuya-ts0601-co2-zigbee
```

## Install

Upload the package:

```powershell
smartthings edge:drivers:package .\drivers\tuya-ts0601-co2-zigbee
```

Assign the driver to a channel, enroll the Hub in that channel, install the
driver, and switch the existing device to it:

```powershell
smartthings edge:channels:create
smartthings edge:channels:enroll <hub-id> --channel <channel-id>
smartthings edge:channels:assign <driver-id> --channel <channel-id>
smartthings edge:drivers:install <driver-id> --hub <hub-id> --channel <channel-id>
smartthings edge:drivers:switch --hub <hub-id> --driver <driver-id> <device-id>
```

Channel creation requires a valid terms-of-service URL pointing to a page you
manage. Do not use a placeholder URL.

The bilingual terms are in the repository's [`tos.html`](../../tos.html).
GitHub Pages publishes from the `main` branch root:

<https://sheldenjeong.github.io/smartthings-edge-drivers/tos.html>

## Device fingerprint

The fingerprint intentionally matches only `_TZE204_3ejwxpmu` / `TS0601`.
Other TS0601 variants may use different datapoints and are not matched.
