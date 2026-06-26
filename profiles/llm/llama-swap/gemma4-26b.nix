{ pkgs, ... }:

let
  llama-server = "${pkgs.llama-cpp-rocm}/bin/llama-server";
in
{
  services.llama-swap.settings.models."gemma4:26b" = {
    cmd = ''
      ${llama-server} \
      --port ''${PORT} \
      --hf-repo unsloth/gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL \
      --n-gpu-layers 99 \
      -c 65536 \
      -fa \
      --n-cpu-moe 3 \
      --ubatch-size 2048 \
      --cache-type-k q8_0 \
      --cache-type-v q8_0
    '';
  };
}
