{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Applications
    anki
    woeusb
    opencode
    vlc
    blanket
    obsidian
    planify
    gnome-calendar
    textpieces
    curtail
    resources
    gnome-clocks
    gnome-text-editor
    session-desktop
    shotcut
    linux-wifi-hotspot
    ghostty
    caligula
  ];
}
