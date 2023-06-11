# NixOS configuration

This is my personal nixOS configuration. I'm using Nix to set up a reproducible development environment between all my machines. The goal is for things to be consistent across all the ways I work in code:

- In bare metal machines, like the machines where I do programming/ML research
- In VMs running on laptops, when I'm working on existing projects but don't want to install dependencies on the host

The initial inspiration for this was [mitchellh/nixos-config](https://github.com/mitchellh/nixos-config).
Also see my dotfile setup at [fredoliveira/dotfiles](https://github.com/fredoliveira/dotfiles), which includes a lot more of how I set up my actual shell and tooling.

## Bootstrapping the machine using this setup

- Set up a new virtual machine (or bare metal machine) and boot it up using [the minimal NixOS ISO](https://nixos.org/download.html)
- At this point you will be booted into the minimal installation ISO
- Sudo into root (`sudo -i`) and set up a new password (`passwd`), so that you can SSH in for the rest of the config
- Note the IP address of the machine you are setting up (`ifconfig`)
- From the host machine (or another machine), export the IP address (`export NIXADDR=192.168.xxx.xxx`) and run the bootstrap process (`make vm/init`)
- After the installation concludes, the machine will reboot
- You can login using `root`
