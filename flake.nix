{
  description = "Sandbox for playing with https://github.com/lima-vm/lima/";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            docker
            docker-compose
            lima
          ];

          shellHook = ''
            vm_name="docker-vm"
            ctx_name="lima-$vm_name"

            if [ "$(grep $ctx_name $(docker context ls -q))" = "" ] ; then
              docker context create $ctx_name --docker "host=unix://$HOME/.lima/$vm_name/sock/docker.sock"
            fi

            export DOCKER_CONTEXT=$ctx_name
          '';
        };
      });
}
