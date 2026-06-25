{ ... }: {
  home-manager.users.matte.imports = [
    ./profiles/programming/kilo/gemma4-12b.nix
    ./profiles/programming/kilo/gemma4-26b.nix
    ./profiles/programming/kilo/qwen3-5-9b.nix
  ];
}
