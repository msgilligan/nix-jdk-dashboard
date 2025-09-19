{
  description = "JDK version dashboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, flake-utils }:
    let
      lib = nixpkgs.lib;

      allowedUnfree = [ "graalvm-oracle" ];

      # Return a key to path mapping
      namePathEntry = name: version: pkgAttrs:
        let
          key = if version == null then name else "${name}${pkgAttrs.separator}${version}";
          path = if pkgAttrs ? path then pkgAttrs.path else name;
          versionedPath = if version == null then path else "${path}${pkgAttrs.separator}${version}";
        in
          lib.nameValuePair key versionedPath;

      flattenPackages = attrset:
          lib.concatMapAttrs (name: value: value) (builtins.mapAttrs
            (name: pkgAttrs:
              lib.listToAttrs (lib.map ( version: (namePathEntry name version pkgAttrs) ) pkgAttrs.versions
              ++ lib.optionals pkgAttrs.hasDefault [ (namePathEntry name null pkgAttrs) ])
            )
            attrset);

      jdkPackages = import ./jdks.nix;
      flatPackages = flattenPackages jdkPackages;
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) allowedUnfree;
        };
        lib = pkgs.lib;

          nixpkgsRef =
            if inputs.nixpkgs ? url then inputs.nixpkgs.url
            else if inputs.nixpkgs ? outPath && inputs.nixpkgs ? rev then "${inputs.nixpkgs.outPath} (rev ${inputs.nixpkgs.rev})"
            else if inputs.nixpkgs ? outPath then inputs.nixpkgs.outPath
            else "<unknown>";

#         nixpkgsRef =
#           inputs.nixpkgs.url or
#           inputs.nixpkgs.outPath or
#           inputs.nixpkgs.rev;


          getPackageInfo = path:
            let
              pkg = lib.attrsets.getAttrFromPath (lib.splitString "." path) pkgs;
              version = pkg.version or (pkg.meta.version or "unknown");
              home = pkg.home;
            in {
              #inherit version home;
              inherit version;
            };

          packageMap = lib.mapAttrs (
            name: path: getPackageInfo path 
          ) flatPackages;
      in
      {
          dashboard = {
            system = "${system}";
            nixpkgsSource = nixpkgsRef;
            packages = packageMap;  
          };
       }
    )
    // {
      inherit jdkPackages flatPackages;
    };
}

