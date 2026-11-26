{ config, lib, pkgs, ... }:

let
  llama-server = "${pkgs.llama-cpp.override { vulkanSupport = true; }}/bin/llama-server";
in
{
  options.myConfigs.llm.llama-swap.models.qwen3-5-9b.enable = lib.mkEnableOption "the Qwen 3.5 9B model";

  config = lib.mkIf (config.myConfigs.llm.llama-swap.enable && config.myConfigs.llm.llama-swap.models.qwen3-5-9b.enable) {
    services.llama-swap.settings.models."qwen3.5:9b" = {
      cmd = ''
        ${llama-server} \
        --port ''${PORT} \
        --hf-repo unsloth/Qwen3.5-9B-MTP-GGUF:UD-Q4_K_XL \
        --n-gpu-layers 99 \
        -c 65536 \
        -fa
      '';
    };
  };
}
