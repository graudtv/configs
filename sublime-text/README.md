## sublime-text configuration
### Installation
No script provided. Manually copy needed files to sublime-text user packages folder (see sections below).
Configuration is tested on Sublime Text 4, but most of features, except relative line numbers, probably work in Sublime Text 3 too

### Contents description

- __Package Control.sublime-settings__ - used only for tracking installed packages.
Should NOT be copied. Install listed packages by yourself using Package Control

- __Preferences.sublime-settings__ - enables vim-mode (NeoVintageous), sets some
viewing properties, like text size, indentation style, etc

- __neovintageousrc__ - configuration file for NeoVintageous (like 'vimrc' to normal vim)
it should be installed as .neovintageous in Sublime Text package directory

- __Default.sublime-keymap__ - additional bindings for packages, which are not
part of NeoVintageous, like Clang Format and AceJump

- __Anaconda.sublime-settings__ - some setup for python. Could be safely ignored,
if not needed

### Where to install?
Paths may slightly change depending on Sublime Text version
- __OS X__ - ```~/Library/ApplicationSupport/Sublime\ Text\ 3/Packages/User```
- __Linux, Windows__ - TBD
