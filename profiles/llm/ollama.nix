{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;

    loadModels = [
      "gemma4:e4b"
      "gemma4:26b"
      "nomic-embed-text:latest"
      "qwen3.5:9b"
      "qwen3.6:27b"
    ];
  };
}
