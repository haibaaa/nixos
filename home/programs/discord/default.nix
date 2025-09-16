# Discord is a popular chat application.
{inputs, ...}: {
  imports = [inputs.nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    dorion.enable = true;
    vesktop.enable = true;
    config = {
      themeLinks = [
        "https://refact0r.github.io/system24/build/system24.css"
      ];
      frameless = true;
    };
    dorion = {
      theme = "dark";
      zoom = "1.1";
      blur = "acrylic"; # "none", "blur", or "acrylic"
      sysTray = false;
      openOnStartup = false;
      autoClearCache = true;
      disableHardwareAccel = false;
      rpcServer = true;
      rpcProcessScanner = true;
      pushToTalk = true;
      pushToTalkKeys = ["RControl"];
      desktopNotifications = true;
      unreadBadge = true;
    };
  };
}
