{
  description = "JDK version dashboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
          jdkPackages = {
            corretto = { hasDefault = false; versions = [ "11" "17" "21" ]; };
            openjdk = { hasDefault = true; versions = [ "11" "17" "21" "24" ]; };
            semeru-bin = { hasDefault = true; versions = [ "-11" "-17" "-21" ]; };
            semeru-jre-bin = { hasDefault = true; versions = [ "-11" "-17" "-21" ]; };
            temurin-bin = { hasDefault = true; versions = [ "-23" "-24" ]; };
            temurin-jre-bin = { hasDefault = true; versions = [ "-11" "-17" "-21" "-23" "-24" ]; };
            zulu = { hasDefault = true; versions = [ "11" "17" "21" "24" ]; };
          };

          getVersion = name:
            let pkg = builtins.getAttr name pkgs;
            in pkg.version or (pkg.meta.version or "unknown");

          flattenVersions = attrset:
            lib.flatten (
              lib.mapAttrsToList
                (name: value:
                  lib.map (version: "${name}${version}") value.versions
                )
                attrset
            );

          flatPackages = flattenVersions jdkPackages;

          versionMap = builtins.listToAttrs (
            builtins.map (name: { inherit name; value = getVersion name; }) flatPackages
          );

          # JSON-encoded string for nix run
          versionMapJson = builtins.toJSON versionMap;
      in
      {
          #packages.${system}.jdk-dashboard = versionMap;

        # You can build with: nix build .#jdk-dashboard
        packages.jdk-dashboard = pkgs.writeText "jdk-dashboard.json" (builtins.toJSON versionMap);

          apps.${system}.jdk-dashboard = {
            type = "app";
            program = "${pkgs.writeShellScriptBin "jdk-dashboard" ''
              echo '${versionMapJson}'
            ''}/bin/jdk-dashboard";
          };

          # Or eval with: nix eval .#jdk-dashboard --json
          defaultPackage = self.packages.${system}.jdk-dashboard;
       }
    );
}

