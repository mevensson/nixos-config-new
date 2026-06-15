{ pkgs, ... }:

let
  llama-server = "${pkgs.llama-cpp.override { vulkanSupport = true; }}/bin/llama-server";
in
{
  services.llama-swap.settings.models."qwen3.5:9b" = {
    cmd = "${llama-server} --port \${PORT} --hf-repo Qwen/Qwen3.5-9B-GGUF:Q4_K_M --n-gpu-layers 99 -c 24576 -b 512 -ub 512 -ctk q8_0 -ctv q8_0";
  };
}
