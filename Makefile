.PHONY: rebuild test

ENV=default

rebuild:
	nixos-rebuild switch --flake /etc/nixos#$(ENV) --impure

test:
	nixos-rebuild test --flake /etc/nixos#$(ENV) --impure

clean:
	nix-collect-garbage --delete-older-than 2d

update:
	nix flake update
