{
  description = "Lost Nix new config"

  inputs = {
    #Nix pkgs channel
    nixpkgs.url = "github:nixos/pkgs?ref=nixos-unstable";

    #Home-manager
    home-manager = {
      url = "github:nix-comunity/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #Steam millennium
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nixvim
    nixvim.url = "github:nix-community/nixvim";

    #MangoWM
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }
  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./hosts/laptop/configuration.nix
        home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays = [ inputs.millennium.overlays.default ];
        }
      ];
    }
  }

}
