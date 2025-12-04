{
  modules = rec {

    common = { config, pkgs, lib, ... }: {
    };

    dev = { config, pkgs, lib, ... }:
      lib.mkMerge [
        common
        {
            
        }
      ];

    prod = { config, pkgs, lib, ... }:
      lib.mkMerge [
        common
        {

        }
      ];
  };
}