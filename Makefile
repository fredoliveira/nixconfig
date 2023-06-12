# Connectivity info for Linux VM
NIXADDR ?= unset
NIXPORT ?= 22
NIXUSER ?= fred
NIXNAME ?= replica

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS=-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# initialize a brand new VM. The VM should have NixOS ISO on the CD drive
# and just set the password of the root user to "root". This will install
# NixOS. After installing NixOS, you must reboot and set the root password
# for the next step.
vm/init:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) root@$(NIXADDR) " \
		parted /dev/nvme0n1 -- mklabel gpt; \
		parted /dev/nvme0n1 -- mkpart primary 512MiB -8GiB; \
		parted /dev/nvme0n1 -- mkpart primary linux-swap -8GiB 100\%; \
		parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB; \
		parted /dev/nvme0n1 -- set 3 esp on; \
		sleep 1; \
		mkfs.ext4 -L nixos /dev/nvme0n1p1; \
		mkswap -L swap /dev/nvme0n1p2; \
		mkfs.fat -F 32 -n boot /dev/nvme0n1p3; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
		nixos-generate-config --root /mnt; \
		sed --in-place '/system\.stateVersion = .*/a \
			nix.package = pkgs.nixUnstable;\n \
			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
			services.openssh.enable = true;\n \
			services.openssh.passwordAuthentication = true;\n \
			services.openssh.permitRootLogin = \"yes\";\n \
			users.users.root.initialPassword = \"root\";\n \
		' /mnt/etc/nixos/configuration.nix; \
		nixos-install --no-root-passwd; \
		reboot; \
	"

vm/configure:
	NIXUSER=root $(MAKE) vm/copy
	NIXUSER=root $(MAKE) vm/switch
	ssh $(SSH_OPTIONS) -p$(NIXPORT) root@$(NIXADDR) " \
		reboot; \
	"

vm/copy:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--exclude='.git/' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXUSER)@$(NIXADDR):/nixconfig

vm/switch:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		nixos-rebuild switch --flake \"/nixconfig#${NIXNAME}\" \
	"
