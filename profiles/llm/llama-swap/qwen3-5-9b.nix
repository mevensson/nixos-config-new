{ pkgs, ... }:

let
  llama-server = "${pkgs.llama-cpp.override { vulkanSupport = true; }}/bin/llama-server";
in
{
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
}
