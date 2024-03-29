# Nix aliases for Determinate Systems install if nix found
if whereis nix 2>&1 > /dev/null; then
    alias nix-upgrade="sudo -i nix upgrade-nix"
    alias nix-update="nix profile upgrade '.*'"
    alias nix-search="nix search nixpkgs"
    alias nix-list="nix profile list | grep 'Flake attribute' | cut -d ':' -f 2"
    alias nix-hist="nix profile history"
    alias nix-rollb="nix profile rollback"

    nix_install () {
        nix profile install nixpkgs\#"$1"
    }

    nix_remove () {
        nix profile remove "$1" && nix-collect-garbage
    }
fi
