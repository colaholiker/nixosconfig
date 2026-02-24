{ config, lib, pkgs, ... }:

let
  baseGroups = [
    "wheel"
    "networkmanager"
    "dialout"
    "docker"
    "uucp" # legacy group for serial devices
  ];
in

{
  users.users.colaholiker = {
    isNormalUser = true;
    extraGroups = lib.unique (baseGroups ++ config.local.userExtraGroups);
    shell = pkgs.bash;
    linger = false;
    initialPassword = "Menu0815";
    hashedPassword = "$6$uKKJkOFnj1mJQYZA$SdNNtYLjMYVmkGGjlMScNSAd8F88bIfdo3vw/iGLlUMtSvC8DcE.fGXyT3500wK7Oen32YDV1zRkVKqG1n5XY1";
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAimKdi6e/ySszoRksbU2e+MAxw5//sfabYrEdCkKaSW1K36tzXpxM/ddDgUrXIz7/xNJRLqALQvE+ZH6vtWg8k+ZSM25JDb5eFhTICXvQ/Xod5w0NC5dUsui7kRTTXqaUCXT+kdrI1COYqC7b7sLgX0Kq0CdDzZ7s35vqmapHskhKIGiGpsDO9s0ps2cjp2RmGj8Do1gOswAvuYHc6XcjNmugi7qZDDajYgWS3oMEQDNi9qZb4FWn2lS9Cti8n9ucN69QdDv9hxV1adxdf/pVqiIdWmAAxwEc+Ysx3NtY/xZpVg0ibkrLeWhPtCSsVZak1wz8xPv6Uf2LkmGegt+e2w== Sebastian During"
    ];
  };
}