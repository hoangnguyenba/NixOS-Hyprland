# 💫 https://github.com/JaKooLit 💫 #
# Users - NOTE: Packages defined on this will be on current user only

{ pkgs, username, lib, ... }:

let
  inherit (import ./variables.nix) gitUsername;
  zenBrowserAppImage = builtins.fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/latest/download/zen-x86_64.AppImage";
    sha256 = "16k37ngl4qpqwwj6f9q8jpn20pk8887q8zc0l7qivshmhfib36qq";
  };
in
{
  users = { 
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video" 
        "input" 
        "audio"
      ];

    # define user packages here
    packages = with pkgs; [
      ];
    };
    
    defaultUserShell = pkgs.zsh;
  }; 
  
  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ 
    fzf
    vscode
    google-chrome
    warp-terminal
    bat
    zoxide
    eza
    yazi
    appimage-run
    bottles
    code-cursor
    quickemu
  ]; 

  # Add Zen Browser desktop entry
  environment.etc."applications/zen-browser.desktop" = {
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Zen Browser
      GenericName=Web Browser
      Comment=Zen Browser
      Exec=appimage-run ${zenBrowserAppImage}
      Terminal=false
      Categories=Network;WebBrowser;
      Keywords=web;browser;internet;
    '';
    mode = "0644";
  };
    
  programs = {
    # Zsh configuration remains the same...
    zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "funky"; 
      };
      
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      promptInit = ''
        fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
        source <(fzf --zsh);
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
      '';
    };

  };

  users.groups.libvirtd.members = ["${username}"];  
}