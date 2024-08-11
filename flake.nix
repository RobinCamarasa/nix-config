{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Vim plugins
    plugin-kubectlnvim = {
      url = "github:Ramilito/kubectl.nvim";
      flake = false;
    };
    plugin-gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    plugin-whichkey = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    plugin-fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };

    # Firefox addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
