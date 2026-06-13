{ pkgs, lib, llm-agents, openrouterApiKeyPath, ... }:

let
  kilocode-cli = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.kilocode-cli;
in
{
  home.packages = [ kilocode-cli ];

  home.file.".config/kilo/kilo.jsonc".text = ''
    {
      "$schema": "https://app.kilo.ai/config.json",
      "model": "openai-compatible/gemma4:12b",
      "provider": {
        "openai-compatible": {
          "options": {
            "baseURL": "http://localhost:8080"
          },
          "models": {
            "gemma4:12b": {
              "name": "Gemma 4 12b (Local)",
              "tool_call": true,
              "limit": { "context": 24576, "output": 8192 }
            },
            "qwen3.5:9b": {
              "name": "Qwen 3.5 9b (Local)",
              "tool_call": true,
              "limit": { "context": 24576, "output": 8192 }
            }
          }
        },
        "openrouter": {
          "options": {
            "apiKey": "{env:OPENROUTER_API_KEY}",
            "baseURL": "https://openrouter.ai/api/v1"
          },
          "models": {
            "deepseek/deepseek-v4-flash": {
              "name": "DeepSeek V4 Flash",
              "tool_call": true,
              "reasoning": true,
              "limit": { "context": 1048576, "output": 32768 }
            }
          }
        }
      }
    }
  '';

  home.sessionVariables.OPENROUTER_API_KEY =
    "$(cat ${openrouterApiKeyPath})";
}
