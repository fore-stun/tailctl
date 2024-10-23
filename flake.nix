{
  description = "Tailctl — tailscale ACL controller using API.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    gomod2nix.url = "github:fore-stun/gomod2nix/fix-recursive-symlinker";
    gomod2nix.inputs.nixpkgs.follows = "nixpkgs";
    gomod2nix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
    { } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        forAarch64Linux = drv: drv.overrideAttrs (old: {
          GOOS = "linux";
          GOARCH = "arm64";
          CGO_ENABLED = false;
        });

        # The current default sdk for macOS fails to compile go projects, so we use a newer one for now.
        # This has no effect on other platforms.
        callPackage = pkgs.darwin.apple_sdk_11_0.callPackage or pkgs.callPackage;
      in
      {
        packages.default = callPackage ./. {
          inherit (gomod2nix.legacyPackages.${system}) buildGoApplication;
        };
        packages.devShell = callPackage ./shell.nix {
          inherit (gomod2nix.legacyPackages.${system}) mkGoEnv gomod2nix;
        };
        packages.bootstrap = self.packages.${system}.devShell.override { bootstrap = true; };
        packages.aarch64-linux = forAarch64Linux self.packages.${system}.default;

        devShells.default = self.packages.${system}.devShell;
        devShells.bootstrap = self.packages.${system}.bootstrap;
      })
  ;
}
