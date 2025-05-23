{
  description = "slock";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      configFile = import ./config.nix {
        inherit pkgs;
      };
    in
    {
      defaultPackage.${system} =
        with pkgs;
        stdenv.mkDerivation {
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
    };
}
