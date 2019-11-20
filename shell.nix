# this defines the Nix env to run this interactive Haskell project
with (import (
# to use a version of Haze from github
#   builtins.fetchTarball {
#     url = "https://github.com/complyue/haze/archive/0.1.0.0.tar.gz";
#     sha256 = "xxx";
#   }

  # to use the version of Haze checked out locally
  ../haze
) { });
haskellPackages.shellFor {
  packages = p: [ p.zlib p.haze ];
  nativeBuildInputs = [ pkgs.stack pkgs.hadui ];
}
