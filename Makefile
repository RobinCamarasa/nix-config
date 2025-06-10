.PHONY: rebuild test

NIXHOST := $(shell echo $$NIXHOST)

rebuild:
	sudo nixos-rebuild switch --flake /etc/nixos#$(NIXHOST) --impure

test:
	sudo nixos-rebuild test --flake /etc/nixos#$(NIXHOST) --impure

clean:
	sudo nix-collect-garbage --delete-older-than 2d

update:
	sudo nix flake update
