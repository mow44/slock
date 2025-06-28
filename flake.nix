{
  description = "slock";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        configFile = import ./config.nix {
          inherit pkgs;
        };
      in
      {
        packages = rec {
          slock = pkgs.stdenv.mkDerivation {
            name = "slock";
            version = "1.5";

            src = self;

            buildInputs = with pkgs; [
              xorg.xorgproto
              xorg.libX11
              xorg.libXext
              xorg.libXrandr
              libxcrypt
            ];

            makeFlags = [ "CC:=$(CC)" ];
            installFlags = [ "PREFIX=$(out)" ];

            prePatch = ''
              cp ${configFile} config.def.h
            '';

            postPatch = "sed -i '/chmod u+s/d' Makefile";

            meta = {
              mainProgram = "slock";
            };
          };

          default = slock;
        };
      }
    );
}
