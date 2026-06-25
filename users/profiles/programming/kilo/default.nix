{ config, lib, pkgs, llm-agents, openrouterApiKeyPath, ... }:

let
  kilocode-cli = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.kilocode-cli;

  cfg = config.programs.kilo;

  limitType = lib.types.submodule {
    options = {
      context = lib.mkOption { type = lib.types.int; };
      output = lib.mkOption { type = lib.types.int; default = 32768; };
    };
  };
in
{
  options.programs.kilo = {
    localModels = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          tool_call = lib.mkOption { type = lib.types.bool; default = true; };
          limit = lib.mkOption { type = limitType; };
        };
      });
      default = { };
    };

    remoteModels = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          tool_call = lib.mkOption { type = lib.types.bool; default = true; };
          limit = lib.mkOption { type = limitType; };
          reasoning = lib.mkOption { type = lib.types.bool; default = false; };
        };
      });
      default = { };
    };
  };

  config = {
    home.packages = [ kilocode-cli ];

    home.file.".config/kilo/kilo.jsonc".text =
      builtins.toJSON {
        "$schema" = "https://app.kilo.ai/config.json";
        provider = {
          openai-compatible = {
            options = {
              baseURL = "http://localhost:8080";
            };
            models = cfg.localModels;
          };
          openrouter = {
            options = {
              apiKey = "{env:OPENROUTER_API_KEY}";
              baseURL = "https://openrouter.ai/api/v1";
            };
            models = cfg.remoteModels;
          };
        };
      };

    home.sessionVariables.OPENROUTER_API_KEY =
      "$(cat ${openrouterApiKeyPath})";
  };
}
