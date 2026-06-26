{ lib, ... }: {
  programs.opencode.localModels."gemma4:26b" = {
    name = "Gemma 4 26b (Local, ROCm)";
    tool_call = true;
    limit = {
      context = 65536;
      output = 32768;
    };
  };
}
