{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprlnad Wayland Compositer
    hyprland.url = "github:hyprwm/Hyprland";

    # Hardware Configuration For My Systems
    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs =
    { self, nixpkgs, hyprland, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });
    in {
      # Your custom packages
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      # Formatter for your nix files
      formatter = nixpkgs.legacyPackages."x86_64-linux".alejandra;

      # Your custom packages and modifications
      overlays = import ./overlays { inherit inputs; };

      # Nixos modules
      nixosModules.default = import ./modules/nixos;

      # Home-manager modules
      homeManagerModules.default = import ./modules/home-manager;

      # NixOS configuration entrypoint
      nixosConfigurations = {
        lenovo = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./system ];
        };
      };

      # Home-manager configuration entrypoint
      homeConfigurations = {
        "haam" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home ];
        };
      };
    };
}
