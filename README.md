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

## Hardware

### `heindl-pollux` – ASUSPRO D520MT (`modules/hardware/asuspro_d520mt`)

| Komponente | Details |
|---|---|
| Mainboard / BIOS | ASUS D520MT (H110-Chipsatz), BIOS 0205 vom 15.10.2015, UEFI |
| CPU | Intel Core i5-6400 (Skylake, 4 Kerne, 2,7 GHz), VT-x |
| Grafik | Intel HD Graphics 530 (`i915`), Anschlüsse DP-1, DP-2, HDMI-A-1, HDMI-A-2 |
| RAM | 4 GB DDR4-2133 (SK Hynix) in DIMM_A1, DIMM_B1 frei, max. 32 GB |
| SSD | Samsung 860 EVO 500 GB (SATA): EFI 1 GB, root ext4 ~442 GB, Swap ~23 GB |
| Optisch | ASUS DVD-RAM GHD1N |
| Kartenleser | Alcor Micro USB (`/dev/sdb`) |
| Netzwerk | Intel I219-V (`e1000e`, `enp0s31f6`), kein WLAN |
| Audio | Intel HDA mit Realtek ALC887 + HDMI/DP-Audio |
| Sonstiges | 2× seriell, 1× parallel, Intel ME |
| Monitore | 2× LG BK550Y (1920×1080@60) an DP-1 (DP→HDMI-Kabel) und HDMI-A-2 – beide über KVM-Switch |
| KVM-Hinweis | Der KVM-Switch reicht Hotplug/EDID nicht zuverlässig durch, daher sind beide Anschlüsse fest eingeschaltet und bekommen die EDID des LG (`monitors.nix`) |

## Feature-Flags

`wayland`, `plasma6`, `networking`, `games`, `office`, `dev`,
`communication`, `emacs`, `deskflow`, `docker`, `winboat`, `virtualbox`,
`libvirt`, `vmwareHost`

## Neuen Host anlegen

1. `modules/host/<name>/default.nix` und ggf. `modules/hardware/<modell>/` anlegen
   (`hardware-configuration.nix` per `nixos-generate-config` erzeugen).
2. In `flake.nix` unter `nixosConfigurations` mit `mkHost` eintragen.
   `stateVersion` = NixOS-Version der Installation, danach nie ändern.
