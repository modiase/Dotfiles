# Dotfiles

A repository containing assorted configuration files to facilitate rapid
replication of my development setup on new machines.

## Frontend Dependencies

Frontend dependencies can primarily be installed using `brew --cask` on macos or by some other means on other platforms.
Required dependencies are:
    - Alacritty # Terminal emulator
    - font-iosevka-nerd-font # font used in alacritty

### Colors on MacOS

The TERM variable must be set `screen-256color` in order to correctly display colors on macos when inside of tmux.
