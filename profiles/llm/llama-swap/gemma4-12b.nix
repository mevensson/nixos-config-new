{ pkgs, ... }:

let
  llama-server = "${pkgs.llama-cpp.override { vulkanSupport = true; }}/bin/llama-server";
in
{
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
}
