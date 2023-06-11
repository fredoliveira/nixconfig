# NixOS configuration

This is my personal nixOS configuration. I'm using Nix to set up a reproducible development environment between all my machines. The goal is for things to be consistent across all the ways I work in code:

- In bare metal machines, like the machines where I do programming/ML research
- In VMs running on laptops, when I'm working on existing projects but don't want to install dependencies on the host

The initial inspiration for this was [mitchellh/nixos-config](https://github.com/mitchellh/nixos-config) (see [his video](https://www.youtube.com/watch?v=ubDMLoWz76U)).
Also see my dotfile setup at [fredoliveira/dotfiles](https://github.com/fredoliveira/dotfiles), which includes a lot more of how I set up my actual shell and tooling.

## Initial machine bootstrap

- Set up a new VM (or bare metal) and boot [the minimal NixOS ISO](https://nixos.org/download.html)
- Sudo into root and set up a new password, so that you can SSH in for the rest of the config

```bash
$ sudo su
$ passwd
```

- Note the IP address of the machine you are setting up with `ifconfig`
- From the host, export the IP address for the new machine and run the bootstrap process

```bash
$ export NIXADDR=192.168.xxx.xxx
$ make vm/init
```

- After the init process concludes, the machine will reboot automatically
- You can login using `root`
