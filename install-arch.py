#! /usr/bin/python

import argparse
import subprocess

base     = ["base", "base-devel", "python", "lua", "vim", "git", "reflector", "openssh", "zsh", "ttf-inconsolata", "vim-colorsamplerpack", "ntfs-3g"]
devel    = ["clang", "qt5", "cmake", "valgrind", "gdb", "llvm", "lldb", "boost", "ninja"]
haskell  = ["ghc", "cabal-install", "haskell-haddock-api", "haskell-haddock-library", "happy", "alex"]
lua      = ["luarocks", "luajit"]
rust     = ["rustup"]
termapps = ["htop", "ncdu", "the_silver_searcher", "pamixer", "evemu", "udevil"]
termweb  = ["openvpn", "openresolv"]
gui      = ["lightdm", "lightdm-gtk-greeter", "lightdm-gtk-greeter-settings", "arc-gtk-theme", "breeze-gtk", "deepin-gtk-theme", "light-locker", "cinnamon", "haskell-xmonad", "haskell-xmonad-contrib", "stalonetray", "dmenu", "xmobar", "compton", "feh"]
guidevel = ["qtcreator"]
guiapps  = ["termite", "mirage", "vlc", "atom", "howl", "keepassx2", "firefox", "thunderbird"]
guiweb   = ["qutebrowser", "syncthing", "transmission-qt"]
latex    = ["texlive-most", "texstudio"]
pdf      = ["apvlv", "epdfview", "mupdf"]
other    = ["hplip"]
aur      = ["encryptr", "gnucash", "light"]
aur_other= ["onlyoffice-bin"]

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install my custom Arch Linux packages")
    parser.add_argument("installType", choices=["term", "gui", "full", "extra"], help="installation type (only some are currently supported)")
    parser.add_argument("dest", type=str, help="destination directory of the installation")
    args = parser.parse_args()

    cmd = ["pacstrap", args.dest]

    if args.installType == "term":
        cmd = cmd + base + devel + haskell + lua + rust + termapps
    elif args.installType == "gui":
        cmd = cmd + base + devel + haskell + lua + rust + termapps + gui + guidevel + guiapps
    elif args.installType == "full":
        cmd = cmd + base + devel + haskell + lua + rust + termapps + gui + guidevel + guiapps + webapps + pdf + latex
    else:
        print('Sorry, "{}" install is not currently supported :/'.format(args.installType))
        exit(1)

    print("> ", " ".join(cmd))
    subprocess.run(cmd)
