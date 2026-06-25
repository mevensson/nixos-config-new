{ self, agenix, llm-agents, config, pkgs, ... }:
let
  name = "Mattias Evensson";
  email = "mattias@evensson.eu";
  openrouterApiKeyPath = config.age.secrets.openrouter_api_key.path;
in
{
  age.secrets = {
    matte_password.file = "${self}/secrets/matte_password.age";
    matte_id_ed25519.file = "${self}/secrets/matte_id_ed25519.age";
    matte_id_ed25519.owner = "matte";
    openrouter_api_key.file = "${self}/secrets/openrouter_api_key.age";
    openrouter_api_key.owner = "matte";
  };

  home-manager.users.matte =
    { lib
    , ...
    }: {
      _module.args = {
        llm-agents = llm-agents;
        inherit openrouterApiKeyPath;
        hasLocalModels = config.services.llama-swap.enable;
      };

      imports = [
        agenix.homeManagerModules.age
        ./profiles/graphical/firefox.nix
        ./profiles/graphical/gnome/default.nix
        ./profiles/graphical/gnome/extensions/tiling-shell.nix
        ./profiles/graphical/gnome/variety/default.nix
        ./profiles/graphical/gnome/variety/bing.nix
        ./profiles/programming/vscode/default.nix
        ./profiles/programming/gh.nix
        ./profiles/programming/opencode
        ./profiles/programming/opencode/deepseek-v4-flash.nix
        ./profiles/programming/opencode/gemma4-12b.nix
        ./profiles/programming/opencode/gemma4-26b.nix
        ./profiles/programming/opencode/qwen3-5-9b.nix
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

      programs.git.settings.user = {
        name = name;
        email = email;
      };
    };

  nix.settings = {
    trusted-users = [
      "matte"
    ];
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
