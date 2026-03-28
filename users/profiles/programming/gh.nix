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
        file = ../../../secrets/matte-gh-hosts-yaml.age;
        path = "$HOME/.config/gh/hosts.yml";
      };
    };
  };
}
