{ pkgs, lib, ... }:

let
  llama-cpp-vulkan = pkgs.llama-cpp.override {
    vulkanSupport = true;
  };

  llama-server = "${llama-cpp-vulkan}/bin/llama-server";
in
{
  users.users.llama-swap = {
    isSystemUser = true;
    group = "llama-swap";
  };
  users.groups.llama-swap = { };

  environment.systemPackages = [ llama-cpp-vulkan pkgs.llama-swap ];

  services.llama-swap = {
    enable = true;
    settings = {
      healthCheckTimeout = 300;
      logLevel = "info";
      startPort = 10001;
      sendLoadingState = true;
      models = {
        "gemma4:12b" = {
          cmd = "${llama-server} --port \${PORT} --hf-repo bartowski/gemma-4-12b-it-GGUF:Q4_K_M --n-gpu-layers 99 -c 24576 -b 512 -ub 512 -ctk q8_0 -ctv q8_0";
        };
        "qwen3.5:9b" = {
          cmd = "${llama-server} --port \${PORT} --hf-repo Qwen/Qwen3.5-9B-GGUF:Q4_K_M --n-gpu-layers 99 -c 24576 -b 512 -ub 512 -ctk q8_0 -ctv q8_0";
        };
      };
    };
  };

  systemd.services.llama-swap = {
    serviceConfig = {
      User = lib.mkForce "llama-swap";
      DynamicUser = lib.mkForce false;
      StateDirectory = "llama-swap";
    };
  };
}
