{
  description = "slock-1.5";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    {
      defaultPackage.x86_64-linux =
        with import nixpkgs { system = "x86_64-linux"; };
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

          installFlags = [ "PREFIX=$(out)" ];

          makeFlags = [ "CC:=$(CC)" ];

          postPatch = "sed -i '/chmod u+s/d' Makefile";

          meta = {
            mainProgram = "slock";
          };
        };
    };
}
