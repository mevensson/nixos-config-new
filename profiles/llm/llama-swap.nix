{ pkgs, lib, ... }:

let
  modelsDir = "/var/lib/llama-swap/models";

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

  environment.systemPackages = [ llama-cpp-vulkan pkgs.llama-swap pkgs.curl ];

  services.llama-swap = {
    enable = true;
    settings = {
      healthCheckTimeout = 300;
      logLevel = "info";
      startPort = 10001;
      sendLoadingState = true;
      models = {
        "gemma4:12b" = {
          cmd = "${llama-server} --port \${PORT} --model ${modelsDir}/gemma-4-12b-it-Q4_K_M.gguf --n-gpu-layers 99 -c 24576 -b 512 -ub 512 -ctk q8_0 -ctv q8_0";
        };
        "qwen3.5:9b" = {
          cmd = "${llama-server} --port \${PORT} --model ${modelsDir}/qwen3.5-9b-q4_k_m.gguf --n-gpu-layers 99 -c 24576 -b 512 -ub 512 -ctk q8_0 -ctv q8_0";
        };
      };
    };
  };

  systemd.services.llama-swap = {
    after = [ "network.target" "llama-swap-download-models.service" ];
    wants = [ "llama-swap-download-models.service" ];
    serviceConfig = {
      User = lib.mkForce "llama-swap";
      DynamicUser = lib.mkForce false;
      StateDirectory = "llama-swap";
    };
  };

  systemd.services.llama-swap-download-models = {
    description = "Download GGUF models for llama-swap";
    before = [ "llama-swap.service" ];
    wantedBy = [ "llama-swap.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "llama-swap";
      StateDirectory = "llama-swap";
      WorkingDirectory = modelsDir;
    };
    script = ''
      ${pkgs.curl}/bin/curl -L -o ${modelsDir}/gemma-4-12b-it-Q4_K_M.gguf \
        "https://huggingface.co/bartowski/gemma-4-12b-it-GGUF/resolve/main/gemma-4-12b-it-Q4_K_M.gguf"

      ${pkgs.curl}/bin/curl -L -o ${modelsDir}/qwen3.5-9b-q4_k_m.gguf \
        "https://huggingface.co/Qwen/Qwen3.5-9B-GGUF/resolve/main/qwen3.5-9b-q4_k_m.gguf"
    '';
  };
}
