# nixosconfig

NixOS-Konfiguration (Flake) mit Home-Manager.

## Anwenden

```sh
sudo nixos-rebuild switch --flake .#heindl-pollux
```

Nur bauen/testen, ohne umzuschalten:

```sh
nixos-rebuild build --flake .#heindl-pollux
```

Inputs aktualisieren und formatieren:

```sh
nix flake update
nix fmt
```

## Aufbau

| Pfad | Inhalt |
|---|---|
| `flake.nix` | Hosts (`mkHost`) mit `stateVersion` und Feature-Flags |
| `configuration.nix` | Gemeinsame Basis (Nix, SSH, sudo, avahi, …) |
| `modules/options.nix` | Definition der Feature-Flags `local.features.*` |
| `modules/host/<name>` | Host-spezifisches (Hostname, Netzwerk, Hardware-Import) |
| `modules/hardware/<modell>` | Boot, `hardware-configuration.nix`, Grafik |
| `modules/software/*` | Software-Module, jeweils über Feature-Flags geschaltet |
| `modules/user/colaholiker` | Benutzer und Home-Manager-Konfiguration |

## Feature-Flags

`wayland`, `plasma6`, `networking`, `games`, `office`, `dev`,
`communication`, `emacs`, `deskflow`, `docker`, `winboat`, `virtualbox`,
`libvirt`, `vmwareHost`

## Neuen Host anlegen

1. `modules/host/<name>/default.nix` und ggf. `modules/hardware/<modell>/` anlegen
   (`hardware-configuration.nix` per `nixos-generate-config` erzeugen).
2. In `flake.nix` unter `nixosConfigurations` mit `mkHost` eintragen.
   `stateVersion` = NixOS-Version der Installation, danach nie ändern.
