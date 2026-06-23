{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableFishIntegration = true;
    settings = {
      theme = "GitHub Dark High Contrast";
      mouse-hide-while-typing = true;
      copy-on-select = "clipboard";
      cursor-style = "beam";
      cursor-style-blink = true;
      window-padding-x = 10;
      window-padding-y = 8;
      window-padding-balance = true;
      window-save-state = "always";
    };
  };
}
