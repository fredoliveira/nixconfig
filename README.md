# NixOS configuration

This is my personal nixOS configuration. I'm using Nix to set up a reproducible development environment between all my machines. The goal is for things to be consistent across all the ways I work in code:

- In bare metal machines, like the machines where I do programming/ML research
- In VMs running on laptops, when I'm working on existing projects but don't want to install dependencies on the host

The initial inspiration for this was mitchellh/nixos-config.
Also see my dotfile setup at fredoliveira/dotfiles, which includes a lot more of how I set up my actual shell and tooling.
