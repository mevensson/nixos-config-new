{ config, lib, pkgs, llm-agents, openrouterApiKeyPath, opencodeZenApiKeyPath, hasLocalModels, ... }:

let
  opencode = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
  cfg = config.programs.opencode;

  limitType = lib.types.submodule {
    options = {
      context = lib.mkOption { type = lib.types.int; };
      output = lib.mkOption { type = lib.types.int; default = 32768; };
    };
  };

  localProvider = lib.optionalAttrs hasLocalModels {
    llama.cpp = {
      npm = "@ai-sdk/openai-compatible";
      name = "Local (llama-swap)";
      options = {
        baseURL = "http://localhost:8080/v1";
      };
      models = cfg.localModels;
    };
  };
in
{
  options.programs.opencode = {
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

    zenModels = lib.mkOption {
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
    home.packages = [ opencode ];

    home.file.".config/opencode/opencode.jsonc".text =
      builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        model =
          if hasLocalModels
          then "llama.cpp/gemma4:12b"
          else "openrouter/deepseek/deepseek-v4-flash";
        provider = {
          openrouter = {
            options = {
              apiKey = "{file:${openrouterApiKeyPath}}";
            };
            models = cfg.remoteModels;
          };
          opencode = {
            npm = "@ai-sdk/openai-compatible";
            name = "OpenCode Zen";
            options = {
              baseURL = "https://opencode.ai/zen/v1";
              apiKey = "{file:${opencodeZenApiKeyPath}}";
            };
            models = cfg.zenModels;
          };
        } // localProvider;
      };
  };
}
