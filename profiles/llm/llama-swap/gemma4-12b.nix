{ config, lib, pkgs, ... }:

let
  llama-server = "${pkgs.llama-cpp.override { vulkanSupport = true; }}/bin/llama-server";
in
{
  options.myConfigs.llm.llama-swap.models.gemma4-12b.enable = lib.mkEnableOption "the Gemma 4 12B model";

  config = lib.mkIf (config.myConfigs.llm.llama-swap.enable && config.myConfigs.llm.llama-swap.models.gemma4-12b.enable) {
    services.llama-swap.settings.models."gemma4:12b" = {
      cmd = ''
        ${llama-server} \
        --port ''${PORT} \
        --hf-repo unsloth/gemma-4-12B-it-qat-GGUF:UD-Q4_K_XL \
        --n-gpu-layers 99 \
        -c 65536 \
        -fa
      '';
    };
  };
}
