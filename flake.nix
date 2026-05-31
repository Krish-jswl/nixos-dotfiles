{
	description = "My Nixos";
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-26.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixvim = {
      			url = "github:nix-community/nixvim/nixos-26.05";
    		};
		mangowm = {
			url = "github:mangowm/mango";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	
	outputs = { self, nixpkgs, home-manager, mangowm, nixvim, ... }: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
				mangowm.nixosModules.mango
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						sharedModules = [
							nixvim.homeModules.nixvim
						];
						users.krishj = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}

