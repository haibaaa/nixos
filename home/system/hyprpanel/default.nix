# Hyprpanel is the bar on top of the screen
# Display information like workspaces, battery, wifi, ...
{
  config,
  lib,
  ...
}: let
  transparentButtons = config.theme.bar.transparentButtons;

  accent = "#${config.lib.stylix.colors.base0D}";
  accent-alt = "#${config.lib.stylix.colors.base03}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
  foregroundOnWallpaper = "#${config.theme.textColorOnWallpaper}";
  font = "${config.stylix.fonts.serif.name}";
  fontSizeForHyprpanel = "${toString config.stylix.fonts.sizes.desktop}px";

  rounding = config.theme.rounding;
  border-size = config.theme.border-size;

  gaps-out = config.theme.gaps-out;
  gaps-in = config.theme.gaps-in;

  floating = config.theme.bar.floating;
  transparent = config.theme.bar.transparent;
  position = config.theme.bar.position; # "top" ou "bottom"

  notificationOpacity = 90;

  location = config.var.location;

  homeDir = "/home/${config.var.username}";
in {
  wayland.windowManager.hyprland.settings.exec-once = ["hyprpanel"];

  programs.hyprpanel = {
    enable = true;

    settings = {
      # Keep media module but hide the text label
      bar.layouts = {
        "*" = {
          left = ["dashboard" "workspaces" "windowtitle"];
          middle = ["media" "cava"];
          right = [
            "systray"
            "volume"
            "bluetooth"
            "battery"
            "network"
            "clock"
            "notifications"
          ];
        };
      };

      bar.media = {
        format = ""; # Empty format string
        label = false;
        truncation = true;
        truncation_size = 0;
        show_active_only = true;
      };

      theme.font.name = font;
      theme.font.size = fontSizeForHyprpanel;

      theme.bar.outer_spacing =
        if floating && transparent
        then "0px"
        else "8px";
      theme.bar.buttons.y_margins =
        if floating && transparent
        then "0px"
        else "8px";
      theme.bar.buttons.spacing = "0.3em";
      theme.bar.buttons.radius =
        (
          if transparent
          then toString rounding
          else toString (rounding - 8)
        )
        + "px";
      theme.bar.floating = floating;
      theme.bar.buttons.padding_x = "0.8rem";
      theme.bar.buttons.padding_y = "0.4rem";

      theme.bar.margin_top =
        (
          if position == "top"
          then toString (gaps-in * 2)
          else "0"
        )
        + "px";
      theme.bar.margin_bottom =
        (
          if position == "top"
          then "0"
          else toString (gaps-in * 2)
        )
        + "px";
      theme.bar.margin_sides = toString gaps-out + "px";
      theme.bar.border_radius = toString rounding + "px";
      theme.bar.transparent = transparent;
      theme.bar.location = position;
      theme.bar.dropdownGap = "4.5em";
      theme.bar.menus.shadow =
        if transparent
        then "0 0 0 0"
        else "0px 0px 3px 1px #16161e";
      theme.bar.buttons.style = "default";
      theme.bar.buttons.monochrome = true;
      theme.bar.menus.monochrome = true;
      theme.bar.menus.card_radius = toString rounding + "px";
      theme.bar.menus.border.size = toString border-size + "px";
      theme.bar.menus.border.radius = toString rounding + "px";
      theme.bar.menus.menu.media.label = false;
      theme.bar.menus.menu.media.card.tint = 90;

      bar.launcher.icon = "";
      bar.workspaces.show_numbered = false;
      bar.workspaces.workspaces = 5;
      bar.workspaces.numbered_active_indicator = "color";
      bar.workspaces.monitorSpecific = false;
      bar.workspaces.applicationIconEmptyWorkspace = "";
      bar.workspaces.showApplicationIcons = true;
      bar.workspaces.showWsIcons = true;

      bar.windowtitle.label = true;
      bar.volume.label = false;
      bar.network.truncation_size = 12;
      bar.bluetooth.label = false;
      bar.clock.format = "%a %b %d  %I:%M %p";
      bar.notifications.show_total = true;

      bar.customModules.updates.pollingInterval = 1440000;
      bar.customModules.cava.showIcon = false;
      bar.customModules.cava.stereo = true;
      bar.customModules.cava.showActiveOnly = true;

      notifications.position = "top right";
      notifications.showActionsOnHover = true;
      theme.notification.opacity = notificationOpacity;
      theme.notification.enableShadow = true;
      theme.notification.border_radius = toString rounding + "px";

      theme.osd.enable = true;
      theme.osd.orientation = "vertical";
      theme.osd.location = "left";
      theme.osd.radius = toString rounding + "px";
      theme.osd.margins = "0px 0px 0px 10px";
      theme.osd.muted_zero = true;

      menus.clock.weather.location = location;
      menus.clock.weather.unit = "metric";
      menus.dashboard.powermenu.confirmation = false;
      menus.dashboard.powermenu.avatar.image = "~/.face.icon";

      menus.dashboard.shortcuts.left.shortcut1.icon = "";
      menus.dashboard.shortcuts.left.shortcut1.command = "zen";
      menus.dashboard.shortcuts.left.shortcut1.tooltip = "Zen";
      menus.dashboard.shortcuts.left.shortcut2.icon = "󰅶";
      menus.dashboard.shortcuts.left.shortcut2.command = "caffeine";
      menus.dashboard.shortcuts.left.shortcut2.tooltip = "Caffeine";
      menus.dashboard.shortcuts.left.shortcut3.icon = "󰖔";
      menus.dashboard.shortcuts.left.shortcut3.command = "night-shift";
      menus.dashboard.shortcuts.left.shortcut3.tooltip = "Night-shift";
      menus.dashboard.shortcuts.left.shortcut4.icon = "";
      menus.dashboard.shortcuts.left.shortcut4.command = "menu";
      menus.dashboard.shortcuts.left.shortcut4.tooltip = "Search Apps";

      menus.dashboard.shortcuts.right.shortcut1.icon = "";
      menus.dashboard.shortcuts.right.shortcut1.command = "hyprpicker -a";
      menus.dashboard.shortcuts.right.shortcut1.tooltip = "Color Picker";

      menus.dashboard.shortcuts.right.shortcut3.icon = "󰄀";
      menus.dashboard.shortcuts.right.shortcut3.command = "screenshot region swappy";
      menus.dashboard.shortcuts.right.shortcut3.tooltip = "Screenshot";

      menus.dashboard.directories.left.directory1.label = "     Home";
      menus.dashboard.directories.left.directory1.command = "xdg-open ${homeDir}";

      menus.dashboard.directories.left.directory3.label = "󰉍     Downloads";
      menus.dashboard.directories.left.directory3.command = "xdg-open ${homeDir}/Downloads";

      menus.power.lowBatteryNotification = true;

      wallpaper.enable = false;

      theme.bar.buttons.workspaces.hover = lib.mkForce accent-alt;
      theme.bar.buttons.workspaces.active = lib.mkForce accent;
      theme.bar.buttons.workspaces.available = lib.mkForce accent-alt;
      theme.bar.buttons.workspaces.occupied = lib.mkForce accent-alt;

      theme.bar.menus.background = lib.mkForce background;
      theme.bar.menus.cards = lib.mkForce background-alt;
      theme.bar.menus.label = lib.mkForce foreground;
      theme.bar.menus.text = lib.mkForce foreground;
      theme.bar.menus.border.color = lib.mkForce accent;
      theme.bar.menus.popover.text = lib.mkForce foreground;
      theme.bar.menus.popover.background = lib.mkForce background-alt;
      theme.bar.menus.listitems.active = lib.mkForce accent;
      theme.bar.menus.icons.active = lib.mkForce accent;
      theme.bar.menus.switch.enabled = lib.mkForce accent;
      theme.bar.menus.check_radio_button.active = lib.mkForce accent;
      theme.bar.menus.buttons.default = lib.mkForce accent;
      theme.bar.menus.buttons.active = lib.mkForce accent;
      theme.bar.menus.iconbuttons.active = lib.mkForce accent;
      theme.bar.menus.progressbar.foreground = lib.mkForce accent;
      theme.bar.menus.slider.primary = lib.mkForce accent;
      theme.bar.menus.tooltip.background = lib.mkForce background-alt;
      theme.bar.menus.tooltip.text = lib.mkForce foreground;
      theme.bar.menus.dropdownmenu.background = lib.mkForce background-alt;
      theme.bar.menus.dropdownmenu.text = lib.mkForce foreground;

      theme.bar.background =
        background
        + (
          if transparentButtons && transparent
          then "00"
          else ""
        );
      theme.bar.buttons.text =
        if transparent && transparentButtons
        then
          lib.mkForce
          foregroundOnWallpaper
        else
          lib.mkForce
          foreground;
      theme.bar.buttons.background =
        (
          if transparent
          then background
          else background-alt
        )
        + (
          if transparentButtons
          then "00"
          else ""
        );
      theme.bar.buttons.icon = accent;

      theme.bar.buttons.notifications.background = lib.mkForce background-alt;
      theme.bar.buttons.hover = lib.mkForce background;
      theme.bar.buttons.notifications.hover = lib.mkForce background;
      theme.bar.buttons.notifications.total = accent;
      theme.bar.buttons.notifications.icon = accent;

      theme.osd.bar_color = accent;
      theme.osd.bar_overflow_color = accent-alt;
      theme.osd.icon = background;
      theme.osd.icon_container = accent;
      theme.osd.label = accent;
      theme.osd.bar_container = background-alt;

      theme.bar.menus.menu.media.background.color = lib.mkForce background-alt;
      theme.bar.menus.menu.media.card.color = lib.mkForce background-alt;

      theme.notification.background = lib.mkForce background-alt;
      theme.notification.actions.background = lib.mkForce accent;
      theme.notification.actions.text = lib.mkForce foreground;
      theme.notification.label = lib.mkForce accent;
      theme.notification.border = lib.mkForce background-alt;
      theme.notification.text = lib.mkForce foreground;
      theme.notification.labelicon = lib.mkForce accent;
      theme.notification.close_button.background = lib.mkForce background-alt;
      theme.notification.close_button.label = lib.mkForce "#f38ba8";
    };
  };
}
