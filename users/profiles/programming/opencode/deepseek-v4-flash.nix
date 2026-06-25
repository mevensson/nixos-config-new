{ lib, ... }: {
  programs.opencode.remoteModels."deepseek/deepseek-v4-flash" = {
    name = "DeepSeek V4 Flash";
    tool_call = true;
    limit = {
      context = 1048576;
      output = 32768;
    };
    reasoning = true;
  };
}
