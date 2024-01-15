{ self, config, pkgs, ... }:
let
  name = "Test User";
in
{
  age.secrets = {
    test_password.file = "${self}/secrets/test_password.age";
  };

  home-manager.users.test =
    { lib
    , ...
    }: {
      imports = [
        ./profiles/graphical/firefox.nix
        ./profiles/graphical/gnome/default.nix
        ./profiles/shell/direnv.nix
        ./profiles/shell/fish.nix
        ./profiles/shell/fzf.nix
        ./profiles/shell/starship.nix
      ];

      home = {
        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        stateVersion = "22.05";
      };
    };

  users.users.test = {
    uid = 1001;
    hashedPasswordFile = config.age.secrets.test_password.path;
    description = name;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
}
