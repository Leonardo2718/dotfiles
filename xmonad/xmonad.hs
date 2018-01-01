{-
Leonardo Banderali's xmonad config file.

After editing this file, use `mod+q` to restart xmonad
-}

--imports~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import XMonad hiding ( (|||) )              -- don't use the normal `|||` operator
import XMonad.Layout.LayoutCombinators      -- use the `|||` from LayoutCombinators instead
import XMonad.Hooks.DynamicLog              --used for status bar
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks             --used for status bar
import XMonad.Util.Run(spawnPipe)           --used to start xmobar
import System.IO(hPutStrLn)
import XMonad.Util.EZConfig(additionalKeys) --needed for `additionalKeys`
import Graphics.X11.ExtraTypes.XF86         --needed for `xF86XK_AudioLowerVolume` and `xF86XK_AudioRaiseVolume`
import XMonad.Layout.PerWorkspace           --configure layouts on a per-workspace basis

--additional layouts
import XMonad.Layout.Grid
import XMonad.Layout.OneBig
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane

import XMonad.Util.WorkspaceCompare
import XMonad.Util.NamedWindows

import XMonad.Layout.LayoutModifier
import XMonad.Hooks.UrgencyHook

--import System.Taffybar.Hooks.PagerHints (pagerHints)


--the basics~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

myTerminal = "termite"  --set my preferred terminal
myModMask = mod4Mask    --set the modMask key to be the "windows key"


--status bar~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

myStatusBar = "xmobar ~/.xmobarrc"
myLogHook h = dynamicLogWithPP xmobarPP
    { ppOutput = hPutStrLn h
    , ppOrder = \(ws:l:_) -> [ws,l] --only show current workspace and layout
    }


--key bindings~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{-
use the `xev`/`showkey`/`evemu-describe` command to get key names
-}

myKeys = [ --((0, xK_Print), spawn "scrot -q 100")                            --take screenshot when 'Prt sc' is pressed
         --, ((0, xK_Alt_L .|. xK_Print), spawn "scrot -s -q 100")            --select an area using the mouse and take a screenshot of it

           ((myModMask, xK_p), spawn "dmenu_run -fn 'xft:Inconsolata:size=8:normal:antialias=true' -nb 'black' -nf 'yellow' -sb 'yellow' -sf 'black'")
         , ((myModMask, xK_l), spawn "light-locker-command --lock")     -- lock screen
         , ((myModMask, xK_s), spawn "systemctl suspend")               -- suspend computer

         --media controls (for when hardware defaults don't work)
         , ((0, xF86XK_AudioRaiseVolume)  , spawn "pamixer -i 2")    -- increase volume by 2%
         , ((0, xF86XK_AudioLowerVolume)  , spawn "pamixer -d 2")    -- decrease volume by 2%
         , ((0, xF86XK_AudioMute)         , spawn "pamixer -t")      -- toggle audio mute
         , ((0, xF86XK_AudioMicMute)      , spawn "pactl set-source-mute 1 toggle") -- toggle microphone mute
         , ((0, xF86XK_MonBrightnessUp)   , spawn "light -A 2")      -- increase backlight brightness by 2%
         , ((0, xF86XK_MonBrightnessDown) , spawn "light -U 2")      -- decrease backlight brightness by 2%

         --layout controls
         --, ((myModMask .|. mod1Mask, xK_g), sendMessage $ JumpToLayout "Grid")
         --, ((myModMask .|. mod1Mask, xK_o), sendMessage $ JumpToLayout "OneBig 0.75 0.75")
         --, ((myModMask .|. mod1Mask, xK_f), sendMessage $ JumpToLayout "Simple Float")
         --, ((myModMask .|. mod1Mask, xK_t), sendMessage $ JumpToLayout "Tabbed Simplest")
         --, ((myModMask .|. mod1Mask, xK_c), sendMessage $ JumpToLayout "MultiCol")
         ]


--layout hook~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
myLayoutHook = onWorkspace "1" terminalLayout $ onWorkspace "2" internetLayout $ onWorkspace "3" devGrid $ onWorkspace "4" devGrid$ onWorkspace "5" devLayout $ onWorkspace "6" devLayout $ onWorkspace "7" floatingLayout $ onWorkspace "8" floatingLayout $ standardLayout where
    terminalLayout  = Grid ||| myTall ||| Full
    internetLayout  = Full ||| simpleTabbed ||| simpleFloat
    devLayout       = Full ||| myTwoPane ||| myTall ||| Grid
    devGrid         = Grid ||| Full ||| myTall ||| myTwoPane
    floatingLayout  = simpleFloat ||| simpleTabbed
    standardLayout  = myTall ||| Mirror myTall ||| Full ||| Grid ||| OneBig (1/2) (1/2) ||| simpleFloat ||| simpleTabbed

    myTwoPane       = TwoPane delta masterPortion where
        masterPortion = 1/2
        delta = 3/100
    myTall          = Tall nmaster delta ratio  where   -- default tiling algorithm partitions the screen into two panes
        nmaster = 1                                     -- The default number of windows in the master pane
        delta   = 1/100                                 -- Percent of screen to increment by when resizing panes
        ratio   = 1/2                                   -- Default proportion of screen occupied by master pane


--management hook~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{-
use `xprop` to get a "className" or "appName"
-}

myManageHook = composeAll
    [ className =? "Firefox"        --> doShift "2" -- move Firefox to workspace 2
    , className =? "vivaldi-stable" --> doShift "2"
    , className =? "qutebrowser"    --> doShift "2"
    , className =? "Slack"          --> doShift "2"
    , className =? "QtCreator"      --> doShift "5"
    , title     =? "Encryptr"       --> doShift "7"
    , className =? "Keepassx2"      --> doShift "7"
    , className =? "KeePass2"       --> doShift "7"
    --, className =? "VirtualBox" --> doFloat
    --, className =? "Gimp"       --> doFloat
    ]


--startup hook~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

myStartupHook :: X ()
myStartupHook = do
    spawn "compton -CGb"            -- load compositor
    spawn "xrdb ~/.Xresources"      -- load X resources for this session
    spawn "sh ~/.fehbg"             -- set a wallpaper using feh
    --spawn "xscreensaver -no-splash" -- start `xscreensaver`
    spawn "light-locker"            -- start `light-locker`
    spawn "stalonetray"             -- load stalonetray system tray
    --spawn "xsetroot -cursor_name left_ptr"  --use a "normal" cursor


--run xmonad~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

main = do
    din <- spawnPipe myStatusBar
    xmonad $ defaultConfig
        { terminal          = myTerminal
        , modMask           = myModMask
        , focusFollowsMouse = False

        -- border
        , borderWidth       = 1
        , normalBorderColor = "#333333"
        , focusedBorderColor= "#0000FF"

        -- status bar
        , layoutHook        = avoidStruts $ myLayoutHook
        , logHook           = myLogHook din
        , handleEventHook   = docksEventHook <+> handleEventHook defaultConfig

        -- other hooks
        , manageHook        = myManageHook <+> manageDocks <+> manageHook defaultConfig
        , startupHook       = myStartupHook
        }
        `additionalKeys` myKeys
