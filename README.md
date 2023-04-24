# printer-config

This is the location of managed printer profiles.

### How to install

```sh
cd ~
git clone https://github.com/jamesprints/printer-config.git
ln -sf ~/printer-config/ ~/printer_data/config/printer
```

### Add updater section

You need to update your moonraker.conf to alway get the latest version.

Either open your moonraker.conf and add

```ini
[update_manager printer-config]
type: git_repo
primary_branch: main
path: ~/printer-config
origin: https://github.com/jamesprints/printer-config.git
managed_services: klipper
```

below the mainsail updater section.

You can also link and include the prepared file to your moonraker.conf. ssh in your PI and

```sh
ln -sf ~/printer-config/printer-config-moonraker-update.conf ~/printer_data/config/printer-config-moonraker-update.conf
```

then open your moonraker.conf and add

```ini
[include printer-config-moonraker-update.conf]
```

below the mainsail updater section.

### How to setup

```ini
[include printer/<printer-name>.cfg]
```
