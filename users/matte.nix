{ self, config, pkgs, ... }:
let
  name = "Mattias Evensson";
  email = "mattias@evensson.eu";
in
{
  age.secrets = {
    matte_password.file = "${self}/secrets/matte_password.age";
    matte_id_ed25519.file = "${self}/secrets/matte_id_ed25519.age";
    matte_id_ed25519.owner = "matte";
  };

  home-manager.users.matte =
    { lib
    , ...
    }: {
      imports = [
        ./profiles/graphical/firefox.nix
        ./profiles/shell/direnv.nix
        ./profiles/shell/fish.nix
        ./profiles/shell/fzf.nix
        ./profiles/shell/git.nix
        ./profiles/shell/starship.nix
      ];

      home = {
        activation.myActivationAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p ~/.ssh
          ln -sf /run/agenix/matte_id_ed25519 ~/.ssh/id_ed25519
        '';

        file = {
          ".ssh/id_ed25519.pub".source = ./id_ed25519.pub;
        };

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

      programs.git = {
        userName = name;
        userEmail = email;
      };
    };

  users.users.matte = {
    uid = 1000;
    hashedPasswordFile = config.age.secrets.matte_password.path;
    description = name;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [ ./id_ed25519.pub ];
  };
}
