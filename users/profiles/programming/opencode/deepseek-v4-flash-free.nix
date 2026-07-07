{ lib, ... }: {
  programs.opencode.zenModels."deepseek-v4-flash-free" = {
    name = "DeepSeek V4 Flash Free (Zen)";
    tool_call = true;
    limit = {
      context = 200000;
      output = 32768;
    };
    reasoning = true;
  };
}
