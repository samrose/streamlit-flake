{
  description = "Streamlit package";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pname = "streamlit";

      defaultPackage = pkgs.python3Packages.buildPythonApplication rec {
        name = pname;
        version = "1.27.0";
        src = pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-WacEGVu8Zpx5Td/MOBhIDZucKigsArSKpubeSxw40KA=";
        };
        propagatedBuildInputs = [
          pkgs.python3Packages.plotly pkgs.python3Packages.openpyxl pkgs.python3Packages.pydeck pkgs.python3Packages.altair pkgs.python3Packages.shapely pkgs.python3Packages.geopy pkgs.python3Packages.matplotlib pkgs.python3Packages.blinker pkgs.python3Packages.cachetools pkgs.python3Packages.click pkgs.python3Packages.folium  pkgs.python3Packages.requests pkgs.python3Packages.geopandas pkgs.python3Packages.gitpython pkgs.python3Packages.importlib-metadata pkgs.python3Packages.jinja2 pkgs.python3Packages.pillow pkgs.python3Packages.protobuf3 pkgs.python3Packages.pyarrow pkgs.python3Packages.pydeck pkgs.python3Packages.pympler pkgs.python3Packages.requests pkgs.python3Packages.rich pkgs.python3Packages.semver pkgs.python3Packages.setuptools pkgs.python3Packages.toml pkgs.python3Packages.tornado pkgs.python3Packages.tzlocal pkgs.python3Packages.validators pkgs.python3Packages.watchdog
        ];
        postInstall = ''
          rm $out/bin/streamlit.cmd # remove Windows helper
        '';
        doCheck = false;
        meta = {
          homepage = "https://streamlit.io/";
          description = "The fastest way to build custom ML tools";
          maintainers = with pkgs.maintainers; [ samrose ];
          license = pkgs.lib.licenses.asl20;
        };
      };
      devShell = pkgs.mkShell {
        buildInputs = [ defaultPackage ] ++ defaultPackage.propagatedBuildInputs;
        shellHook = ''
          source .env
        '';
      };
    in
      {
        devShell.${system} = devShell;
        packages.${system}.default = defaultPackage;
      };
}
