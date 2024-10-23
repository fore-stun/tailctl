{ lib
, buildGoApplication
}:

let
  pname = "tailctl";
  version = "0.1.0";

  src = lib.cleanSourceWith {
    filter = name: type:
      ! (type == "directory" && name == ".github")
    ;
    src = lib.cleanSource ./.;
  };
in

buildGoApplication {
  inherit pname version src;
  modules = ./gomod2nix.toml;
  meta = {
    description = "Tailscale ACL controller using pulumi";
    homepage = "https://github.com/fore-stun/tailctl";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
