{ lib
, dex
, go
, gomod2nix
, go-mod-graph-chart
, hostPlatform
, mkGoEnv
, mkShell
, xdg-utils
, zsh
, bootstrap ? false
}:

let
  name = "go${if bootstrap then "-bootstrap" else ""}";

  goEnv = mkGoEnv { pwd = ./.; };

  BROWSER =
    if hostPlatform.isLinux then ''
      ${lib.getExe dex} -d "/run/current-system/sw/share/applications/$(
        ${xdg-utils}/bin/xdg-settings get default-web-browser
      )" \
        | sed -E -n -e 's/^Executing command: //p'
    ''
    else "echo open";
in
mkShell {
  inherit name;

  packages = [
    go
    gomod2nix
    go-mod-graph-chart
  ] ++ lib.optionals (!bootstrap) [
    goEnv
  ];

  shellHook = ''
    export NIX_SHELL_NAME="${name}"
    export BROWSER="$(${BROWSER})"
    RPROMPT='%F{magenta}${name}%f %1(j.«%j» .)%*'
    ${zsh}/bin/zsh
    exit "$?"
  '';
}
