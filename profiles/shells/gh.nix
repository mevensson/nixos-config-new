{ config, self, ... }:
{
  programs = {
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };

    gh-dash = {
      enable = true;
    };
  };

  age = {
    secrets = {
      matte-gh-hosts-yaml = {
        file = "${self}/secrets/matte-gh-hosts-yaml.age";
        path = "${config.xdg.configHome}/gh/hosts.yml";
      };
    };
  };
}
