{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }: 
    let
      # The one username line to change if this isn't your machine.
      # bootstrap.sh offers to rewrite this for you if your macOS username differs.
      user = "vaibhavsingh";
    in
    {
      darwinConfigurations."macbase" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user; };
        modules = [ 
          ./configuration_base.nix 
     	  nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit user; };
            home-manager.users.${user} = import ./home.nix;
          }
        ];
      };
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user; };
        modules = [ 
          ./configuration_base.nix 
          ./configuration_mbpro.nix 
     	  nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit user; };
            home-manager.users.${user} = import ./home.nix;
          }
        ];
      };
    };
}
