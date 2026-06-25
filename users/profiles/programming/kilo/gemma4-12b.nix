{ lib, ... }: {
  programs.kilo.localModels."gemma4:12b" = {
    name = "Gemma 4 12b (Local)";
    tool_call = true;
    limit = {
      context = 65536;
      output = 32768;
    };
  };
}
