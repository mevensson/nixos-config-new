{
  programs.vscode = {
    profiles.default.userSettings = {
      "chat.disableAIFeatures" = true;
      "editor.rulers" = [ 100 ];
      "editor.wordWrap" = "bounded";
      "editor.wordWrapColumn" = 100;
      "editor.wrappingIndent" = "indent";
      "files.insertFinalNewline" = true;
      "git.terminalGitEditor" = true;
      "terminal.integrated.allowChords" = false;
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Default High Contrast";
      "workbench.editor.pinnedTabsOnSeparateRow" = true;
      "workbench.list.openMode" = "doubleClick";
    };
  };
}
