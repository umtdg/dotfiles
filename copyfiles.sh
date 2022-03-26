rsync -avAHX --include-from=filelist.txt $HOME/ files/
dconf dump /org/gnome/shell/extensions/ > extension-settings.dconf
dconf dump /org/gnome/desktop/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf
