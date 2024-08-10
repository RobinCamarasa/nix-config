.PHONY: rebuild test

ENV=default

rebuild:
	nixos-rebuild switch --flake /etc/nixos#$(ENV)

test:
	nixos-rebuild test --flake /etc/nixos#$(ENV)

clean:
	nix-collect-garbage --delete-older-than 2d
