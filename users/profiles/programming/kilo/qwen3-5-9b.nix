{ lib, ... }: {
  programs.kilo.localModels."qwen3.5:9b" = {
    name = "Qwen 3.5 9b (Local)";
    tool_call = true;
    limit = {
      context = 65536;
      output = 32768;
    };
  };
}
