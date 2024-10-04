#!/bin/sh

set -x

shortcut_applied() {
    # Check if user confirmed overriding shortcuts
    if test -f "./.confirm_shortcut_change"; then
        echo "Shortcut change already confirmed"
        return 0
    fi

    read -p "Pop shell will override your default shortcuts. Are you sure? (y/n) " CONT
    if test "$CONT" = "y"; then
        touch "./.confirm_shortcut_change"
        return 1
    else
        echo "Cancelled"
        return 0
    fi
}

set_keybindings() {
    if shortcut_applied; then
        return 0
    fi

    left="h"
    down="j"
    up="k"
    right="l"

    KEYS_GNOME_WM=org.gnome.desktop.wm.keybindings
    KEYS_GNOME_SHELL=org.gnome.shell.keybindings
    KEYS_MUTTER=org.gnome.mutter.keybindings
    KEYS_MEDIA=org.gnome.settings-daemon.plugins.media-keys
    KEYS_MUTTER_WAYLAND_RESTORE="org.gnome.mutter.wayland.keybindings restore-shortcuts"

    # Disable incompatible shortcuts
    # Restore the keyboard shortcuts: disable <Super>Escape
    gsettings set ${KEYS_MUTTER_WAYLAND_RESTORE} "@as []"
    # Hide window: disable <Super>h
    gsettings set ${KEYS_GNOME_WM} minimize "@as ['<Super>comma']"
    # Open the application menu: disable <Super>m
    gsettings set ${KEYS_GNOME_SHELL} open-application-menu "@as []"
    # Toggle message tray: disable <Super>m
    gsettings set ${KEYS_GNOME_SHELL} toggle-message-tray "@as ['<Super>v']"
    # Show the activities overview: disable <Super>s
    gsettings set ${KEYS_GNOME_SHELL} toggle-overview "@as []"
    # Switch to workspace left: disable <Super>Left
    gsettings set ${KEYS_GNOME_WM} switch-to-workspace-left "@as []"
    # Switch to workspace right: disable <Super>Right
    gsettings set ${KEYS_GNOME_WM} switch-to-workspace-right "@as []"
    # Maximize window: disable <Super>Up
    gsettings set ${KEYS_GNOME_WM} maximize "@as []"
    # Restore window: disable <Super>Down
    gsettings set ${KEYS_GNOME_WM} unmaximize "@as []"
    # Move to monitor up: disable <Super><Shift>Up
    gsettings set ${KEYS_GNOME_WM} move-to-monitor-up "@as []"
    # Move to monitor down: disable <Super><Shift>Down
    gsettings set ${KEYS_GNOME_WM} move-to-monitor-down "@as []"
    # Disable tiling to left / right of screen
    gsettings set ${KEYS_MUTTER} toggle-tiled-left "@as []"
    gsettings set ${KEYS_MUTTER} toggle-tiled-right "@as []"
    # Move window one monitor to the left
    gsettings set ${KEYS_GNOME_WM} move-to-monitor-left "@as []"
    # Move window one workspace down
    gsettings set ${KEYS_GNOME_WM} move-to-workspace-down "@as []"
    # Move window one workspace up
    gsettings set ${KEYS_GNOME_WM} move-to-workspace-up "@as []"
    # Move window one monitor to the right
    gsettings set ${KEYS_GNOME_WM} move-to-monitor-right "@as []"

    # Super + Ctrl + direction keys, change workspaces, move focus between monitors
    # Move to workspace below
    gsettings set ${KEYS_GNOME_WM} switch-to-workspace-down "['<Super><Alt>Down','<Super><Alt>${down}']"
    # Move to workspace above
    gsettings set ${KEYS_GNOME_WM} switch-to-workspace-up "['<Super><Alt>Up','<Super><Alt>${up}']"
    # Move to workspace right
    gsettings set ${KEYS_GNOME_WM} switch-to-workspace-right "['<Super><Alt>Right','<Super><Alt>${right}']"
    # Move to workspace left
    gsettings set ${KEYS_GNOME_WM} switch-to-workspace-left "['<Super><Alt>Left','<Super><Alt>${left}']"

    # Super + Ctrl + Shift + direction keys, move window to a neighboring workspace/monitor
    # Move to workspace below
    gsettings set ${KEYS_GNOME_WM} move-to-workspace-down "['<Super><Shift><Alt>Down','<Super><Shift><Alt>${down}']"
    # Move to workspace above
    gsettings set ${KEYS_GNOME_WM} move-to-workspace-up "['<Super><Shift><Alt>Up','<Super><Shift><Alt>${up}']"
    # Move to workspace right
    gsettings set ${KEYS_GNOME_WM} move-to-workspace-right "['<Super><Shift><Alt>Right','<Super><Shift><Alt>${right}']"
    # Move to workspace left
    gsettings set ${KEYS_GNOME_WM} move-to-workspace-left "['<Super><Shift><Alt>Left','<Super><Shift><Alt>${left}']"

    for i in {1..10}
    do
        # Disable application switching
        gsettings set ${KEYS_GNOME_SHELL} switch-to-application-${i} "@as []"
        # Super + number, change workspace
        gsettings set ${KEYS_GNOME_WM} switch-to-workspace-${i} "['<Super>${i}']"
        # Super + Shift + number, move window to workspace
        gsettings set ${KEYS_GNOME_WM} move-to-workspace-${i} "['<Super><Shift>${i}']"
    done

    # Toggle maximization state
    gsettings set ${KEYS_GNOME_WM} toggle-maximized "['<Super>m']"
    # Lock screen
    gsettings set ${KEYS_MEDIA} screensaver "['<Super>Escape']"
    # Home folder
    gsettings set ${KEYS_MEDIA} home "['<Super>f']"
    # Launch email client
    gsettings set ${KEYS_MEDIA} email "['<Super>e']"
    # Launch web browser
    gsettings set ${KEYS_MEDIA} www "['<Super>b']"
    # Rotate Video Lock
    gsettings set ${KEYS_MEDIA} rotate-video-lock-static "@as []"

    # Close Window
    gsettings set ${KEYS_GNOME_WM} close "['<Super>q', '<Alt>F4']"
}

set_keybindings
