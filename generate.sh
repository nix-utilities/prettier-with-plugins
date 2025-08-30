#!/usr/bin/env bash

set -eu -o pipefail;

cd "$( dirname "${BASH_SOURCE[0]}" )";

if ! [[ -x "$(which node2nix)" ]]; then
	printf >&2 'node2nix not found, try re-running within a nix-shell\n';
	printf >&2 '  nix-shell -p node2nix --run "%s"\n' "${BASH_SOURCE[0]}";
	exit 1;
fi

rm -f ./node-env.nix

# Track the latest active nodejs LTS here: https://nodejs.org/en/about/releases/
node2nix \
	-i node-packages.json \
	-o node-packages.nix \
	-c composition.nix \
	--pkg-name nodejs_22

# using --no-out-link in nix-build argument would cause the
# gc to run before the script finishes
# which would cause a failure
# it's safer to just remove the link after the script finishes
# see https://github.com/NixOS/nixpkgs/issues/112846 for more details
rm ./result
